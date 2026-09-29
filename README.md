# Sistem Informasi Bimbingan dan Konseling — SMP Negeri 11 Palu

Sistem Informasi Bimbingan dan Konseling untuk mendukung pengelolaan administrasi BK secara terstruktur, aman, dan modular.

## Tahapan Pengembangan

### Tahap 1 — Fondasi Project
- Struktur repository
- Dokumentasi arsitektur
- Konfigurasi dasar aplikasi
- Struktur frontend/backend/database yang siap dikembangkan

### Tahap 2 — Fondasi Fungsional
- Database
- Login dan autentikasi
- Role-based access control
- Profil sekolah
- Profil Guru BK
- Dashboard
- Manajemen dokumen
- Audit aktivitas
- Keamanan dan protected routes

### Tahap 3 — Modul BK
- Program Tahunan
- Program Semester
- Agenda Kerja Konselor
- Jadwal Kegiatan Konselor
- Daftar Konseli
- Kebutuhan dan Permasalahan Konseli
- Modul pelayanan dan asesmen secara bertahap

## Identitas Awal

- Sekolah: SMP Negeri 11 Palu
- Jenjang: Sekolah Menengah Pertama
- Kota: Palu
- Provinsi: Sulawesi Tengah
- Guru BK: Nurhidayat Usman, S.Pd
- Jabatan: Guru Bimbingan dan Konseling

## Prinsip Pengembangan

Aplikasi dibangun sebagai sistem yang benar-benar terhubung antara frontend, backend, database, autentikasi, dan penyimpanan dokumen. Data siswa/konseli dan catatan konseling bersifat sensitif sehingga akses harus dibatasi berdasarkan peran pengguna.

> Catatan: data siswa, kasus, layanan, dan statistik tidak boleh dibuat sebagai data fiktif/dummy.
## Menjalankan Tahap 2

1. Buat project Supabase.
2. Jalankan seluruh isi `database/stage2.sql` pada SQL Editor.
3. Buat akun pengguna melalui Supabase Auth (Email/Password).
4. Setelah user dibuat, isi `public.users` dengan UUID user Auth, nama, email, dan role.
5. Isi `VITE_SUPABASE_URL` dan `VITE_SUPABASE_ANON_KEY` berdasarkan project Supabase.
6. Install dependency lalu jalankan `npm run dev`.

### Catatan keamanan
- Password tidak pernah disimpan di `public.users`; autentikasi ditangani Supabase Auth.
- Data dokumen menggunakan bucket Storage private `bk-documents`.
- Akses database memakai Row Level Security (RLS).
- Catatan audit disimpan di `activity_logs`.
- Statistik dashboard Tahap 2 tetap 0 sampai modul sumber datanya benar-benar dibuat.
- Data siswa, kasus, layanan, dan asesmen tidak dibuat sebagai dummy.

## Tahap 3 — Program BK dan Konseli

Jalankan `database/stage3.sql` setelah `database/stage2.sql`.

Modul aktif:
- Program Tahunan
- Program Semester + relasi Program Tahunan
- Agenda Kerja Konselor
- Jadwal Mingguan dan Harian
- Daftar Konseli / Siswa Asuh
- Profil Detail Konseli
- Kebutuhan & Permasalahan Konseli
- Search/filter
- CRUD dengan RBAC
- Upload lampiran ke private Storage
- Import/Export Excel
- Template Excel
- Statistik Dashboard dari database untuk konseli/permasalahan/program/kegiatan/dokumen
- Audit log

Data siswa dan permasalahan tidak di-seed. Semua angka dashboard membaca database; jika belum ada data nilainya 0.

Data `students` dan `student_needs_problems` diberi RLS confidential. Administrator/Guru BK dapat mengelola; Koordinator BK dapat membaca; Kepala Sekolah tidak diberikan akses ke menu konseli/permasalahan pada tahap ini.
