# Project: Sistem Pencarian dan Penyimpanan Lokasi Wisata (SPLW) Mobile

- **Mata Kuliah:** Pemrograman Mobile
- **Pengembang:** Zefhana Ananda (20240801047)
- **Program Studi:** Teknik Informatika, Fakultas Ilmu Komputer, Universitas Esa Unggul

## Dokumen Perancangan

| Dokumen | Isi |
| :--- | :--- |
| [`BRD_SPLW_MOBILE.pdf`](BRD_SPLW_MOBILE.pdf) | Latar belakang bisnis, stakeholder, use case, aturan bisnis **BR-01 s/d BR-17**, serta kebutuhan fungsional/non-fungsional |
| [`PRD_SPLW_MOBILE.pdf`](PRD_SPLW_MOBILE.pdf) | Persona, user story MoSCoW, backlog **PB-01 s/d PB-18**, roadmap, sitemap **S-01 s/d S-15**, kontrak API, mockup, acceptance criteria, dan rencana pengujian |

## Prototype Flutter

Prototype interaktif tersedia di [`prototype/`](prototype/README.md).

```bash
flutter run -d chrome -t lib/project/prototype/main.dart
```

Prototype mendemokan alur **S-01 s/d S-15** dan aturan **BR-01 s/d BR-17** memakai data mock in-memory. Belum ada backend FastAPI, database, peta OSM live, GPS perangkat, atau ekspor `.xlsx` nyata. Rincian status, akun demo, dan batasan ada di [`prototype/README.md`](prototype/README.md).

## Prototype Figma

**Link Figma:** [SPLW Mobile — UI/UX Design](https://www.figma.com/design/aVvksZdQLvnRKnkHQ4DP51/SPLW-Mobile-%E2%80%94-UI-UX-Design?node-id=82-1804)

Figma hanya berisi prototipe desain; tidak terhubung ke backend, peta live, atau data nyata.

## Catatan Dokumen

- BRD memuat **BR-01 s/d BR-17**.
- PRD memuat **FR-01 s/d FR-16** dan layar **S-01 s/d S-15**.
- Backlog PRD memuat **PB-01 s/d PB-18**.
