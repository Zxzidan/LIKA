<p align="center">
  <img src="IMG/LOGOLIKA.png" alt="LIKA Logo" width="220" />
</p>

<h1 align="center">LIKA (Layanan Inovasi Kebun & Agro)</h1>

<p align="center">
  <b>Aplikasi Mobile Terintegrasi untuk Wisata Agro, Pasar Rakyat Digital, dan Gamifikasi Edukatif Petani Nusantara</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/SQLite-TablePlus-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
  <img src="https://img.shields.io/badge/Node.js-REST_API-339933?style=for-the-badge&logo=node.js&logoColor=white" alt="Node.js" />
  <img src="https://img.shields.io/badge/Platform-iOS_Safari_%7C_Android_%7C_Web-15803D?style=for-the-badge" alt="Platforms" />
</p>

---

## 📖 Tentang LIKA

**LIKA** adalah platform aplikasi seluler berbasis agrowisata dan agribisnis modern yang menghubungkan wisatawan, konsumen kota, dan petani lokal (khususnya sentra pertanian Kota Batu, Malang dan sekitarnya).

Melalui antarmuka yang bersih, segar, dan ramah pengguna (*Green Palette `#15803D`, `#16A34A`, `#00C853`*), LIKA mengintegrasikan transaksi belanja hasil bumi segar, reservasi tiket petik kebun, gamifikasi penangkapan maskot *Apelmon* bertabur voucher belanja, serta dompet digital *AgroPay*.

---

## 🌟 Fitur Utama Aplikasi

### 1. 🏠 Beranda (*Home Dashboard*)
* **Banner Promo Panen Raya**: Informasi diskon tiket dan festival apel terkini.
* **Menu Kategori Terpadu**: Akses sekali sentuh ke *Agro Tourism*, *Pasar*, *Game*, *Edukasi*, *UMKM Kita*, dan *Donasi*.
* **Status Pesanan Aktif (*Live Tracking*)**: Ringkasan pengantaran driver kurir yang langsung tampil di layar depan.
* **Momen Wisata Stories**: Feed sosial komunitas pengunjung yang membagikan foto panen & wisata mereka.

### 2. 🧭 Jelajah & Agro Tourism (*Explore Screen*)
* **Filter Wisata Dinamis**: Memilih kategori (*Semua, Petik Apel, Kebun Sayur, Wisata Edukasi*).
* **Peta Jelajah Sekitar**: Tautan visual untuk melihat perkebunan terdekat di sekitar pengguna.
* **Paket Wisata Keluarga**: Penawaran promo hemat 30% dengan klaim kupon langsung.
* **Wisata Terpopuler**: Kartu wisata beresolusi tinggi (*Kebun Apel Cak Ka*, *Kebun Cak Bisma*) lengkap dengan rating bintang, ulasan, jarak tempuh, badge sertifikasi organik, dan tombol pemesanan instan.
* **Tips Edukasi dari Maskot DIGRO**: Rekomendasi waktu terbaik memetik buah dan persiapan kunjungan.

### 3. 🛍️ Pasar Rakyat (*Digital Agri-Market*)
* **Katalog Komoditas Segar**: Apel Batu, Sayur Hidroponik, Stroberi Segar Dataran Tinggi, hingga Madu Murni Lebah Apel.
* **Kategori Tab Pasar**: *Komoditas*, *Popular*, dan *Recommended*.
* **Halaman Rincian Produk**: Gambar hero full-bleed, informasi rasa (*Manis, Segar, Asam*), stok, rating bintang, dan tombol interaktif penambah/pengurang jumlah pesanan `[-]` `[+]` dengan kalkulasi harga otomatis.

### 4. 💳 Checkout & Pembayaran Terintegrasi
* **Rincian Transaksi Transparan**: Perhitungan otomatis harga item, biaya admin 5%, dan total tagihan.
* **Data Pemesan**: Alamat pengiriman lengkap dan kontak pemesan.
* **Pilihan Metode Pembayaran**:
  * 💵 Tunai / *Cash on Delivery (COD)*
  * 📱 *DANA E-Wallet*
  * 💳 Transfer Bank / Debit / Kredit (*BRI, BNI, BCA, BTN*)
* **Layar Sukses Pembayaran**: Halaman *“Yeay! Pesananmu telah terselesaikan”* yang otomatis memasukkan transaksi ke database dan mengarahkan ke tab Pesanan.

### 5. 📦 Pesanan & Pelacakan Kurir (*Orders Screen*)
* **Status Pesanan Realtime**: Tampilan status `#FH341391` (*Paid*, *Wait*, *Cancelled*).
* **Lacak Driver**: Info nama kurir pengantar (*Pak Joko*) dan rincian item belanja.
* **Fitur Pembatalan Pesanan**: Dialog konfirmasi `YA` / `TIDAK` yang otomatis memperbarui status transaksi di database SQLite.
* **State Kosong (*Empty State*)**: Ilustrasi ramah jika belum ada pesanan aktif dengan tombol ajakan belanja.

### 6. 🎮 Game Apelmon & Tukar Voucher (*AR Gamification*)
* **Peta Petualangan LIKA**: Indikator Level pengguna (`LVL 12 • 450 XP`), radar penemuan monster terdekat, dan progress koleksi apel.
* **Mini-Game Tangkap Apelmon**: Tampilan reticle target bidik fokus, indikator energi 85%, kombo tangkapan, dan monster *GEMBROD*.
* **Layar Keberhasilan**: Monster berbadge *RARE* berhasil ditangkap dengan reward langsung **+150 XP** dan **+20 Koin**.
* **Inventaris & Tukar Hadiah**:
  * Koleksi 4 Apelmon (*UJANG*, *UDIN*, *MEMED*, *GEMBROD*).
  * Sistem penukaran voucher diskon (*Diskon 20% Kebun Apel Batu*, *Potongan Rp 15.000 Omah Apel Batu*) yang secara otomatis memotong poin pengguna di database.

### 7. 👤 Profil Pengguna & AgroPay
* **Identitas Akun**: Foto avatar, nama (*Dandi Azaidane*), dan lencana *Mitra LIKA*.
* **Dompet AgroPay**: Informasi saldo dompet digital (*Rp 250.000*), opsi Top Up, dan riwayat transaksi.
* **Pengaturan & Keamanan**: Pusat bantuan, keamanan akun, alamat tersimpan, dan tombol keluar.

---

## 🗄️ Skema Database SQLite (`database.sqlite`)

Aplikasi ini menggunakan basis data lokal **SQLite** yang dioptimalkan dengan mode *WAL (Write-Ahead Logging)* dan relasi kunci asing (*Foreign Keys*). Database ini dapat dibuka dan dikelola langsung menggunakan **[TablePlus](https://tableplus.com/)** atau SQLite browser lainnya.

Skema query lengkap tersedia di file **[`schema.sql`](schema.sql)**.

### Tabel yang Tersedia:
1. **`users`** : Data profil pengguna, nomor kontak, alamat, saldo AgroPay, dan poin.
2. **`categories`** : 6 Kategori menu beranda dengan kode warna dan ikon.
3. **`destinations`** : Destinasi agrowisata, lokasi, koordinat/jarak, tiket masuk, rating, ulasan, dan badge.
4. **`products`** : Produk komoditas pasar, harga satuan, kategori, deskripsi, rasa, stok, dan gambar.
5. **`orders`** : Riwayat pesanan belanja dan tiket, kode unik pesanan, rincian biaya, metode pembayaran, dan status transaksi.
6. **`payment_methods`** : Daftar metode pembayaran aktif (Cash, E-Wallet, Bank).
7. **`apelmon`** : Master karakter monster AR Game, tingkat kelangkaan (*rarity*), reward XP, koin, dan status tangkapan.
8. **`game_vouchers`** : Katalog voucher diskon yang dapat ditukarkan menggunakan poin game.
9. **`wisata_stories`** : Postingan foto cerita wisata pengguna di halaman beranda.
10. **`promos`** : Banner promosi dan kode kupon hemat.
11. **`digro_tips`** : Tips pertanian dan edukasi wisata dari maskot DIGRO.
12. **`app_settings`** : Konfigurasi metadata aplikasi, persentase admin fee, dan kontak darurat mitra.

---

## 🚀 Panduan Menjalankan Aplikasi

### 1. Prasyarat Sistem
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.13 atau yang lebih baru)
* [Node.js](https://nodejs.org/) (versi 20 atau yang lebih baru)
* Browser Safari / Chrome (Desktop atau Perangkat iOS / Android)

### 2. Menjalankan Server Database & Backend API
Buka terminal di direktori proyek dan jalankan:
```bash
node serve.js
```
* Server akan aktif melayani aplikasi web dan REST API SQLite di:  
  `http://localhost:8080` (Akses Lokal)  
  `http://192.168.1.6:8080` (Akses Jaringan Wi-Fi untuk iPhone / Android)

* Cek status seluruh tabel database melalui REST API:
  ```bash
  curl http://localhost:8080/api/tables
  ```

### 3. Menjalankan di Perangkat iOS (iPhone) via Safari PWA
1. Pastikan iPhone dan laptop terhubung ke **jaringan Wi-Fi yang sama**.
2. Buka **Safari** di iPhone Anda.
3. Kunjungi URL:
   ```text
   http://192.168.1.6:8080
   ```
4. *(Opsional - Native Fullscreen)*: Tap tombol **Share** di Safari (ikon kotak bertanda panah ke atas) lalu pilih **"Add to Home Screen" / "Tambah ke Layar Utama"**. Aplikasi LIKA akan tampil dan berjalan tanpa bar URL layaknya aplikasi native iOS.

### 4. Mengompilasi Ulang Web Bundle (Jika Mengubah Kode Dart)
Jika Anda melakukan perubahan pada file Dart di folder `lib/`:
```bash
flutter build web
```
Kemudian lakukan *refresh* pada peramban Safari di iPhone Anda.

---

## 📁 Struktur Direktori Proyek

```text
poject_lika/
├── IMG/
│   └── LOGOLIKA.png            # Logo resmi aplikasi LIKA
├── lib/
│   ├── main.dart               # Titik masuk utama aplikasi (MaterialApp & Theme)
│   ├── screens/
│   │   ├── home_screen.dart           # Layar utama (Beranda & bottom navigation shell)
│   │   ├── explore_screen.dart        # Layar Jelajah / Agro Tourism
│   │   ├── market_screen.dart         # Layar Pasar Rakyat & katalog produk
│   │   ├── product_detail_screen.dart # Detail produk & pemesanan kuantitas
│   │   ├── checkout_screen.dart       # Layar pembayaran, pilih metode & invoice
│   │   ├── orders_screen.dart         # Layar daftar pesanan & pelacakan kurir
│   │   ├── game_screen.dart           # Layar Game AR Apelmon, tangkap & voucher
│   │   └── profile_screen.dart        # Layar profil pengguna & dompet AgroPay
│   └── services/
│       ├── database_service.dart      # Layanan API client sinkronisasi SQLite
│       └── order_state.dart           # Reactive state management pesanan & transaksi
├── database.sqlite             # File database SQLite utama (Bisa dibuka di TablePlus)
├── init_database.js            # Script inisialisasi & seeder database SQLite
├── schema.sql                  # Skema SQL DDL lengkap
├── serve.js                    # Web static server + SQLite REST API backend
├── pubspec.yaml                # Konfigurasi dependensi Flutter
└── README.md                   # Dokumentasi proyek
```

---

## 👥 Tim & Pengembang

Dikembangkan dengan bangga untuk memajukan potensi agrowisata dan petani lokal Indonesia.

* **Repository**: [GitHub - Zxzidan/LIKA](https://github.com/Zxzidan/LIKA.git)
* **Lisensi**: Proyek ini dilisensikan di bawah ketentuan hak cipta mitra dan pengembang LIKA.
