-- Tahap 3 migration: Program BK, Konseli, Kebutuhan/Permasalahan
-- Jalankan setelah database/stage2.sql. Tidak menghapus atau mengubah tabel Tahap 2.

create table if not exists public.annual_programs (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.school_profile(id) on delete set null,
  counselor_id uuid references public.counselor_profile(id) on delete set null,
  academic_year text not null,
  program_name text not null,
  service_area text,
  service_type text,
  target text,
  class_level text,
  objective text,
  material text,
  activity text,
  method text,
  media text,
  schedule text,
  duration text,
  person_in_charge text,
  success_indicator text,
  realization_status text not null default 'Belum Dilaksanakan',
  realization_date date,
  result text,
  follow_up text,
  notes text,
  created_by uuid references public.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.semester_programs (
  id uuid primary key default gen_random_uuid(),
  annual_program_id uuid references public.annual_programs(id) on delete set null,
  academic_year text not null,
  semester text not null,
  month text,
  program_name text not null,
  service_area text,
  service_type text,
  target text,
  class_level text,
  objective text,
  material text,
  activity text,
  method text,
  media text,
  schedule text,
  duration text,
  success_indicator text,
  realization_status text not null default 'Belum Dilaksanakan',
  result text,
  follow_up text,
  notes text,
  created_by uuid references public.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.counselor_agendas (
  id uuid primary key default gen_random_uuid(),
  counselor_id uuid references public.counselor_profile(id) on delete set null,
  date date not null,
  start_time time,
  end_time time,
  activity text not null,
  category text not null,
  target text,
  class_level text,
  location text,
  objective text,
  result text,
  follow_up text,
  status text not null default 'Direncanakan',
  notes text,
  document_id uuid references public.documents(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.weekly_schedules (
  id uuid primary key default gen_random_uuid(),
  counselor_id uuid references public.counselor_profile(id) on delete set null,
  day_of_week text not null,
  start_time time,
  end_time time,
  activity text not null,
  class_level text,
  target text,
  service_type text,
  location text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.daily_schedules (
  id uuid primary key default gen_random_uuid(),
  counselor_id uuid references public.counselor_profile(id) on delete set null,
  date date not null,
  start_time time,
  end_time time,
  activity text not null,
  target text,
  class_level text,
  service_type text,
  location text,
  status text not null default 'Direncanakan',
  result text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.students (
  id uuid primary key default gen_random_uuid(),
  nis text unique,
  nisn text unique,
  full_name text not null,
  gender text,
  birth_place text,
  birth_date date,
  religion text,
  class_name text,
  address text,
  phone text,
  father_name text,
  mother_name text,
  parent_name text,
  parent_phone text,
  guardian_name text,
  guardian_phone text,
  guardian_address text,
  student_status text not null default 'Aktif',
  counselor_id uuid references public.counselor_profile(id) on delete set null,
  notes text,
  photo_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.student_needs_problems (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  counselor_id uuid references public.counselor_profile(id) on delete set null,
  date date not null default current_date,
  category text not null,
  sub_category text,
  description text not null,
  source_of_information text,
  severity text,
  priority text,
  initial_action text,
  follow_up text,
  status text not null default 'Baru',
  confidentiality_level text not null default 'CONFIDENTIAL',
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_annual_programs_year on public.annual_programs(academic_year);
create index if not exists idx_semester_programs_year_semester on public.semester_programs(academic_year,semester);
create index if not exists idx_agendas_date on public.counselor_agendas(date);
create index if not exists idx_weekly_counselor_day on public.weekly_schedules(counselor_id,day_of_week);
create index if not exists idx_daily_date on public.daily_schedules(date);
create index if not exists idx_students_class on public.students(class_name);
create index if not exists idx_students_counselor on public.students(counselor_id);
create index if not exists idx_problems_student on public.student_needs_problems(student_id);
create index if not exists idx_problems_category on public.student_needs_problems(category);
create index if not exists idx_problems_date on public.student_needs_problems(date);

-- Updated-at trigger shared by all Stage 3 tables.
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

drop trigger if exists trg_annual_programs_updated_at on public.annual_programs;
create trigger trg_annual_programs_updated_at before update on public.annual_programs for each row execute function public.set_updated_at();
drop trigger if exists trg_semester_programs_updated_at on public.semester_programs;
create trigger trg_semester_programs_updated_at before update on public.semester_programs for each row execute function public.set_updated_at();
drop trigger if exists trg_agendas_updated_at on public.counselor_agendas;
create trigger trg_agendas_updated_at before update on public.counselor_agendas for each row execute function public.set_updated_at();
drop trigger if exists trg_weekly_updated_at on public.weekly_schedules;
create trigger trg_weekly_updated_at before update on public.weekly_schedules for each row execute function public.set_updated_at();
drop trigger if exists trg_daily_updated_at on public.daily_schedules;
create trigger trg_daily_updated_at before update on public.daily_schedules for each row execute function public.set_updated_at();
drop trigger if exists trg_students_updated_at on public.students;
create trigger trg_students_updated_at before update on public.students for each row execute function public.set_updated_at();
drop trigger if exists trg_problems_updated_at on public.student_needs_problems;
create trigger trg_problems_updated_at before update on public.student_needs_problems for each row execute function public.set_updated_at();

alter table public.annual_programs enable row level security;
alter table public.semester_programs enable row level security;
alter table public.counselor_agendas enable row level security;
alter table public.weekly_schedules enable row level security;
alter table public.daily_schedules enable row level security;
alter table public.students enable row level security;
alter table public.student_needs_problems enable row level security;

-- Program/schedule data: authenticated users can read; only administrator/guru_bk can mutate.
drop policy if exists annual_read on public.annual_programs;
create policy annual_read on public.annual_programs for select using (auth.uid() is not null);
drop policy if exists annual_write on public.annual_programs;
create policy annual_write on public.annual_programs for all using (public.is_admin_or_counselor()) with check (public.is_admin_or_counselor());

drop policy if exists semester_read on public.semester_programs;
create policy semester_read on public.semester_programs for select using (auth.uid() is not null);
drop policy if exists semester_write on public.semester_programs;
create policy semester_write on public.semester_programs for all using (public.is_admin_or_counselor()) with check (public.is_admin_or_counselor());

drop policy if exists agenda_read on public.counselor_agendas;
create policy agenda_read on public.counselor_agendas for select using (auth.uid() is not null);
drop policy if exists agenda_write on public.counselor_agendas;
create policy agenda_write on public.counselor_agendas for all using (public.is_admin_or_counselor()) with check (public.is_admin_or_counselor());

drop policy if exists weekly_read on public.weekly_schedules;
create policy weekly_read on public.weekly_schedules for select using (auth.uid() is not null);
drop policy if exists weekly_write on public.weekly_schedules;
create policy weekly_write on public.weekly_schedules for all using (public.is_admin_or_counselor()) with check (public.is_admin_or_counselor());

drop policy if exists daily_read on public.daily_schedules;
create policy daily_read on public.daily_schedules for select using (auth.uid() is not null);
drop policy if exists daily_write on public.daily_schedules;
create policy daily_write on public.daily_schedules for all using (public.is_admin_or_counselor()) with check (public.is_admin_or_counselor());

-- Student and problem records are confidential: administrator, guru_bk and koordinator_bk only.
create or replace function public.can_view_confidential_bk()
returns boolean language sql stable security definer set search_path = public
as $$ select public.current_app_role() in ('administrator','guru_bk','koordinator_bk') $$;

drop policy if exists students_read_confidential on public.students;
create policy students_read_confidential on public.students for select using (public.can_view_confidential_bk());
drop policy if exists students_write_confidential on public.students;
create policy students_write_confidential on public.students for all using (public.is_admin_or_counselor()) with check (public.is_admin_or_counselor());

drop policy if exists problems_read_confidential on public.student_needs_problems;
create policy problems_read_confidential on public.student_needs_problems for select using (public.can_view_confidential_bk());
drop policy if exists problems_write_confidential on public.student_needs_problems;
create policy problems_write_confidential on public.student_needs_problems for all using (public.is_admin_or_counselor()) with check (public.is_admin_or_counselor());

-- Keep documents tied to Stage 3 records. Metadata remains protected by Stage 2 policies.
comment on table public.students is 'CONFIDENTIAL: data konseli/siswa asuh.';
comment on table public.student_needs_problems is 'CONFIDENTIAL: kebutuhan dan permasalahan konseli.';
