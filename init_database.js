// init_database.js
const { DatabaseSync } = require('node:sqlite');
const path = require('path');
const fs = require('fs');

const dbPath = path.join(__dirname, 'database.sqlite');

console.log('Connecting to database:', dbPath);
const db = new DatabaseSync(dbPath);

// Enable WAL mode and foreign keys for high performance and integrity
db.exec('PRAGMA foreign_keys = ON;');
db.exec('PRAGMA journal_mode = WAL;');

console.log('Creating tables...');

// 1. USERS / PROFILE TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    role TEXT DEFAULT 'Mitra LIKA',
    address TEXT,
    city TEXT,
    agropay_balance INTEGER DEFAULT 250000,
    points INTEGER DEFAULT 1250,
    avatar_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`);

// 2. CATEGORIES TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL UNIQUE,
    icon_name TEXT NOT NULL,
    bg_color TEXT NOT NULL,
    icon_color TEXT NOT NULL,
    is_avatar INTEGER DEFAULT 0,
    display_order INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`);

// 3. DESTINASI WISATA / AGRO TOURISM TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS destinations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'Semua',
    location TEXT NOT NULL,
    distance TEXT NOT NULL,
    rating REAL DEFAULT 4.9,
    review_count INTEGER DEFAULT 1200,
    price INTEGER DEFAULT 25000,
    badge TEXT,
    schedule_info TEXT DEFAULT 'Petik Hari Ini',
    image_url TEXT NOT NULL,
    description TEXT,
    is_popular INTEGER DEFAULT 1,
    is_favorite INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`);

// 4. PRODUK PASAR RAKYAT TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'Komoditas',
    price INTEGER NOT NULL,
    rating REAL DEFAULT 4.5,
    taste TEXT DEFAULT 'Manis, Segar, Asam',
    description TEXT,
    image_url TEXT NOT NULL,
    stock INTEGER DEFAULT 100,
    unit TEXT DEFAULT 'kg',
    is_top_pick INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`);

// 5. METODE PEMBAYARAN TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS payment_methods (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    icon_name TEXT,
    account_number TEXT,
    is_active INTEGER DEFAULT 1
);
`);

// Check if orders table needs migration
try {
  db.prepare('SELECT order_code FROM orders LIMIT 1').get();
} catch (e) {
  console.log('Migrating old orders table...');
  db.exec('DROP TABLE IF EXISTS orders;');
}

// 6. PESANAN & TRANSAKSI (ORDERS) TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_code TEXT NOT NULL UNIQUE,
    user_id INTEGER,
    customer_name TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    customer_address TEXT NOT NULL,
    customer_city TEXT NOT NULL,
    product_name TEXT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    item_price INTEGER NOT NULL,
    subtotal INTEGER NOT NULL,
    admin_fee INTEGER NOT NULL,
    total_price INTEGER NOT NULL,
    payment_method TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Paid',
    driver_name TEXT DEFAULT 'Pak Joko (Driver LIKA)',
    driver_status TEXT DEFAULT 'Menuju ke Lokasimu',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
);
`);

// 7. AR GAME APELMON TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS apelmon (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    title TEXT NOT NULL,
    rarity TEXT NOT NULL DEFAULT 'Common',
    tag_taste TEXT DEFAULT 'Manis',
    tag_color TEXT DEFAULT 'Hijau',
    xp_reward INTEGER DEFAULT 150,
    coin_reward INTEGER DEFAULT 20,
    image_url TEXT NOT NULL,
    is_caught INTEGER DEFAULT 0,
    caught_at DATETIME
);
`);

// 8. TUKAR HADIAH VOUCHER GAME TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS game_vouchers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    discount TEXT NOT NULL,
    subtitle TEXT NOT NULL,
    points_cost INTEGER NOT NULL,
    color_hex TEXT DEFAULT '#059669',
    is_redeemed INTEGER DEFAULT 0,
    voucher_code TEXT,
    redeemed_at DATETIME
);
`);

// 9. MOMEN WISATA STORIES TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS wisata_stories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    caption TEXT NOT NULL,
    likes TEXT NOT NULL,
    views TEXT NOT NULL,
    image_url TEXT NOT NULL,
    avatar_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`);

// 10. PROMOS & BANNERS TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS promos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    subtitle TEXT NOT NULL,
    promo_code TEXT,
    discount_pct INTEGER,
    banner_type TEXT DEFAULT 'home_promo',
    cta_text TEXT DEFAULT 'KLAIM PROMO',
    image_url TEXT,
    is_active INTEGER DEFAULT 1
);
`);

// 11. TIPS EDUKASI DIGRO TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS digro_tips (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    avatar TEXT DEFAULT '👨‍🌾',
    name TEXT DEFAULT 'DIGRO',
    message TEXT NOT NULL,
    tags TEXT NOT NULL
);
`);

// 12. APP SETTINGS / METADATA TABLE
db.exec(`
CREATE TABLE IF NOT EXISTS app_settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT
);
`);

console.log('Tables created successfully. Inserting initial seed data...');

// SEED USERS
const userCount = db.prepare('SELECT count(*) as cnt FROM users').get().cnt;
if (userCount === 0) {
  const insertUser = db.prepare(`
    INSERT INTO users (name, email, phone, role, address, city, agropay_balance, points, avatar_url)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);
  insertUser.run(
    'Dandi Azaidane',
    'dandi.azaidane@gmail.com',
    '0812-3456-7890',
    'Mitra LIKA',
    'Pulau Jeju blok A no 56',
    'Jeju',
    250000,
    1250,
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80'
  );
  insertUser.run(
    'Ansellma Putri',
    'ansellma.putri@gmail.com',
    '0813 1903 0599',
    'Member Gold',
    'Pulau Jeju blok A no 56',
    'Jeju',
    500000,
    2400,
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80'
  );
}

// SEED CATEGORIES
const catCount = db.prepare('SELECT count(*) as cnt FROM categories').get().cnt;
if (catCount === 0) {
  const insertCat = db.prepare(`
    INSERT INTO categories (title, icon_name, bg_color, icon_color, is_avatar, display_order)
    VALUES (?, ?, ?, ?, ?, ?)
  `);
  insertCat.run('Agro Tourism', 'eco', '#DCFCE7', '#15803D', 0, 1);
  insertCat.run('Pasar', 'storefront', '#FEF3C7', '#B45309', 0, 2);
  insertCat.run('Game', 'sports_esports', '#FCE7F3', '#BE185D', 0, 3);
  insertCat.run('Edukasi', 'school', '#E0F2FE', '#0369A1', 0, 4);
  insertCat.run('UMKM Kita', 'support_agent', '#FFEDD5', '#C2410C', 1, 5);
  insertCat.run('Donasi', 'favorite', '#FEE2E2', '#B91C1C', 0, 6);
}

// SEED DESTINATIONS (WISATA)
const destCount = db.prepare('SELECT count(*) as cnt FROM destinations').get().cnt;
if (destCount === 0) {
  const insertDest = db.prepare(`
    INSERT INTO destinations (name, category, location, distance, rating, review_count, price, badge, schedule_info, image_url, description, is_popular)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);
  insertDest.run(
    'Kebun Apel Cak Ka',
    'Petik Apel',
    'Kota Batu',
    '3.2km',
    4.9,
    1200,
    25000,
    'Sertifikasi Organik',
    'Petik Hari Ini',
    'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=800&q=80',
    'Kebun apel organik terluas di Kota Batu dengan pengalaman memetik langsung dari pohon dan pemandangan pegunungan yang asri.',
    1
  );
  insertDest.run(
    'Kebun Cak Bisma',
    'Kebun Sayur',
    'Cisarua, Bogor',
    '1.5km',
    4.8,
    856,
    45000,
    'Paling Dicari',
    'Wisata Edukasi',
    'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80',
    'Kebun sayur hidroponik dan stroberi dataran tinggi dengan fasilitas edukasi keluarga dan workshop bertani modern.',
    1
  );
  insertDest.run(
    'Kebun Stroberi Sejuk Batu',
    'Petik Apel',
    'Bumiaji, Kota Batu',
    '4.1km',
    4.9,
    640,
    35000,
    'Favorit Wisatawan',
    'Petik Hari Ini',
    'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=800&q=80',
    'Sensasi memetik stroberi merah manis segar di kebun bertingkat dengan hawa sejuk khas pegunungan Batu.',
    1
  );
}

// SEED PRODUCTS (PASAR RAKYAT)
const prodCount = db.prepare('SELECT count(*) as cnt FROM products').get().cnt;
if (prodCount === 0) {
  const insertProd = db.prepare(`
    INSERT INTO products (name, category, price, rating, taste, description, image_url, stock, unit, is_top_pick)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);
  insertProd.run(
    'Apel Batu',
    'Komoditas',
    30000,
    4.5,
    'Manis, Segar, Asam',
    'Apel segar langsung dari kota Batu, Malang, dikenal dengan rasanya yang manis sedikit asam dan teksturnya yang renyah. Cocok dikonsumsi langsung atau dijadikan jus segar untuk menemani hari-harimu yang aktif.',
    'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=800&q=80',
    150,
    'kg',
    1
  );
  insertProd.run(
    'Sayur Segar',
    'Popular',
    5000,
    4.8,
    'Segar, Renyah',
    'Sayuran organik pilihan dipetik saat fajar untuk menjaga kesegaran nutrisi dan rasa renyah alami ke meja makan keluarga.',
    'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
    300,
    'ikat',
    1
  );
  insertProd.run(
    'Stroberi Batu',
    'Recommended',
    50000,
    4.8,
    'Manis, Sedikit Asam',
    'Stroberi dataran tinggi Batu berukuran besar dengan warna merah merona, kaya vitamin C dan antioksidan alami.',
    'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=800&q=80',
    80,
    'pack',
    0
  );
  insertProd.run(
    'Madu Murni Peternakan Batu',
    'Popular',
    75000,
    4.9,
    'Manis Alami',
    'Madu lebah nektar bunga apel murni 100% tanpa bahan pengawet atau gula tambahan.',
    'https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&w=800&q=80',
    50,
    'botol',
    0
  );
}

// SEED PAYMENT METHODS
const pmCount = db.prepare('SELECT count(*) as cnt FROM payment_methods').get().cnt;
if (pmCount === 0) {
  const insertPM = db.prepare(`
    INSERT INTO payment_methods (code, name, type, icon_name, account_number, is_active)
    VALUES (?, ?, ?, ?, ?, ?)
  `);
  insertPM.run('tunai', 'Tunai (Cash on Delivery)', 'cash', 'payments', null, 1);
  insertPM.run('dana', 'DANA E-Wallet', 'ewallet', 'account_balance_wallet', '0813-1903-0599', 1);
  insertPM.run('bri', 'Bank BRI', 'bank', 'credit_card', '0341-01-002345-50-8', 1);
  insertPM.run('bni', 'Bank BNI', 'bank', 'credit_card', '0891-2345-6789', 1);
  insertPM.run('bca', 'Bank BCA', 'bank', 'credit_card', '7820-123-456', 1);
  insertPM.run('btn', 'Bank BTN', 'bank', 'credit_card', '0012-3456-7890', 1);
}

// SEED ORDERS
const orderCheck = db.prepare('SELECT count(*) as cnt FROM orders WHERE order_code = ?').get('#FH341391').cnt;
if (orderCheck === 0) {
  const insertOrder = db.prepare(`
    INSERT INTO orders (
      order_code, user_id, customer_name, customer_phone, customer_address, customer_city,
      product_name, quantity, item_price, subtotal, admin_fee, total_price,
      payment_method, status, driver_name, driver_status
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);
  insertOrder.run(
    '#FH341391',
    1,
    'Ansellma Putri',
    '0813 1903 0599',
    'Pulau Jeju blok A no 56',
    'Jeju',
    'Apel Batu',
    10,
    30000,
    300000,
    15000,
    315000,
    'Tunai',
    'Paid',
    'Pak Joko (Driver LIKA)',
    'Menuju ke Lokasimu'
  );
}

// SEED APELMON
const apelmonCount = db.prepare('SELECT count(*) as cnt FROM apelmon').get().cnt;
if (apelmonCount === 0) {
  const insertApelmon = db.prepare(`
    INSERT INTO apelmon (code, name, title, rarity, tag_taste, tag_color, xp_reward, coin_reward, image_url, is_caught)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);
  insertApelmon.run(
    'UJANG',
    'UJANG',
    'Jus Apel Segar Batu',
    'Common',
    'Manis',
    'Hijau',
    50,
    10,
    'https://images.unsplash.com/photo-1576179635662-9d1983e97e1e?auto=format&fit=crop&w=400&q=80',
    1
  );
  insertApelmon.run(
    'UDIN',
    'UDIN',
    'Keripik Organik Renyah',
    'Common',
    'Gurih',
    'Kuning',
    80,
    15,
    'https://images.unsplash.com/photo-1568644396922-5c3bfae12521?auto=format&fit=crop&w=400&q=80',
    1
  );
  insertApelmon.run(
    'MEMED',
    'MEMED',
    'Sari Apel Berkarbonasi',
    'Rare',
    'Bersoda',
    'Kuning',
    120,
    18,
    'https://images.unsplash.com/photo-1596560548464-f010549b84d7?auto=format&fit=crop&w=400&q=80',
    1
  );
  insertApelmon.run(
    'GEMBROD',
    'GEMBROD',
    'Apel Hijau Langka',
    'Rare',
    'Manis',
    'Hijau',
    150,
    20,
    'https://images.unsplash.com/photo-1618160702438-9b02ab6515c9?auto=format&fit=crop&w=400&q=80',
    0
  );
}

// SEED VOUCHERS
const vCount = db.prepare('SELECT count(*) as cnt FROM game_vouchers').get().cnt;
if (vCount === 0) {
  const insertVoucher = db.prepare(`
    INSERT INTO game_vouchers (title, discount, subtitle, points_cost, color_hex, is_redeemed, voucher_code)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `);
  insertVoucher.run(
    'Kebun Apel Batu',
    '20%',
    'Diskon untuk semua Jus Segar',
    500,
    '#059669',
    0,
    'LIKA20JUICE'
  );
  insertVoucher.run(
    'Omah Apel Batu',
    '15rb',
    'Potongan setiap beli Keripik Apel',
    800,
    '#D97706',
    0,
    'LIKA15CHIPS'
  );
  insertVoucher.run(
    'Wisata Edukasi Madu',
    '30rb',
    'Potongan tiket masuk keluarga',
    1200,
    '#2563EB',
    0,
    'LIKA30FAMILY'
  );
}

// SEED STORIES
const storyCount = db.prepare('SELECT count(*) as cnt FROM wisata_stories').get().cnt;
if (storyCount === 0) {
  const insertStory = db.prepare(`
    INSERT INTO wisata_stories (username, caption, likes, views, image_url, avatar_url)
    VALUES (?, ?, ?, ?, ?, ?)
  `);
  insertStory.run(
    'Sarah Jenkins',
    'Memetik apel langsung dari kebun Batu bareng keluarga! Asri banget suasananya.',
    '2.4k',
    '15.2k',
    'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80'
  );
  insertStory.run(
    'Budi Santoso',
    'Panen sayur hidroponik di Kebun Cak Bisma, seru banget edukasinya!',
    '1.8k',
    '11.3k',
    'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80'
  );
  insertStory.run(
    'Rina Wijaya',
    'Apelmon langka Gembrod akhirnya tertangkap di dekat kincir ria!',
    '3.1k',
    '18.9k',
    'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80'
  );
}

// SEED PROMOS
const promoCount = db.prepare('SELECT count(*) as cnt FROM promos').get().cnt;
if (promoCount === 0) {
  const insertPromo = db.prepare(`
    INSERT INTO promos (title, subtitle, promo_code, discount_pct, banner_type, cta_text)
    VALUES (?, ?, ?, ?, ?, ?)
  `);
  insertPromo.run(
    'Festival Apel 2026',
    'Panen Raya & Diskon Spesial',
    'PANENRAYA',
    25,
    'home_promo',
    'KLAIM SEKARANG'
  );
  insertPromo.run(
    'Paket Wisata Keluarga - Hemat 30%',
    'Nikmati akhir pekan seru di kebun pilihan dengan harga spesial.',
    'HEMAT30',
    30,
    'explore_family_promo',
    'KLAIM PROMO'
  );
}

// SEED DIGRO TIPS
const tipCount = db.prepare('SELECT count(*) as cnt FROM digro_tips').get().cnt;
if (tipCount === 0) {
  const insertTip = db.prepare(`
    INSERT INTO digro_tips (avatar, name, message, tags)
    VALUES (?, ?, ?, ?)
  `);
  insertTip.run(
    '👨‍🌾',
    'DIGRO',
    'Halo Sahabat LIKA! Disarankan berkunjung ke kebun apel sebelum jam 10 pagi ya, supaya buahnya tetap segar dan udara masih sejuk. Jangan lupa bawa topi!',
    '#ProTips #MorningFarm'
  );
}

// SEED APP SETTINGS
const settingsCount = db.prepare('SELECT count(*) as cnt FROM app_settings').get().cnt;
if (settingsCount === 0) {
  const insertSetting = db.prepare(`
    INSERT INTO app_settings (key, value, description)
    VALUES (?, ?, ?)
  `);
  insertSetting.run('app_name', 'LIKA Agro Mobile', 'Nama aplikasi');
  insertSetting.run('version', '1.0.0+1', 'Versi aplikasi mobile');
  insertSetting.run('admin_fee_pct', '5', 'Persentase biaya admin checkout (5%)');
  insertSetting.run('support_phone', '+6281234567890', 'Nomor WhatsApp bantuan mitra LIKA');
  insertSetting.run('active_city', 'Kota Batu, Malang', 'Lokasi sentra agro aktif');
}

console.log('Database initialization and seeding completed successfully!');
const tables = db.prepare("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name").all();
console.log('All tables currently in database.sqlite:');
tables.forEach(t => {
  const rowCount = db.prepare(`SELECT count(*) as cnt FROM ${t.name}`).get().cnt;
  console.log(` - ${t.name}: ${rowCount} rows`);
});
