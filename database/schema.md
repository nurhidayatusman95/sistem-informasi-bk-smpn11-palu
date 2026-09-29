# Kontrak Data Tahap 2 + Tahap 3

Tahap 2 tetap menjadi fondasi. Tahap 3 menambahkan tabel:
- annual_programs
- semester_programs
- counselor_agendas
- weekly_schedules
- daily_schedules
- students (CONFIDENTIAL)
- student_needs_problems (CONFIDENTIAL)

Relasi utama:
- school_profile -> annual_programs
- counselor_profile -> annual_programs / agendas / schedules / students / student_needs_problems
- annual_programs -> semester_programs
- students -> student_needs_problems
- documents -> related_module + related_record_id untuk lampiran modul

Jalankan `stage3.sql` setelah `stage2.sql`. Migrasi Tahap 3 tidak menghapus atau menggandakan tabel Tahap 2.
