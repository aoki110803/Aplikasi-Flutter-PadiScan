# PadiScan — Sistem Prediksi Penyakit Padi

Aplikasi mobile untuk mendeteksi penyakit tanaman padi melalui foto daun menggunakan model deep learning (CNN). Dibangun dengan Flutter (mobile), Laravel 11 (backend/API), dan Python (model machine learning).

---

## Daftar Isi

1. [Persyaratan Sistem](#persyaratan-sistem)
2. [Instalasi Backend (Laravel)](#instalasi-backend-laravel)
3. [Instalasi Frontend (Flutter)](#instalasi-frontend-flutter)
4. [Konfigurasi Koneksi](#konfigurasi-koneksi)
5. [Menjalankan Aplikasi](#menjalankan-aplikasi)
6. [Cara Penggunaan Aplikasi](#cara-penggunaan-aplikasi)
7. [Struktur Folder](#struktur-folder)
8. [Pengujian API (Postman)](#pengujian-api-postman)
9. [Checklist Sebelum Menjalankan](#checklist-sebelum-menjalankan)
10. [Catatan Tambahan](#catatan-tambahan)

---

## Persyaratan Sistem

### Backend
- PHP 8.2 atau lebih baru
- Composer
- MySQL 8.0 atau lebih baru
- Python 3.8 atau lebih baru
- Library Python: `tensorflow` (atau `scikit-learn`) + `numpy` + `Pillow`

### Frontend
- Flutter SDK 3.x
- Dart 3.x
- Android Studio atau VS Code
- Android SDK (API level 21 ke atas) atau Xcode (untuk iOS)

---

## Instalasi Backend (Laravel)

### Langkah 1 — Buat Project dan Install Paket

```bash
composer create-project laravel/laravel padi-api
cd padi-api
composer require tymon/jwt-auth
```

### Langkah 2 — Publish Konfigurasi JWT dan Generate Secret

```bash
php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
php artisan jwt:secret
```

### Langkah 3 — Konfigurasi File .env

Buat file `.env` berdasarkan `.env.example`, lalu sesuaikan bagian berikut:

```env
APP_NAME=PadiScanAPI
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=padi_scan_db
DB_USERNAME=root
DB_PASSWORD=

JWT_TTL=60
JWT_REFRESH_TTL=20160

ML_MODEL_PATH=storage/app/model_penyakit_padi.pkl
ML_SCRIPT_PATH=storage/app/predict_script.py
```

### Langkah 4 — Siapkan Database

Buat database MySQL bernama `padi_scan_db`, lalu jalankan migrasi:

```bash
php artisan migrate
```

### Langkah 5 — Salin File Model Machine Learning

Salin file model CNN dan skrip prediksi ke folder `storage/app/`:

```bash
# Untuk model scikit-learn
cp /path/to/model_penyakit_padi.pkl storage/app/model_penyakit_padi.pkl

# Untuk model TensorFlow/Keras
cp /path/to/model_penyakit_padi.h5 storage/app/model_penyakit_padi.h5

# Salin skrip Python
cp /path/to/predict_script.py storage/app/predict_script.py
```

Pastikan versi Python dan library yang diinstall di server sama dengan yang digunakan saat melatih model.

### Langkah 6 — Install Library Python

```bash
# Untuk model TensorFlow/Keras
pip3 install tensorflow numpy Pillow

# Untuk model scikit-learn
pip3 install scikit-learn numpy Pillow

# Untuk model PyTorch
pip3 install torch torchvision numpy Pillow
```

### Langkah 7 — Aktifkan Storage Link

```bash
php artisan storage:link
```

---

## Instalasi Frontend (Flutter)

### Langkah 1 — Buat Project Flutter

```bash
flutter create penyakit_padi_app
cd penyakit_padi_app
```

### Langkah 2 — Tambahkan Dependencies

Buka file `pubspec.yaml` dan tambahkan pada bagian `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  http: ^1.2.1
  flutter_secure_storage: ^9.2.2
  image_picker: ^1.1.2
  cached_network_image: ^3.3.1
  intl: ^0.19.0
  lottie: ^3.1.2
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  shimmer: ^3.0.0
```

Kemudian jalankan:

```bash
flutter pub get
```

### Langkah 3 — Tambahkan Permission Android

Buka file `android/app/src/main/AndroidManifest.xml` dan tambahkan sebelum tag `<application>`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

---

## Konfigurasi Koneksi

Buka file `lib/config/api_config.dart` dan sesuaikan `baseUrl` berdasarkan cara menjalankan aplikasi:

```dart
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Sesuaikan!
}
```

Panduan memilih URL yang tepat:

| Platform             | Base URL                                      |
|----------------------|-----------------------------------------------|
| Android Emulator     | `http://10.0.2.2:8000/api`                    |
| iOS Simulator        | `http://localhost:8000/api`                   |
| Device Fisik (LAN)   | `http://192.168.X.X:8000/api` (IP PC kamu)    |
| Production           | `https://api.yourdomain.com/api`              |

Untuk mengetahui IP PC di jaringan lokal, jalankan `ipconfig` (Windows) atau `ifconfig` (Mac/Linux).

Saat menjalankan server Laravel untuk device fisik, gunakan perintah berikut agar bisa diakses dari HP:

```bash
php artisan serve --host=0.0.0.0
```

---

## Menjalankan Aplikasi

### Jalankan Backend

```bash
cd padi-api
php artisan serve
```

Server berjalan di `http://localhost:8000`.

### Jalankan Frontend

Pastikan emulator atau device sudah terhubung, kemudian:

```bash
cd penyakit_padi_app
flutter run
```

---

## Cara Penggunaan Aplikasi

### 1. Daftar Akun Baru

Ketika pertama kali membuka aplikasi, tampil layar login. Jika belum punya akun, ketuk tautan **Belum punya akun? Daftar Sekarang** di bagian bawah layar.

Isi form pendaftaran berikut:
- **Nama Lengkap** — nama yang akan ditampilkan di profil
- **Email** — alamat email aktif, digunakan untuk login
- **Password** — minimal 6 karakter

Ketuk tombol **Daftar Sekarang**. Jika berhasil, aplikasi langsung masuk ke halaman utama.

---

### 2. Masuk (Login)

Isi email dan password yang sudah didaftarkan, lalu ketuk tombol **Masuk**.

Jika email atau password salah, akan muncul notifikasi merah di bagian bawah layar. Periksa kembali dan coba lagi.

---

### 3. Scan Penyakit Padi

Setelah masuk, aplikasi langsung membuka tab **Scan**.

**Pilih gambar daun padi** melalui salah satu cara:
- Ketuk area gambar di tengah layar, lalu pilih sumber gambar
- Ketuk tombol **Kamera** untuk mengambil foto langsung
- Ketuk tombol **Galeri** untuk memilih foto dari penyimpanan

**Tips agar hasil deteksi akurat:**
- Foto di tempat dengan cahaya yang cukup
- Fokuskan kamera pada bagian daun yang menunjukkan gejala penyakit
- Pastikan daun mengisi sebagian besar area frame foto

Setelah gambar dipilih, ketuk tombol **Analisis Penyakit** untuk memulai deteksi.

---

### 4. Melihat Hasil Prediksi

Setelah analisis selesai, aplikasi menampilkan halaman hasil yang berisi:

- **Nama penyakit** yang terdeteksi beserta tingkat keparahannya (Parah / Sedang / Sehat)
- **Tingkat akurasi** prediksi dalam persentase
- **Deskripsi penyakit** — penjelasan singkat tentang penyebab dan gejala
- **Rekomendasi penanganan** — langkah yang disarankan untuk mengatasi penyakit

Hasil ini otomatis tersimpan ke riwayat. Ketuk **Scan Gambar Lain** untuk kembali ke halaman scan.

---

### 5. Riwayat Prediksi

Ketuk tab **Riwayat** di bagian bawah layar untuk melihat semua hasil prediksi sebelumnya.

**Mencari riwayat tertentu:**
- Ketik nama penyakit di kotak pencarian di bagian atas
- Daftar akan otomatis diperbarui sesuai kata kunci yang diketik
- Ketuk ikon silang di kanan kotak pencarian untuk menghapus filter

**Menyaring berdasarkan tingkat keparahan:**
- Ketuk salah satu chip filter di bawah kotak pencarian: **Semua**, **Sehat**, **Ringan**, **Sedang**, atau **Parah**
- Daftar akan langsung menampilkan hanya riwayat dari kategori yang dipilih

Ketuk ikon refresh di pojok kanan atas untuk memuat ulang data riwayat dari server.

---

### 6. Profil dan Pengaturan Akun

Ketuk tab **Profil** di bagian bawah layar.

**Edit nama atau password:**
1. Ketuk tombol **Edit Profil**
2. Ubah nama pada kolom **Nama / Username** jika ingin mengganti nama tampilan
3. Untuk mengganti password, aktifkan toggle **Ganti Password**
4. Isi **Password Saat Ini** untuk verifikasi, kemudian isi **Password Baru**
5. Ketuk **Simpan Perubahan**

Informasi lain yang tersedia di halaman Profil:
- **Tentang PadiScan** — informasi versi dan keterangan aplikasi
- **Panduan Penggunaan** — panduan singkat di dalam aplikasi
- **Beri Rating** — memberikan ulasan di toko aplikasi

**Keluar dari akun:**
Ketuk tombol **Keluar** di bagian bawah halaman Profil, lalu konfirmasi. Aplikasi akan kembali ke layar login.

---

## Struktur Folder

### Flutter (`lib/`)

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart           # Warna, font, style global
├── config/
│   └── api_config.dart          # Base URL dan semua endpoint
├── models/
│   ├── user_model.dart           # Model data user
│   └── prediction_model.dart    # Model data hasil prediksi dan riwayat
├── providers/
│   ├── auth_provider.dart        # State management login, register, edit profil
│   └── scan_provider.dart        # State management scan, riwayat, pencarian
├── services/
│   ├── storage_service.dart      # Simpan dan baca JWT (terenkripsi)
│   ├── auth_service.dart         # Panggil API login dan register
│   └── scan_service.dart         # Panggil API prediksi dan riwayat
└── views/
    ├── splash_view.dart          # Cek sesi JWT saat aplikasi dibuka
    ├── login_view.dart           # Halaman login
    ├── register_view.dart        # Halaman daftar akun
    ├── home_view.dart            # Bottom navigation bar utama
    ├── scan_view.dart            # Scan gambar daun padi
    ├── result_view.dart          # Tampil hasil prediksi
    ├── history_view.dart         # Daftar riwayat dengan pencarian dan filter
    ├── profile_view.dart         # Halaman profil dan logout
    └── edit_profile_view.dart    # Halaman edit nama dan password
```

### Laravel (`app/`, `routes/`, `storage/app/`)

```
padi-api/
├── app/
│   ├── Http/Controllers/Api/
│   │   ├── AuthController.php       # Register, login, logout, update profil
│   │   └── PredictionController.php # Prediksi dan riwayat
│   └── Models/
│       ├── User.php                  # Model user dengan JWT
│       └── Prediction.php            # Model hasil prediksi
├── routes/
│   └── api.php                       # Semua route API
└── storage/app/
    ├── model_penyakit_padi.pkl       # File model CNN (dari training)
    └── predict_script.py             # Skrip Python untuk inferensi
```

---

## Pengujian API (Postman)

### Register Akun Baru

```
POST http://localhost:8000/api/register
Content-Type: application/json

{
    "name": "Test Petani",
    "email": "petani@example.com",
    "password": "password123",
    "password_confirmation": "password123"
}
```

### Login

```
POST http://localhost:8000/api/login
Content-Type: application/json

{
    "email": "petani@example.com",
    "password": "password123"
}
```

Salin nilai `token` dari response, digunakan sebagai Bearer token pada request berikutnya.

### Prediksi Penyakit

```
POST http://localhost:8000/api/predict
Authorization: Bearer <token>
Content-Type: multipart/form-data

image: [pilih file gambar daun padi .jpg / .png]
```

### Riwayat Prediksi

```
GET http://localhost:8000/api/history
Authorization: Bearer <token>

# Dengan pencarian:
GET http://localhost:8000/api/history?search=Blas
```

### Update Profil

```
PUT http://localhost:8000/api/profile
Authorization: Bearer <token>
Content-Type: application/json

{
    "name": "Nama Baru",
    "current_password": "password123",
    "new_password": "passwordbaru123",
    "new_password_confirmation": "passwordbaru123"
}
```

Jika hanya ingin mengubah nama tanpa ganti password, cukup kirimkan field `name` saja tanpa field password.

### Logout

```
POST http://localhost:8000/api/logout
Authorization: Bearer <token>
```

---

## Checklist Sebelum Menjalankan

### Backend Laravel

- [ ] `php artisan serve` sudah berjalan
- [ ] Database `padi_scan_db` sudah dibuat di MySQL
- [ ] `php artisan migrate` sudah dijalankan
- [ ] `JWT_SECRET` ada di file `.env`
- [ ] `php artisan storage:link` sudah dijalankan
- [ ] File `model_penyakit_padi.pkl` ada di `storage/app/`
- [ ] File `predict_script.py` ada di `storage/app/`
- [ ] Python 3 dan library ML sudah terinstall

### Flutter

- [ ] `baseUrl` di `api_config.dart` sudah disesuaikan dengan platform
- [ ] Permission kamera dan storage sudah ditambahkan di `AndroidManifest.xml`
- [ ] `flutter pub get` sudah dijalankan
- [ ] Emulator atau device fisik sudah terhubung dan terdeteksi
- [ ] Untuk emulator: gunakan URL `10.0.2.2:8000`
- [ ] Untuk device fisik: gunakan IP PC di jaringan LAN yang sama

---

## Catatan Tambahan

**Format file model:** File model yang digunakan harus berupa bundle pickle dengan kunci `model` dan `class_names`. Jika menggunakan TensorFlow/Keras (format `.h5`), ganti baris load model di `predict_script.py` dengan:

```python
import tensorflow as tf
model = tf.keras.models.load_model(model_path)
```

**Versi library Python:** Pastikan versi Python dan library (terutama TensorFlow/scikit-learn) di server sama dengan yang digunakan saat melatih model. Disarankan menggunakan virtual environment agar tidak ada konflik dependensi.

**Koneksi device fisik:** Jalankan backend dengan `php artisan serve --host=0.0.0.0` agar server bisa diakses dari perangkat HP yang berada di jaringan WiFi yang sama.

**Keamanan production:** Ubah `allowed_origins` di `config/cors.php` dari `*` menjadi domain spesifik aplikasi sebelum deploy ke production.
