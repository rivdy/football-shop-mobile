# Football Shop — Tugas 7: Elemen Dasar Flutter

Aplikasi Flutter sederhana bertema **Football Shop**. Halaman utama menampilkan tiga tombol:
- **All Products** (biru)
- **My Products** (hijau)
- **Create Product** (merah)

Setiap tombol akan memunculkan **Snackbar** dengan pesan:
- `Kamu telah menekan tombol All Products`
- `Kamu telah menekan tombol My Products`
- `Kamu telah menekan tombol Create Product`

---

## 🎯 Tujuan Pembelajaran
- Menggunakan kerangka dasar Material (`MaterialApp`, `Scaffold`, `AppBar`)
- Menyusun layout sederhana (`Column`, `SizedBox`, `Padding`)
- Membuat tombol aksi (`ElevatedButton.icon`) dengan gaya/warna berbeda
- Menampilkan notifikasi menggunakan `ScaffoldMessenger` + `SnackBar`
- Mempraktikkan **hot reload** dan **hot restart**

---

## 🗂️ Struktur Proyek
```

lib/
├─ main.dart     # Entry point aplikasi, tema, dan route awal
└─ menu.dart     # HomePage berisi tiga tombol + Snackbar

````

---

## ⚙️ Prasyarat
- Flutter SDK terinstal
- Perangkat/Emulator terkonfigurasi (Android/iOS)

---

## ▶️ Cara Menjalankan
```bash
flutter pub get
flutter run
````

> Opsional: analisis statis

```bash
flutter analyze
```

---

## ✅ Checklist Kebutuhan Tugas & Implementasi

| Kebutuhan                                                | Implementasi                                            |
| -------------------------------------------------------- | ------------------------------------------------------- |
| Tiga tombol: All Products / My Products / Create Product | `ElevatedButton.icon` pada `HomePage`                   |
| Warna tombol berbeda                                     | `style: ElevatedButton.styleFrom(backgroundColor: ...)` |
| Snackbar sesuai tombol yang ditekan                      | `ScaffoldMessenger.of(context).showSnackBar(...)`       |
| Layout rapi                                              | `Column`, `SizedBox`, `Padding`                         |
| Judul & tema aplikasi                                    | `MaterialApp` + `ThemeData` di `main.dart`              |

---

## 🧩 Ringkas Konsep

### Widget tree & parent–child

**Widget tree** adalah hierarki widget. **Parent** memberi constraints & konteks; **child** merespons ukuran lalu dirender. Rebuild bisa terjadi pada subtree saja → efisien.

### Widget yang dipakai

`MaterialApp`, `ThemeData`, `ColorScheme`, `Scaffold`, `AppBar`, `Column`, `SizedBox`, `Padding`, `ElevatedButton.icon`, `Icon`, `Text`, `ScaffoldMessenger`, `SnackBar`.

### Mengapa `MaterialApp` jadi root

Menyediakan tema global, routing, dan integrasi Material Design untuk seluruh subtree aplikasi.

### `StatelessWidget` vs `StatefulWidget`

* **StatelessWidget**: tidak punya state internal yang berubah; cocok untuk halaman statis.
* **StatefulWidget**: punya `State` yang dapat berubah (form, animasi, counter, dsb).

### `BuildContext`

Referensi posisi widget dalam tree. Dipakai untuk akses tema, navigator, scaffold messenger, dan inherited widgets lain.

### Hot reload vs Hot restart

* **Hot reload**: update kode + rebuild widget tree tanpa reset state.
* **Hot restart**: jalankan ulang aplikasi dari awal, state ter-reset.

### Navigasi antar halaman (contoh singkat)

```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => const AnotherPage()));
// kembali
Navigator.pop(context);
```
## Tugas 8 — Navigation, Layouts, Forms & Input (Football Shop)

### 1) Perbedaan `Navigator.push()` vs `Navigator.pushReplacement()` (dan kapan dipakai)

* **`Navigator.push()`**
  Menambahkan halaman baru di atas *stack*. Cocok saat user menekan tombol di Home menuju **Create Product**, karena user mungkin ingin **kembali** ke Home.

  ```dart
  // Home (menu.dart) → CreateProductPage
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CreateProductPage()),
  );
  ```
* **`Navigator.pushReplacement()`**
  **Mengganti** halaman aktif (halaman lama tidak tersisa di atas stack). Cocok untuk navigasi melalui **Drawer** antar “section utama” (Home ↔ Create Product) agar **tidak menumpuk** banyak layer halaman.

  ```dart
  // Drawer → Home
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const MyHomePage()),
  );
  ```

---

### 2) Memanfaatkan hierarchy `Scaffold`, `AppBar`, dan `Drawer` agar struktur konsisten

Setiap halaman memakai pola yang sama:

```dart
// Home
Scaffold(
  appBar: AppBar(title: const Text('Football Shop')),
  drawer: const LeftDrawer(),   // konsisten di semua halaman
  body: /* grid tombol */,
);

// Create Product
Scaffold(
  appBar: AppBar(title: const Text('Create Product')),
  drawer: const LeftDrawer(),   // konsisten di semua halaman
  body: /* form */,
);
```

* **`Scaffold`** → kerangka halaman (app bar, body, drawer).
* **`AppBar`** → judul/aksi yang konsisten (“Football Shop”).
* **`Drawer`** → navigasi utama yang sama di seluruh halaman.
  Pola ini membuat UI terasa familiar saat user berpindah halaman.

---

### 3) Kelebihan `Padding`, `SingleChildScrollView`, dan `ListView` untuk form (+ contoh)

* **`Padding`**: jarak antar elemen → rapi, mudah dibaca & disentuh.
* **`SingleChildScrollView`**: mencegah **overflow** saat keyboard muncul; form tetap bisa di-*scroll* di layar kecil.
* **`ListView`**: efisien untuk **banyak** field (dinamis/panjang) karena *lazy build*.

Contoh (Create Product):

```dart
// create_product_page.dart
body: Form(
  key: _formKey,
  child: SingleChildScrollView(             // anti-overflow saat keyboard
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(                          // ganti ke ListView jika field sangat banyak/dinamis
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(decoration: InputDecoration(labelText: 'Name')),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(decoration: InputDecoration(labelText: 'Price')),
        ),
        // dst...
      ],
    ),
  ),
),
```

---

### 4) Menyesuaikan warna tema agar identitas visual konsisten (brand Football Shop)

Tetapkan **brand color** di `ThemeData` lalu gunakan warna dari **`ColorScheme`** di komponen.

```dart
// main.dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF005F73), // contoh brand color Football Shop
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

Contoh pemakaian pada kartu tombol di Home (agar mengikuti brand):

```dart
// widgets/item_card.dart
final scheme = Theme.of(context).colorScheme;

return Material(
  color: scheme.primary,                    // latar ikut brand
  borderRadius: BorderRadius.circular(12),
  child: InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: scheme.onPrimary, size: 30),  // kontras otomatis
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: scheme.onPrimary)),
        ],
      ),
    ),
  ),
);
```

> (Opsional) Samakan juga `DrawerHeader` dengan `scheme.primary` agar seluruh navigasi terasa satu identitas.

---
