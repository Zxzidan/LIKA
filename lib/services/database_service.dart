import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  // In web environment or device, connect to local backend API
  // Use relative path '/api' on web so it works whether accessed via localhost or LAN IP (192.168.1.6:8080)
  String get baseUrl {
    if (kIsWeb) {
      return '/api';
    }
    return 'http://192.168.1.6:8080/api';
  }

  // ==========================================
  // --- USERS / PROFILE ---
  // ==========================================
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/user/active')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('DB Fetch Profile Error (using fallback): $e');
    }
    return {
      'id': 1,
      'name': 'Dandi Azaidane',
      'email': 'dandi.azaidane@gmail.com',
      'phone': '0812-3456-7890',
      'role': 'Mitra LIKA',
      'address': 'Pulau Jeju blok A no 56',
      'city': 'Jeju',
      'agropay_balance': 250000,
      'points': 1250,
      'avatar_url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    };
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/user/active'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('DB Update Profile Error: $e');
      return false;
    }
  }

  // ==========================================
  // --- CATEGORIES ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/categories')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('DB Fetch Categories Error: $e');
    }
    return [
      {'title': 'Agro Tourism', 'icon_name': 'eco', 'bg_color': '#DCFCE7', 'icon_color': '#15803D'},
      {'title': 'Pasar', 'icon_name': 'storefront', 'bg_color': '#FEF3C7', 'icon_color': '#B45309'},
      {'title': 'Game', 'icon_name': 'sports_esports', 'bg_color': '#FCE7F3', 'icon_color': '#BE185D'},
      {'title': 'Edukasi', 'icon_name': 'school', 'bg_color': '#E0F2FE', 'icon_color': '#0369A1'},
      {'title': 'UMKM Kita', 'icon_name': 'support_agent', 'bg_color': '#FFEDD5', 'icon_color': '#C2410C', 'is_avatar': 1},
      {'title': 'Donasi', 'icon_name': 'favorite', 'bg_color': '#FEE2E2', 'icon_color': '#B91C1C'},
    ];
  }

  // ==========================================
  // --- DESTINATIONS / AGRO TOURISM ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchDestinations({String? category}) async {
    try {
      final url = category != null && category != 'Semua'
          ? '$baseUrl/destinations?category=${Uri.encodeComponent(category)}'
          : '$baseUrl/destinations';
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('DB Fetch Destinations Error: $e');
    }
    return [
      {
        'id': 1,
        'name': 'Kebun Apel Cak Ka',
        'category': 'Petik Apel',
        'location': 'Kota Batu',
        'distance': '3.2km',
        'rating': 4.9,
        'review_count': 1200,
        'price': 25000,
        'badge': 'Sertifikasi Organik',
        'schedule_info': 'Petik Hari Ini',
        'image_url': 'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=800&q=80',
      },
      {
        'id': 2,
        'name': 'Kebun Cak Bisma',
        'category': 'Kebun Sayur',
        'location': 'Cisarua, Bogor',
        'distance': '1.5km',
        'rating': 4.8,
        'review_count': 856,
        'price': 45000,
        'badge': 'Paling Dicari',
        'schedule_info': 'Wisata Edukasi',
        'image_url': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80',
      },
    ];
  }

  // ==========================================
  // --- PRODUCTS (PASAR RAKYAT) ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchProducts({String? category}) async {
    try {
      final url = category != null
          ? '$baseUrl/products?category=${Uri.encodeComponent(category)}'
          : '$baseUrl/products';
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('DB Fetch Products Error: $e');
    }
    return [
      {
        'id': 1,
        'name': 'Apel Batu',
        'category': 'Komoditas',
        'price': 30000,
        'rating': 4.5,
        'taste': 'Manis, Segar, Asam',
        'image_url': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=800&q=80',
      },
      {
        'id': 2,
        'name': 'Sayur Segar',
        'category': 'Popular',
        'price': 5000,
        'rating': 4.8,
        'taste': 'Segar, Renyah',
        'image_url': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
      },
      {
        'id': 3,
        'name': 'Stroberi Batu',
        'category': 'Recommended',
        'price': 50000,
        'rating': 4.8,
        'taste': 'Manis, Sedikit Asam',
        'image_url': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=800&q=80',
      },
    ];
  }

  // ==========================================
  // --- ORDERS ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/orders')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('DB Fetch Orders Error: $e');
    }
    return [
      {
        'order_code': '#FH341391',
        'customer_name': 'Ansellma Putri',
        'customer_phone': '0813 1903 0599',
        'customer_address': 'Pulau Jeju blok A no 56',
        'customer_city': 'Jeju',
        'product_name': 'Apel Batu',
        'quantity': 10,
        'item_price': 30000,
        'subtotal': 300000,
        'admin_fee': 15000,
        'total_price': 315000,
        'payment_method': 'Tunai',
        'status': 'Paid',
      }
    ];
  }

  Future<bool> createOrder(Map<String, dynamic> order) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      debugPrint('DB Create Order Error: $e');
      return false;
    }
  }

  Future<bool> cancelOrder(String orderCode) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/orders/cancel'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'order_code': orderCode}),
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('DB Cancel Order Error: $e');
      return false;
    }
  }

  // ==========================================
  // --- GAME APELMON & VOUCHERS ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchApelmon() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/apelmon')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('DB Fetch Apelmon Error: $e');
    }
    return [];
  }

  Future<bool> catchApelmon(String code) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/apelmon/catch'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('DB Catch Apelmon Error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchGameVouchers() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/game/vouchers')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('DB Fetch Vouchers Error: $e');
    }
    return [];
  }

  Future<bool> redeemVoucher(int voucherId) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/game/redeem'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': voucherId}),
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('DB Redeem Voucher Error: $e');
      return false;
    }
  }

  // ==========================================
  // --- STORIES & TIPS ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchStories() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/stories')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('DB Fetch Stories Error: $e');
    }
    return [];
  }
}
