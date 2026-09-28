# Kontrak Data Tahap 2

## users
- id
- full_name
- email
- password/auth reference
- role
- phone
- photo_url
- is_active
- created_at
- updated_at

## school_profile
- id
- school_name
- npsn
- school_level
- address
- village
- district
- city
- province
- postal_code
- phone
- email
- website
- principal_name
- vision
- mission
- description
- school_logo
- created_at
- updated_at

## counselor_profile
- id
- user_id
- full_name
- title
- employee_id
- nip
- nuptk
- position
- school_id
- phone
- email
- photo_url
- education
- competency
- professional_description
- created_at
- updated_at

## documents
- id
- title
- description
- file_name
- file_url
- file_type
- file_size
- category
- subcategory
- uploaded_by
- related_module
- related_record_id
- created_at
- updated_at

## activity_logs
- id
- user_id
- action
- module
- record_id
- description
- ip_address (if available)
- created_at

## Seed awal
- SMP Negeri 11 Palu
- Jenjang: Sekolah Menengah Pertama
- Kota: Palu
- Provinsi: Sulawesi Tengah
- Guru BK: Nurhidayat Usman, S.Pd
- Jabatan: Guru Bimbingan dan Konseling

Tidak ada data siswa/kasus/layanan fiktif.
