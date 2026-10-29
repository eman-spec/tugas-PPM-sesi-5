# NusaEvent Hub 🎟️🏛️
> Aplikasi Manajemen Seminar, Workshop, & Reservasi Tiket Interaktif Berbasis Flutter.  
> **Tugas Praktikum Sesi 5 - Pemrograman Perangkat Bergerak (PPM)**

---

## 📌 Identitas Mahasiswa
- **Nama**: Soleeman Firdaus Ode
- **NIM**: 20240040253
- **Kelas / Prodi**: TI24G / Teknik Informatika
- **Mata Kuliah**: Pemrograman Perangkat Bergerak (PPM)
- **Sesi**: 5 (Form Input, Gestures, Custom Widgets, & Interactive Components)

---

## 📖 Deskripsi Proyek
**NusaEvent Hub** adalah aplikasi mobile manajemen seminar dan workshop teknologi nusantara yang dibangun menggunakan Flutter Material 3. Aplikasi ini dirancang secara komprehensif untuk mendemonstrasikan implementasi antarmuka interaktif, penanganan formulir (Form Handling) dengan validasi ketat, interaksi gestur (pan, pinch-to-zoom, swipe-to-dismiss), tab view dinamis, modal bottom sheet, serta custom canvas drawing untuk denah venue interaktif.

Aplikasi ini mencakup alur pengguna yang lengkap:
1. **Katalog Seminar & Workshop**: Menjelajahi berbagai event teknologi (AI, Mobile, IoT, Cybersecurity) dengan fitur pencarian real-time dan penyaringan berbasis chip kategori.
2. **Filter Bottom Sheet**: Membuka modal bottom sheet interaktif untuk memfilter kategori seminar dengan umpan balik visual instan.
3. **Formulir Pendaftaran Interaktif**: Mengisi data diri peserta dengan validasi lengkap (nama, NIM, email regex, nomor WhatsApp), pemilihan tipe peserta (`ChoiceChip`), pemilih tanggal kehadiran (`DatePicker`), paket seminar kit (`SwitchListTile`), donasi sukarela dengan kalkulasi biaya langsung, serta persetujuan tata tertib (`CheckboxListTile`).
4. **Galeri Poster & Denah Venue**:
   - **Galeri Poster**: Grid poster interaktif dengan animasi tap dialog detail.
   - **Denah Venue Interaktif**: Peta denah gedung berbasis `CustomPainter` yang dapat digeser dan diperbesar (`InteractiveViewer` pan & pinch-to-zoom), dilengkapi direktori lokasi ruangan event.
5. **Manajemen Tiket & Pembatalan**:
   - Menampilkan tiket yang berhasil didaftarkan lengkap dengan kode tiket unik (`NSE-XXXXXX-CAT`) dan rincian kehadiran.
   - Indikator jumlah tiket aktif secara real-time pada `Badge` di `NavigationBar`.
   - Pembatalan pendaftaran menggunakan gestur geser kiri (`Dismissible`) dengan dialog konfirmasi keamanan (`AlertDialog`).

---

## ✨ Fitur Utama & Widget yang Digunakan

| Kategori | Fitur / Komponen | Implementasi Widget Flutter |
|---|---|---|
| **Form & Validasi Input** | Validasi Nama, NIM, Email, & WhatsApp | `Form`, `TextFormField`, `TextEditingController`, `GlobalKey<FormState>`, `FilteringTextInputFormatter`, Regex Validator |
| **Pilihan & Seleksi** | Tipe Peserta (Mahasiswa, Dosen, dll) | `ChoiceChip`, `FilterChip`, `Wrap` |
| **Komponen Tanggal** | Pemilihan Tanggal Kehadiran | `showDatePicker`, `DateTime` formatting |
| **Toggle & Persetujuan** | Tambahan Seminar Kit & Persetujuan Tata Tertib | `SwitchListTile`, `CheckboxListTile`, `Card` |
| **Kalkulator Biaya Realtime** | Rincian Biaya Donasi & Kit | State updates dengan kalkulasi dinamis (`setState`) |
| **Penyaringan Event** | Filter Kategori & Search Realtime | `TextField`, `SingleChildScrollView`, `FilterChip`, `ModalBottomSheet` |
| **Navigasi Tab Bar** | Navigasi Antar Tab (Poster & Denah) | `TabBar`, `TabBarView`, `TabController` |
| **Navigasi Utama** | Bottom Bar dengan Notifikasi Badge | `NavigationBar`, `NavigationDestination`, `Badge`, `IndexedStack` |
| **Gestur & Interaktivitas** | Denah Venue Pan & Zoom | `InteractiveViewer`, `CustomPainter`, `Canvas` |
| **Gestur Pembatalan** | Geser Tiket untuk Batalkan | `Dismissible` (end-to-start) dengan `confirmDismiss` & `AlertDialog` |
| **Umpan Balik Pengguna** | Feedback Notifikasi Sukses / Batal | Floating `SnackBar` dengan border radius & ikon kustom |

---

## 🏗️ Struktur Direktori Proyek

```text
tugas_sesi_5/
├── lib/
│   ├── data/
│   │   └── sample_events.dart        # Dataset seminar, workshop, poster, dan denah
│   ├── models/
│   │   ├── event_item.dart           # Model data EventItem (kapasitas, ketersediaan, rasio okupansi)
│   │   └── registration_ticket.dart  # Model data RegistrationTicket (kode tiket, rincian biaya, status)
│   ├── screens/
│   │   ├── home_events_screen.dart   # Katalog event, pencarian, chip kategori, & modal filter
│   │   ├── event_registration_screen.dart # Formulir pendaftaran lengkap dengan validasi
│   │   ├── gallery_venue_screen.dart # Galeri poster & tab denah venue interaktif
│   │   └── registered_tickets_screen.dart # Manajemen tiket aktif dengan gestur Dismissible
│   ├── widgets/
│   │   ├── event_card.dart           # Kartu event dengan progress bar kapasitas & tema warna dinamis
│   │   ├── filter_bottom_sheet.dart  # Modal bottom sheet untuk opsi penyaringan kategori
│   │   └── venue_map_viewer.dart     # CustomPainter & InteractiveViewer untuk denah venue
│   └── main.dart                     # Entry point aplikasi, theme Material 3, & MainScaffold NavigationBar
├── test/
│   └── widget_test.dart              # Test suite automated (unit testing model & widget test alur)
└── pubspec.yaml                      # Konfigurasi dependensi dan aset aplikasi
```

---

## 🧪 Pengujian Otomatis (Automated Testing)

Proyek ini dilengkapi dengan pengujian otomatis komprehensif yang mencakup pengujian unit (unit tests) dan pengujian widget (widget tests):

1. **Unit Tests**:
   - Pengujian kalkulasi model `EventItem` (`isAvailable`, `availableSlots`, `occupancyRate` beserta edge cases).
   - Pengujian kalkulasi biaya `RegistrationTicket` (`totalCost`) dan format generasi kode tiket unik (`NSE-XXXXXX-CAT`).
   - Validasi kelengkapan dataset `sampleEvents`.
2. **Widget Tests**:
   - Render awal aplikasi `NusaEventHubApp` dan tab utama.
   - Fungsionalitas pencarian real-time dan penyaringan event.
   - Transisi navigasi bottom bar (`Home` -> `Galeri` -> `Tiket`).
   - Interaksi modal dialog poster dan Denah Venue interaktif.
   - Pembukaan dan penerapan filter pada `FilterBottomSheet`.
   - Render formulir pendaftaran `EventRegistrationScreen` dengan seluruh inputnya.

### Menjalankan Pengujian:
```bash
flutter test
```
*Hasil:* **8/8 Tests Passed (100% Lulus)**.

### Menjalankan Analisis Statis:
```bash
flutter analyze
```
*Hasil:* **No issues found! (0 error, 0 warning, 0 linter issue)**.

---

## 🚀 Cara Menjalankan Aplikasi

1. **Prasyarat**:
   - Flutter SDK (>= 3.13.4)
   - Emulator Android / iOS atau Browser Chrome / Windows Desktop

2. **Clone & Masuk ke Direktori**:
   ```bash
   cd tugas_sesi_5
   ```

3. **Install Dependensi**:
   ```bash
   flutter pub get
   ```

4. **Jalankan Aplikasi**:
   ```bash
   flutter run
   ```
