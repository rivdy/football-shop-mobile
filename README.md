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

---

"# football-shop-mobile" 
