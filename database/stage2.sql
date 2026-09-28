-- Tahap 2: PostgreSQL/Supabase schema + RLS
create extension if not exists pgcrypto;

create type public.app_role as enum ('administrator','guru_bk','koordinator_bk','kepala_sekolah');
create type public.document_category as enum ('Profil','Program','Konseli','Asesmen','Pelayanan','Pengembangan Diri','Pelaporan','Evaluasi','Lainnya');

create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null unique,
  role public.app_role not null default 'guru_bk',
  phone text,
  photo_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.school_profile (
  id uuid primary key default gen_random_uuid(),
  school_name text not null,
  npsn text unique,
  school_level text not null default 'Sekolah Menengah Pertama',
  address text,
  village text,
  district text,
  city text not null default 'Palu',
  province text not null default 'Sulawesi Tengah',
  postal_code text,
  phone text,
  email text,
  website text,
  principal_name text,
  vision text,
  mission text,
  description text,
  school_logo text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.counselor_profile (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.users(id) on delete cascade,
  full_name text not null,
  title text,
  employee_id text,
  nip text,
  nuptk text,
  position text,
  school_id uuid references public.school_profile(id) on delete set null,
  phone text,
  email text,
  photo_url text,
  education text,
  competency text,
  professional_description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  file_name text not null,
  file_url text not null,
  file_type text not null,
  file_size bigint not null default 0 check (file_size >= 0),
  category public.document_category not null default 'Lainnya',
  subcategory text,
  uploaded_by uuid not null references public.users(id) on delete restrict,
  related_module text,
  related_record_id uuid,
  archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.activity_logs (
  id bigint generated always as identity primary key,
  user_id uuid references public.users(id) on delete set null,
  action text not null,
  module text not null,
  record_id uuid,
  description text,
  ip_address inet,
  created_at timestamptz not null default now()
);

insert into public.school_profile (school_name, school_level, city, province, description)
select 'SMP Negeri 11 Palu','Sekolah Menengah Pertama','Palu','Sulawesi Tengah',
       'Profil awal sekolah untuk Sistem Informasi Bimbingan dan Konseling.'
where not exists (select 1 from public.school_profile);

-- Helper functions. Role is read from the profile table, never from client input.
create or replace function public.current_app_role()
returns public.app_role language sql stable security definer set search_path = public
as $$ select role from public.users where id = auth.uid() and is_active = true limit 1 $$;

create or replace function public.has_role(required_role public.app_role)
returns boolean language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.users where id=auth.uid() and is_active=true and role=required_role) $$;

create or replace function public.is_admin_or_counselor()
returns boolean language sql stable security definer set search_path = public
as $$ select public.current_app_role() in ('administrator','guru_bk') $$;

alter table public.users enable row level security;
alter table public.school_profile enable row level security;
alter table public.counselor_profile enable row level security;
alter table public.documents enable row level security;
alter table public.activity_logs enable row level security;

drop policy if exists users_self_or_admin on public.users;
create policy users_self_or_admin on public.users for select using (id=auth.uid() or public.has_role('administrator'));
drop policy if exists users_admin_manage on public.users;
create policy users_admin_manage on public.users for all using (public.has_role('administrator')) with check (public.has_role('administrator'));

drop policy if exists school_read_authenticated on public.school_profile;
create policy school_read_authenticated on public.school_profile for select using (auth.uid() is not null);
drop policy if exists school_manage_admin on public.school_profile;
create policy school_manage_admin on public.school_profile for all using (public.has_role('administrator')) with check (public.has_role('administrator'));

drop policy if exists counselor_read_authorized on public.counselor_profile;
create policy counselor_read_authorized on public.counselor_profile for select using (auth.uid() is not null);
drop policy if exists counselor_update_self_or_admin on public.counselor_profile;
create policy counselor_update_self_or_admin on public.counselor_profile for update using (user_id=auth.uid() or public.has_role('administrator')) with check (user_id=auth.uid() or public.has_role('administrator'));
drop policy if exists counselor_insert_admin_or_self on public.counselor_profile;
create policy counselor_insert_admin_or_self on public.counselor_profile for insert with check (user_id=auth.uid() or public.has_role('administrator'));

drop policy if exists documents_read_authorized on public.documents;
create policy documents_read_authorized on public.documents for select using (auth.uid() is not null);
drop policy if exists documents_write_bk_admin on public.documents;
create policy documents_write_bk_admin on public.documents for insert with check (public.is_admin_or_counselor() and uploaded_by=auth.uid());
create policy documents_update_bk_admin on public.documents for update using (public.is_admin_or_counselor()) with check (public.is_admin_or_counselor());
create policy documents_delete_bk_admin on public.documents for delete using (public.is_admin_or_counselor());

drop policy if exists logs_admin_read on public.activity_logs;
create policy logs_admin_read on public.activity_logs for select using (public.has_role('administrator'));
create policy logs_insert_authenticated on public.activity_logs for insert with check (auth.uid() is not null and user_id=auth.uid());

-- Storage bucket. File objects are private; app should issue signed URLs.
insert into storage.buckets (id, name, public)
values ('bk-documents','bk-documents',false)
on conflict (id) do update set public=false;

drop policy if exists bk_documents_read on storage.objects;
create policy bk_documents_read on storage.objects for select using (bucket_id='bk-documents' and auth.uid() is not null);
drop policy if exists bk_documents_insert on storage.objects;
create policy bk_documents_insert on storage.objects for insert with check (bucket_id='bk-documents' and public.is_admin_or_counselor());
drop policy if exists bk_documents_update on storage.objects;
create policy bk_documents_update on storage.objects for update using (bucket_id='bk-documents' and public.is_admin_or_counselor());
drop policy if exists bk_documents_delete on storage.objects;
create policy bk_documents_delete on storage.objects for delete using (bucket_id='bk-documents' and public.is_admin_or_counselor());
