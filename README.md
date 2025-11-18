# Football Shop

## Tugas 7 — Elemen Dasar Flutter

Aplikasi Flutter sederhana bertema **Football Shop**. Halaman utama menampilkan tiga tombol:

* **All Products** (biru)
* **My Products** (hijau)
* **Create Product** (merah)

Setiap tombol akan memunculkan **Snackbar** dengan pesan:

* `Kamu telah menekan tombol All Products`
* `Kamu telah menekan tombol My Products`
* `Kamu telah menekan tombol Create Product`

---

### 🎯 Tujuan Pembelajaran

* Menggunakan kerangka dasar Material (`MaterialApp`, `Scaffold`, `AppBar`)
* Menyusun layout sederhana (`Column`, `SizedBox`, `Padding`)
* Membuat tombol aksi (`ElevatedButton.icon`) dengan gaya/warna berbeda
* Menampilkan notifikasi menggunakan `ScaffoldMessenger` + `SnackBar`
* Mempraktikkan **hot reload** dan **hot restart**

---

### 🗂️ Struktur Proyek (Tugas 7)

```text
lib/
├─ main.dart     # Entry point aplikasi, tema, dan route awal
└─ menu.dart     # HomePage berisi tiga tombol + Snackbar
```

---

### ▶️ Cara Menjalankan (umum)

```bash
flutter pub get
flutter run
```

Opsional analisis statis:

```bash
flutter analyze
```

---

### ✅ Checklist Tugas 7

| Kebutuhan                                                | Implementasi                                            |
| -------------------------------------------------------- | ------------------------------------------------------- |
| Tiga tombol: All Products / My Products / Create Product | `ElevatedButton.icon` pada `HomePage`                   |
| Warna tombol berbeda                                     | `style: ElevatedButton.styleFrom(backgroundColor: ...)` |
| Snackbar sesuai tombol yang ditekan                      | `ScaffoldMessenger.of(context).showSnackBar(...)`       |
| Layout rapi                                              | `Column`, `SizedBox`, `Padding`                         |
| Judul & tema aplikasi                                    | `MaterialApp` + `ThemeData` di `main.dart`              |

---

### Ringkas Konsep (Tugas 7)

* **Widget tree & parent–child**: hierarki widget; parent memberi constraint, child merespons dan dirender.
* **Widget penting**: `MaterialApp`, `ThemeData`, `Scaffold`, `AppBar`, `Column`, `ElevatedButton`, `SnackBar`.
* **StatelessWidget vs StatefulWidget**:

  * Stateless: tidak punya state yang berubah.
  * Stateful: punya objek `State` yang dapat berubah.
* **BuildContext**: referensi posisi widget di tree, dipakai untuk akses tema, navigator, dll.
* **Hot reload vs hot restart**:

  * Hot reload: update kode tanpa reset state.
  * Hot restart: jalankan ulang dari awal, semua state hilang.

---

## Tugas 8 — Navigation, Layouts, Forms & Input

### 1. Perbedaan `Navigator.push()` vs `Navigator.pushReplacement()`

* `Navigator.push()`
  Menambahkan halaman baru di atas stack. Digunakan saat user berpindah dari menu ke halaman form (misalnya **Create Product**) dan masih mungkin ingin kembali ke menu.

* `Navigator.pushReplacement()`
  Mengganti halaman aktif dengan halaman baru (halaman lama dihapus dari stack). Dipakai pada navigasi lewat **Drawer** antar “halaman utama” agar stack tidak menumpuk terlalu banyak.

---

### 2. Memanfaatkan `Scaffold`, `AppBar`, dan `Drawer`

Setiap halaman memakai pola yang konsisten:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Football Shop')),
  drawer: const LeftDrawer(),
  body: ...,
);
```

* `Scaffold` → kerangka dasar halaman.
* `AppBar` → judul halaman (“Football Shop”, “Create Product”, dll.).
* `Drawer` → navigasi utama yang sama di semua halaman.

---

### 3. Kelebihan `Padding`, `SingleChildScrollView`, dan `ListView` untuk Form

* `Padding` → memberi jarak antar elemen sehingga form lebih rapi dan mudah dibaca.
* `SingleChildScrollView` → mencegah overflow saat keyboard muncul, form tetap bisa digulir di layar kecil.
* `ListView` → efisien untuk banyak field (lazy build) dan mudah jika field bersifat dinamis.

Contoh pola (disederhanakan):

```dart
Form(
  key: _formKey,
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        TextFormField(...),
        SizedBox(height: 16),
        TextFormField(...),
      ],
    ),
  ),
);
```

---

### 4. Penyesuaian Tema untuk Identitas Visual

Di `main.dart`:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF005F73),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

Warna dari `ColorScheme` dipakai konsisten di:

* kartu menu (`ItemCard`)
* `DrawerHeader`
* tombol utama
  sehingga aplikasi memiliki identitas visual yang konsisten.

---

## Tugas 9 — Integrasi Layanan Web Django dengan Aplikasi Flutter

### Deskripsi Singkat

Pada Tugas 9, aplikasi **Football Shop** diintegrasikan dengan backend **Django** yang sudah dideploy. Fitur utama:

* Registrasi akun dan login di Flutter yang menggunakan sistem autentikasi Django.
* Model Dart (`Product`) yang merepresentasikan model `Product` di Django.
* Halaman daftar produk dan halaman detail produk yang membaca data dari endpoint JSON di Django.
* Fitur tambah produk dari Flutter ke Django.
* Filter “All Products” dan “My Products” berdasarkan user yang login.

---

### 1. Mengapa perlu membuat model Dart saat mengambil/mengirim data JSON?

Alasan utama:

1. **Validasi tipe & null-safety**

   * Dengan model Dart (`class Product`), setiap field punya tipe yang jelas (`String`, `int`, `bool`, dsb).
   * Ketika parsing JSON → model, kesalahan tipe bisa langsung terdeteksi oleh compiler / IDE.
   * Tanpa model, kita hanya bermain dengan `Map<String, dynamic>` yang rentan typo key dan salah tipe, dan baru ketahuan saat runtime.

2. **Null-safety lebih aman**

   * Di model, kita bisa menentukan mana field yang wajib (`required`) dan mana yang nullable (`String? thumbnailUrl`).
   * Ini memaksa kita menangani kasus nilai kosong dengan benar.

3. **Maintainability & reusability**

   * Logika konversi JSON ⇄ objek disatukan di satu tempat (`fromJson`, `toJson`).
   * Saat backend berubah (tambah field, ganti nama field), kita cukup update model, tidak perlu ubah semua tempat yang menggunakan `Map<String, dynamic>`.

4. **Keterbacaan kode**

   * `product.name`, `product.price` jauh lebih jelas daripada `data['name']` atau `item['price']` yang tidak terproteksi.

Konsekuensi jika langsung memakai `Map<String, dynamic>`:

* Lebih mudah salah ketik key.
* Tidak ada jaminan tipe, mudah terjadi runtime error.
* Sulit dipelihara ketika API berkembang.

---

### 2. Fungsi package `http` dan `CookieRequest`

Pada tugas ini, fokusnya pada **`pbp_django_auth`** yang menyediakan **`CookieRequest`**.
Konsepnya:

* **`http`** (dari `package:http/http.dart`)

  * Library HTTP generik untuk Flutter/Dart.
  * Digunakan untuk melakukan request biasa (`GET`, `POST`, dll.) tanpa manajemen session/cookie otomatis.

* **`CookieRequest`** (dari `pbp_django_auth`)

  * Abstraksi di atas HTTP yang **menyimpan dan mengirim cookie Django** (session, csrftoken) secara otomatis.
  * Memiliki helper seperti `login`, `logout`, `post`, `get` yang sudah terintegrasi dengan autentikasi Django.

Perbedaan peran:

* `http` cocok untuk API yang sifatnya stateless atau tidak butuh session Django.
* `CookieRequest` digunakan untuk endpoint Django yang bergantung pada login/session, karena ia menjaga cookie yang sama antar request.

Pada Football Shop, seluruh interaksi yang butuh status login (register, login, logout, tambah produk, list produk milik user) menggunakan `CookieRequest`.

---

### 3. Mengapa instance `CookieRequest` perlu dibagikan ke semua komponen?

Alasannya:

1. **Session harus konsisten**

   * Login dari halaman `LoginPage` akan menyimpan cookie session di dalam objek `CookieRequest`.
   * Jika tiap widget punya instance `CookieRequest` sendiri, cookie tidak terbagi → widget lain menganggap user belum login.

2. **Kemudahan dependency injection**

   * Dengan membungkus root app menggunakan `Provider<CookieRequest>` di `main.dart`, setiap widget bisa mengakses instance yang sama dengan:

     ```dart
     final request = Provider.of<CookieRequest>(context);
     ```

3. **Menghindari duplikasi state**

   * Hanya ada satu sumber kebenaran untuk status login (`request.loggedIn`) dan cookie.

Tanpa membagi instance yang sama, autentikasi akan tidak konsisten antar halaman.

---

### 4. Konfigurasi konektivitas Flutter ⇄ Django

Agar Flutter dapat berkomunikasi dengan Django, diperlukan beberapa konfigurasi:

1. **`ALLOWED_HOSTS` dan `CSRF_TRUSTED_ORIGINS` di Django**

   * Menambahkan host seperti `127.0.0.1`, `localhost`, `10.0.2.2`, dan domain deployment (`*.pbp.cs.ui.ac.id`) agar Django mengizinkan request dari alamat tersebut.
   * Untuk Flutter Web, origin-nya `http://localhost:xxxx`, sehingga perlu juga ditambahkan ke `CSRF_TRUSTED_ORIGINS`.

2. **`10.0.2.2` untuk emulator Android**

   * Di emulator, `10.0.2.2` adalah alias ke `localhost` komputer host.
   * Jika server Django berjalan di host, Flutter yang jalan di emulator harus mengakses `http://10.0.2.2:8000`.
   * Tanpa menambahkan `10.0.2.2` ke `ALLOWED_HOSTS`, Django akan menolak request dengan status 400/403.

3. **CORS dan pengaturan cookie/SameSite**

   * Jika frontend dan backend beda origin (misalnya domain berbeda), perlu konfigurasi CORS dan pengaturan `SESSION_COOKIE_SAMESITE` serta `CSRF_COOKIE_SAMESITE` supaya cookie tetap dikirim.
   * Jika salah konfigurasi, login tampak berhasil di backend tapi cookie tidak sampai ke Flutter → setiap request berikutnya dianggap belum login.

4. **Izin akses internet di Android (`AndroidManifest.xml`)**

   * Menambahkan permission:

     ```xml
     <uses-permission android:name="android.permission.INTERNET" />
     ```
   * Tanpa ini, aplikasi Android tidak bisa melakukan request HTTP keluar.

Jika konfigurasi-konfigurasi ini salah, gejala yang muncul bisa berupa:

* Error 403 “Origin checking failed”.
* Tidak bisa login meskipun kredensial benar.
* Request tidak pernah sampai ke backend (khusus Android tanpa permission).

---

### 5. Mekanisme pengiriman data dari input hingga tampil di Flutter

Contoh alur **Tambah Produk**:

1. Pengguna mengisi form di `AddProductFormPage` (`TextFormField` nama, harga, kategori, deskripsi, thumbnail).
2. Saat tombol “Simpan Produk” ditekan:

   * `_formKey.currentState!.validate()` memvalidasi input.
   * `_formKey.currentState!.save()` menyimpan nilai ke variabel lokal.
   * Flutter memanggil:

     ```dart
     request.post("$baseUrl/ajax/products/create/", {...});
     ```
3. `CookieRequest` mengirim request `POST` ke Django dengan body form dan cookie session.
4. Django view `product_create_ajax`:

   * Menerima data, memvalidasi melalui `ProductForm`.
   * Mengisi field `user` dengan `request.user`.
   * Menyimpan objek `Product` baru ke database.
   * Mengembalikan JSON sukses (`{"ok": true, "item": {...}}`).
5. Flutter menerima respons JSON:

   * Jika sukses → menampilkan `SnackBar` “Produk berhasil ditambahkan” dan kembali ke halaman sebelumnya.
6. Saat membuka halaman **See Products** (`ProductListPage`):

   * `fetchProducts` memanggil `request.get("$baseUrl/api/flutter/products/")`.
   * Django view mengembalikan list produk dalam bentuk JSON.
   * Flutter memetakan setiap item JSON ke objek `Product` dan menampilkannya dalam `ListView`.

---

### 6. Mekanisme autentikasi login, register, hingga logout

**Register:**

1. Pengguna membuka `RegisterPage` dan mengisi username + password.
2. Flutter mengirim `POST` ke `/auth/register/`:

   ```dart
   request.post("$baseUrl/auth/register/", {...});
   ```
3. Django view `register`:

   * Mengecek method `POST`.
   * Validasi: field tidak kosong, password sama, username belum dipakai.
   * Membuat `User` baru dengan `create_user`.
   * Mengirim JSON `{"status": true, "message": "User created successfully!"}`.
4. Flutter menampilkan `SnackBar` sukses dan kembali ke halaman login.

**Login:**

1. Pengguna mengisi `username` dan `password` pada `LoginPage`.
2. Flutter memanggil:

   ```dart
   final response = await request.login("$baseUrl/auth/login/", {...});
   ```
3. Django view `login`:

   * Menggunakan `authenticate` untuk mengecek username & password.
   * Jika valid, memanggil `auth_login` dan membuat session.
   * Mengirim JSON `{"status": true, "username": "...", "message": "Login successful!"}`.
4. `CookieRequest` menyimpan cookie session.
5. Di Flutter:

   * Jika `request.loggedIn == true`, aplikasi mengarahkan ke `MenuPage`.
   * `MenuPage` dan halaman lain bisa menggunakan `CookieRequest` yang sama untuk memanggil endpoint yang butuh login.

**Logout:**

1. Di menu, tombol Logout memanggil:

   ```dart
   request.logout("$baseUrl/auth/logout/");
   ```
2. Django view `logout`:

   * Memanggil `auth_logout(request)`.
   * Menghapus session dan mengirim JSON `{"status": true, "message": "Logout successful."}`.
3. Flutter menghapus state login di `CookieRequest` dan kembali ke halaman `LoginPage`.

---

### 7. Implementasi Checklist Tugas 9 — Step-by-step

1. **Deployment Django**

   * Menyempurnakan `settings.py` (DATABASES, `ALLOWED_HOSTS`, `CSRF_TRUSTED_ORIGINS`, `STATIC_ROOT`, dsb.).
   * Deploy proyek ke PBP deployment (`rivaldy-putra-footballshop.pbp.cs.ui.ac.id`).
   * Memastikan endpoint JSON (`/api/flutter/products/`, `/api/flutter/products/<id>/`) bisa diakses.

2. **Model dan endpoint Django untuk Flutter**

   * Model `Product` di Django berisi `name`, `price`, `description`, `category`, `thumbnail`, `is_featured`, `user`.
   * View `products_flutter` mengembalikan list produk dalam format JSON.
   * View `product_detail_flutter` mengembalikan detail satu produk berdasarkan `id`.
   * View `product_create_ajax` menerima POST produk baru.
   * View autentikasi: `/auth/login/`, `/auth/register/`, `/auth/logout/`.

3. **Membuat model Dart**

   * `lib/models/product.dart` berisi:

     ```dart
     class Product { ... }
     ```
   * Menyediakan `Product.fromJson(Map<String, dynamic> json)` dan field:
     `id`, `name`, `price`, `description`, `category`, `thumbnailUrl`, `isFeatured`.

4. **Mendaftarkan CookieRequest di Flutter**

   * Di `main.dart`:

     ```dart
     runApp(
       Provider(
         create: (_) => CookieRequest(),
         child: const FootballShopApp(),
       ),
     );
     ```
   * Semua halaman mengakses instance yang sama dengan:
     `final request = Provider.of<CookieRequest>(context);`

5. **Halaman Register**

   * `RegisterPage` dengan tiga `TextField`.
   * Tombol Register memanggil `request.post("$baseUrl/auth/register/", ...)`.
   * Menampilkan `SnackBar` sesuai hasil, dan kembali ke `LoginPage` jika sukses.

6. **Halaman Login**

   * `LoginPage` dengan `TextField` username & password.
   * Tombol Login memanggil `request.login("$baseUrl/auth/login/", ...)`.
   * Jika `request.loggedIn == true`, diarahkan ke `MenuPage`.

7. **Integrasi autentikasi Django–Flutter**

   * Setelah login, `CookieRequest` menyimpan cookie session.
   * Endpoint yang butuh login (misal tambah produk, list “my products”) otomatis membawa cookie ini.
   * Di Django, `request.user` dipakai untuk menyimpan `Product.user` dan melakukan filter.

8. **Halaman daftar produk (All / My)**

   * `ProductListPage` memanggil:

     * `/api/flutter/products/` untuk **All Products**.
     * Endpoint khusus atau query yang hanya mengembalikan produk milik user yang login (untuk **My Products**).
   * Data JSON dipetakan ke list `Product` dan ditampilkan dalam `ListView` dengan `ListTile`.

9. **Halaman detail produk**

   * `ProductDetailPage` menerima `productId`.
   * Memanggil `/api/flutter/products/<id>/`.
   * Menampilkan seluruh atribut `Product`.
   * Menyediakan tombol Back untuk kembali ke daftar.

10. **Tambah produk dari Flutter**

    * `AddProductFormPage` dengan `Form` + `TextFormField`.
    * Tombol Simpan memanggil `/ajax/products/create/` menggunakan `request.post`.
    * Setelah sukses, menampilkan `SnackBar` dan kembali ke menu/list produk.

11. **Filter “My Products”**

    * Di Django, endpoint khusus mengembalikan hanya produk dengan `user == request.user`.
    * Di Flutter, tombol atau tab “My Products” akan memanggil endpoint tersebut dan menampilkan hasilnya.


