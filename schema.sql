-- ==========================================================
-- SKEMA LENGKAP DATABASE SQLite - LIKA (Agro Tourism & Mobile)
-- File Lokasi: database.sqlite (Bisa dibuka di TablePlus)
-- ==========================================================

PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

-- 1. TABEL PENGGUNA & PROFIL (USERS)
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

-- 2. TABEL KATEGORI MENU (CATEGORIES)
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

-- 3. TABEL DESTINASI WISATA / AGRO TOURISM (DESTINATIONS)
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

-- 4. TABEL KATALOG PRODUK PASAR RAKYAT (PRODUCTS)
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

-- 5. TABEL METODE PEMBAYARAN (PAYMENT_METHODS)
CREATE TABLE IF NOT EXISTS payment_methods (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- 'cash', 'ewallet', 'bank'
    icon_name TEXT,
    account_number TEXT,
    is_active INTEGER DEFAULT 1
);

-- 6. TABEL PESANAN & TRANSAKSI (ORDERS)
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
    status TEXT NOT NULL DEFAULT 'Paid', -- 'Paid', 'Wait', 'Cancelled', 'Completed'
    driver_name TEXT DEFAULT 'Pak Joko (Driver LIKA)',
    driver_status TEXT DEFAULT 'Menuju ke Lokasimu',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 7. TABEL MONSTER AR GAME APELMON (APELMON)
CREATE TABLE IF NOT EXISTS apelmon (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    title TEXT NOT NULL,
    rarity TEXT NOT NULL DEFAULT 'Common', -- 'Common', 'Rare', 'Epic', 'Legendary'
    tag_taste TEXT DEFAULT 'Manis',
    tag_color TEXT DEFAULT 'Hijau',
    xp_reward INTEGER DEFAULT 150,
    coin_reward INTEGER DEFAULT 20,
    image_url TEXT NOT NULL,
    is_caught INTEGER DEFAULT 0,
    caught_at DATETIME
);

-- 8. TABEL TUKAR HADIAH VOUCHER GAME (GAME_VOUCHERS)
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

-- 9. TABEL MOMEN WISATA STORIES (WISATA_STORIES)
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

-- 10. TABEL PROMO & BANNER (PROMOS)
CREATE TABLE IF NOT EXISTS promos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    subtitle TEXT NOT NULL,
    promo_code TEXT,
    discount_pct INTEGER,
    banner_type TEXT DEFAULT 'home_promo', -- 'home_promo', 'explore_family_promo'
    cta_text TEXT DEFAULT 'KLAIM PROMO',
    image_url TEXT,
    is_active INTEGER DEFAULT 1
);

-- 11. TABEL TIPS EDUKASI DIGRO (DIGRO_TIPS)
CREATE TABLE IF NOT EXISTS digro_tips (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    avatar TEXT DEFAULT '👨‍🌾',
    name TEXT DEFAULT 'DIGRO',
    message TEXT NOT NULL,
    tags TEXT NOT NULL
);

-- 12. TABEL PENGATURAN APLIKASI (APP_SETTINGS)
CREATE TABLE IF NOT EXISTS app_settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT
);
