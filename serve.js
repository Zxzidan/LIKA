const http = require('http');
const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const PORT = 8080;
const dir = path.join(__dirname, 'build', 'web');
const dbPath = path.join(__dirname, 'database.sqlite');

// Initialize SQLite connection
const db = new DatabaseSync(dbPath);
db.exec('PRAGMA foreign_keys = ON;');
db.exec('PRAGMA journal_mode = WAL;');

const mimeTypes = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.wasm': 'application/wasm',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
};

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  });
  res.end(JSON.stringify(data));
}

function parseJsonBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    req.on('end', () => {
      if (!body) return resolve({});
      try {
        resolve(JSON.parse(body));
      } catch (err) {
        reject(err);
      }
    });
    req.on('error', reject);
  });
}

const server = http.createServer(async (req, res) => {
  const parsedUrl = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const pathname = parsedUrl.pathname;

  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    });
    return res.end();
  }

  // ==========================================
  // --- REST API ENDPOINTS FOR DATABASE ---
  // ==========================================
  if (pathname.startsWith('/api/')) {
    try {
      // 1. Health & DB Status
      if (pathname === '/api/health') {
        return sendJson(res, 200, { status: 'ok', time: new Date().toISOString() });
      }

      if (pathname === '/api/tables') {
        const tables = db.prepare("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name").all();
        const result = tables.map(t => {
          const count = db.prepare(`SELECT count(*) as cnt FROM ${t.name}`).get().cnt;
          return { table: t.name, rows: count };
        });
        return sendJson(res, 200, { tables: result });
      }

      // 2. Users
      if (pathname === '/api/users' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM users').all();
        return sendJson(res, 200, rows);
      }

      if (pathname === '/api/user/active') {
        if (req.method === 'GET') {
          const user = db.prepare('SELECT * FROM users WHERE id = 1').get();
          return sendJson(res, 200, user || {});
        }
        if (req.method === 'PUT') {
          const body = await parseJsonBody(req);
          db.prepare(`
            UPDATE users SET
              name = COALESCE(?, name),
              phone = COALESCE(?, phone),
              email = COALESCE(?, email),
              role = COALESCE(?, role),
              address = COALESCE(?, address),
              city = COALESCE(?, city)
            WHERE id = 1
          `).run(body.name, body.phone, body.email, body.role, body.address, body.city);
          const updated = db.prepare('SELECT * FROM users WHERE id = 1').get();
          return sendJson(res, 200, updated);
        }
      }

      // 3. Categories
      if (pathname === '/api/categories' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM categories ORDER BY display_order ASC').all();
        return sendJson(res, 200, rows);
      }

      // 4. Destinations / Wisata
      if (pathname === '/api/destinations' && req.method === 'GET') {
        const cat = parsedUrl.searchParams.get('category');
        let rows;
        if (cat && cat !== 'Semua') {
          rows = db.prepare('SELECT * FROM destinations WHERE category = ? ORDER BY id ASC').all(cat);
        } else {
          rows = db.prepare('SELECT * FROM destinations ORDER BY id ASC').all();
        }
        return sendJson(res, 200, rows);
      }

      // 5. Products Pasar
      if (pathname === '/api/products' && req.method === 'GET') {
        const cat = parsedUrl.searchParams.get('category');
        let rows;
        if (cat) {
          rows = db.prepare('SELECT * FROM products WHERE category = ? ORDER BY id ASC').all(cat);
        } else {
          rows = db.prepare('SELECT * FROM products ORDER BY id ASC').all();
        }
        return sendJson(res, 200, rows);
      }

      // 6. Orders
      if (pathname === '/api/orders') {
        if (req.method === 'GET') {
          const rows = db.prepare('SELECT * FROM orders ORDER BY id DESC').all();
          return sendJson(res, 200, rows);
        }
        if (req.method === 'POST') {
          const body = await parseJsonBody(req);
          const code = body.order_code || `#FH${Math.floor(100000 + Math.random() * 900000)}`;
          const insert = db.prepare(`
            INSERT INTO orders (
              order_code, user_id, customer_name, customer_phone, customer_address, customer_city,
              product_name, quantity, item_price, subtotal, admin_fee, total_price,
              payment_method, status, driver_name, driver_status
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          `);
          insert.run(
            code,
            body.user_id || 1,
            body.customer_name || 'Ansellma Putri',
            body.customer_phone || '0813 1903 0599',
            body.customer_address || 'Pulau Jeju blok A no 56',
            body.customer_city || 'Jeju',
            body.product_name || 'Apel Batu',
            body.quantity || 1,
            body.item_price || 30000,
            body.subtotal || 30000,
            body.admin_fee || 1500,
            body.total_price || 31500,
            body.payment_method || 'Tunai',
            body.status || 'Paid',
            'Pak Joko (Driver LIKA)',
            'Menuju ke Lokasimu'
          );
          const newOrder = db.prepare('SELECT * FROM orders WHERE order_code = ?').get(code);
          return sendJson(res, 201, newOrder);
        }
      }

      if (pathname === '/api/orders/cancel' && req.method === 'POST') {
        const body = await parseJsonBody(req);
        if (body.order_code) {
          db.prepare("UPDATE orders SET status = 'Cancelled' WHERE order_code = ?").run(body.order_code);
          return sendJson(res, 200, { success: true, order_code: body.order_code, status: 'Cancelled' });
        }
        return sendJson(res, 400, { error: 'order_code is required' });
      }

      // 7. Payment Methods
      if (pathname === '/api/payment-methods' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM payment_methods WHERE is_active = 1').all();
        return sendJson(res, 200, rows);
      }

      // 8. Game: Apelmon
      if (pathname === '/api/apelmon' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM apelmon ORDER BY id ASC').all();
        return sendJson(res, 200, rows);
      }

      if (pathname === '/api/apelmon/catch' && req.method === 'POST') {
        const body = await parseJsonBody(req);
        const code = body.code || 'GEMBROD';
        db.prepare("UPDATE apelmon SET is_caught = 1, caught_at = CURRENT_TIMESTAMP WHERE code = ?").run(code);
        // Add XP and points to user
        db.prepare("UPDATE users SET points = points + 20 WHERE id = 1").run();
        const updatedMonster = db.prepare('SELECT * FROM apelmon WHERE code = ?').get(code);
        const updatedUser = db.prepare('SELECT * FROM users WHERE id = 1').get();
        return sendJson(res, 200, { success: true, monster: updatedMonster, user: updatedUser });
      }

      // 9. Game: Vouchers
      if (pathname === '/api/game/vouchers' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM game_vouchers ORDER BY id ASC').all();
        return sendJson(res, 200, rows);
      }

      if (pathname === '/api/game/redeem' && req.method === 'POST') {
        const body = await parseJsonBody(req);
        const voucherId = body.id;
        const voucher = db.prepare('SELECT * FROM game_vouchers WHERE id = ?').get(voucherId);
        const user = db.prepare('SELECT * FROM users WHERE id = 1').get();
        if (voucher && user && user.points >= voucher.points_cost) {
          db.prepare('UPDATE users SET points = points - ? WHERE id = 1').run(voucher.points_cost);
          db.prepare('UPDATE game_vouchers SET is_redeemed = 1, redeemed_at = CURRENT_TIMESTAMP WHERE id = ?').run(voucherId);
          const updatedUser = db.prepare('SELECT * FROM users WHERE id = 1').get();
          return sendJson(res, 200, { success: true, points_remaining: updatedUser.points, voucher });
        }
        return sendJson(res, 400, { error: 'Insufficient points or voucher not found' });
      }

      // 10. Stories, Promos, Tips, Settings
      if (pathname === '/api/stories' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM wisata_stories ORDER BY id ASC').all();
        return sendJson(res, 200, rows);
      }

      if (pathname === '/api/promos' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM promos WHERE is_active = 1').all();
        return sendJson(res, 200, rows);
      }

      if (pathname === '/api/tips' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM digro_tips LIMIT 1').get();
        return sendJson(res, 200, rows || {});
      }

      if (pathname === '/api/settings' && req.method === 'GET') {
        const rows = db.prepare('SELECT * FROM app_settings').all();
        return sendJson(res, 200, rows);
      }

      // Unknown API route
      return sendJson(res, 404, { error: 'API endpoint not found' });
    } catch (apiErr) {
      console.error('API Error:', apiErr);
      return sendJson(res, 500, { error: apiErr.message });
    }
  }

  // ==========================================
  // --- STATIC WEB ASSET SERVER (SPA) ---
  // ==========================================
  let cleanUrl = pathname;
  let filePath = path.join(dir, cleanUrl === '/' ? 'index.html' : cleanUrl);
  let ext = path.extname(filePath).toLowerCase();
  let contentType = mimeTypes[ext] || 'application/octet-stream';

  fs.readFile(filePath, (err, data) => {
    if (err) {
      if (err.code === 'ENOENT') {
        // Fallback to index.html for SPA routing
        fs.readFile(path.join(dir, 'index.html'), (err2, indexData) => {
          if (err2) {
            res.writeHead(404);
            res.end('File not found');
          } else {
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(indexData);
          }
        });
      } else {
        res.writeHead(500);
        res.end('Server error');
      }
    } else {
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(data);
    }
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`\n========================================`);
  console.log(` SERVER LIKA + DATABASE BERHASIL MENYALA!`);
  console.log(` Database: SQLite (database.sqlite)`);
  console.log(` API URL:  http://192.168.1.6:${PORT}/api/tables`);
  console.log(` Safari:   http://192.168.1.6:${PORT}`);
  console.log(` Laptop:   http://localhost:${PORT}`);
  console.log(`========================================\n`);
});
