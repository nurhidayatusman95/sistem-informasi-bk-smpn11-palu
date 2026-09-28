# Arsitektur Project

## Tujuan

Menyiapkan fondasi yang modular untuk Sistem Informasi Bimbingan dan Konseling SMP Negeri 11 Palu.

## Lapisan Sistem

- Frontend: antarmuka responsif untuk desktop, laptop, tablet, dan smartphone.
- Backend/API: validasi, otorisasi, operasi data, dan audit aktivitas.
- Database: data pengguna, profil sekolah, profil konselor, dokumen, dan log aktivitas.
- Authentication: autentikasi aman dan role-based access control.
- Storage: penyimpanan dokumen dengan kontrol akses.
- UI: desain profesional, akademik, modern, bersih, dan konsisten.

## Role

- administrator
- guru_bk
- koordinator_bk
- kepala_sekolah

## Modul Navigasi

- Dashboard
- Program
- Kegiatan Pelayanan
- Aktivitas Pelayanan BK
- Pengembangan Diri
- Pelaporan
- Evaluasi
- Dokumen
- Pengaturan

Struktur modul disiapkan agar modul BK berikutnya dapat ditambahkan tanpa mengubah fondasi secara sembarangan.

## Keamanan

- Protected routes
- Role-based authorization
- Validasi input
- Secure file upload
- Audit log
- Session management
- Aturan keamanan database dan storage
- Tidak menyimpan password dalam plaintext

Catatan konseling individual dan data sensitif tidak ditampilkan pada dashboard publik; dashboard hanya menampilkan statistik agregat sesuai hak akses.
