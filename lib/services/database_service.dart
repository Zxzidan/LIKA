import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  final ValueNotifier<Map<String, dynamic>?> userProfileNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);

  /// Active user document ID: authenticated Firebase UID, or fallback 'guest_user'
  String get activeUserId {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) return user.uid;
    } catch (_) {}
    return 'guest_user';
  }

  // ==========================================
  // --- USERS / PROFILE (Collection: users) ---
  // ==========================================
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final uid = activeUserId;
    final authUser = _safeCurrentUser();
    final resolvedName = (authUser?.displayName?.trim().isNotEmpty ?? false)
        ? authUser!.displayName!.trim()
        : 'Dandi Azaidane';
    final resolvedEmail = (authUser?.email?.trim().isNotEmpty ?? false)
        ? authUser!.email!.trim()
        : 'dandiazaidanedummy@gmail.com';

    final defaultProfile = <String, dynamic>{
      'uid': uid,
      'name': resolvedName,
      'handle': resolvedName.toLowerCase().replaceAll(' ', ''),
      'email': resolvedEmail,
      'phone': '0813 1903 0599',
      'address': 'Jl. Raya Trawas No. 45, Mojokerto, Jawa Timur 61375',
      'city': 'Mojokerto',
      'addresses': [
        {
          'label': 'Rumah (Utama)',
          'recipient': resolvedName,
          'phone': '0813 1903 0599',
          'address': 'Jl. Raya Trawas No. 45, Mojokerto, Jawa Timur 61375',
          'city': 'Mojokerto',
          'isPrimary': true,
        },
        {
          'label': 'Kantor / Kebun',
          'recipient': resolvedName,
          'phone': '0813 1903 0599',
          'address': 'Jl. Suropati No. 12, Pesanggrahan, Kec. Batu, Kota Batu 65313',
          'city': 'Kota Batu',
          'isPrimary': false,
        },
      ],
      'bio': 'Pencinta buah apel segar Batu & penikmat agrowisata lokal.',
      'role': 'Mitra',
      'agropay_balance': 250000,
      'points': 1450,
      'coupons_count': 4,
      'avatar_url':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    };

    try {
      final docRef = _db.collection('users').doc(uid);
      final doc = await docRef.get();
      if (doc.exists && doc.data() != null) {
        final merged = <String, dynamic>{...defaultProfile, ...doc.data()!};
        if ((merged['name']?.toString().trim().isEmpty ?? true) &&
            resolvedName.isNotEmpty) {
          merged['name'] = resolvedName;
        }
        userProfileNotifier.value = merged;
        return merged;
      } else {
        // Initialize user profile document in Firestore
        await docRef.set({
          ...defaultProfile,
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Firestore fetchUserProfile fallback: $e');
    }

    userProfileNotifier.value = defaultProfile;
    return defaultProfile;
  }

  Future<bool> saveUserProfile(Map<String, dynamic> data, {String? uid}) async {
    try {
      final targetUid = uid ?? activeUserId;
      final current = userProfileNotifier.value ?? <String, dynamic>{};
      userProfileNotifier.value = {...current, ...data};
      await _db.collection('users').doc(targetUid).set({
        ...data,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('Firestore saveUserProfile error: $e');
      return false;
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) {
    return saveUserProfile(data);
  }

  User? _safeCurrentUser() {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // --- CATEGORIES (Collection: categories) ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final defaults = [
      {'title': 'Agro Tourism', 'icon_name': 'eco', 'bg_color': '#DCFCE7', 'icon_color': '#15803D'},
      {'title': 'Pasar', 'icon_name': 'storefront', 'bg_color': '#FEF3C7', 'icon_color': '#B45309'},
      {'title': 'Game', 'icon_name': 'sports_esports', 'bg_color': '#FCE7F3', 'icon_color': '#BE185D'},
      {'title': 'UMKM Kita', 'icon_name': 'support_agent', 'bg_color': '#FFEDD5', 'icon_color': '#C2410C', 'is_avatar': 1},
      {'title': 'Donasi', 'icon_name': 'favorite', 'bg_color': '#FEE2E2', 'icon_color': '#B91C1C'},
      {'title': 'Agro AI', 'icon_name': 'smart_toy', 'bg_color': '#E0F2FE', 'icon_color': '#0369A1'},
    ];

    try {
      final snap = await _db.collection('categories').get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
      }
      // Auto-seed default categories to Firestore on first run
      final batch = _db.batch();
      for (int i = 0; i < defaults.length; i++) {
        batch.set(_db.collection('categories').doc('cat_${i + 1}'), defaults[i]);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore fetchCategories fallback: $e');
    }
    return defaults;
  }

  // ==========================================
  // --- DESTINATIONS / AGRO TOURISM ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchDestinations({String? category}) async {
    final defaults = [
      {
        'id': 'pkg_cak_ka',
        'name': 'Kebun Apel Cak Ka',
        'category': 'Petik Apel',
        'location': 'Kota Batu',
        'distance': '3.2km',
        'rating': 4.9,
        'review_count': 1200,
        'price': 25000,
        'badge': 'Hemat 30%',
        'schedule_info': 'Petik Hari Ini',
        'image_url':
            'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=800&q=80',
      },
      {
        'id': 'pkg_sayur_organik',
        'name': 'Petualangan Panen Sayur Organik',
        'category': 'Kebun Sayur',
        'location': 'Batu, Malang',
        'distance': '1.5km',
        'rating': 4.8,
        'review_count': 856,
        'price': 45000,
        'badge': 'Promo Eksklusif',
        'schedule_info': 'Wisata Edukasi',
        'image_url':
            'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
      },
    ];

    try {
      Query<Map<String, dynamic>> query = _db.collection('destinations');
      if (category != null && category != 'Semua') {
        query = query.where('category', isEqualTo: category);
      }
      final snap = await query.get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
      }
      if (category == null || category == 'Semua') {
        final batch = _db.batch();
        for (final item in defaults) {
          batch.set(_db.collection('destinations').doc(item['id'] as String), item);
        }
        await batch.commit();
      }
    } catch (e) {
      debugPrint('Firestore fetchDestinations fallback: $e');
    }
    return defaults;
  }

  // ==========================================
  // --- PRODUCTS (Collection: products) ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchProducts({String? category}) async {
    final defaults = [
      {
        'id': 'prod_apel_batu',
        'name': 'Apel Batu',
        'category': 'Komoditas',
        'price': 30000,
        'rating': 4.5,
        'taste': 'Manis, Segar, Asam',
        'description':
            'Apel segar langsung dari kota Batu, Malang, dikenal dengan rasanya yang manis sedikit asam dan teksturnya yang renyah.',
        'image_url':
            'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
      },
      {
        'id': 'prod_sayur_segar',
        'name': 'Sayur Segar',
        'category': 'Popular',
        'price': 5000,
        'rating': 4.8,
        'taste': 'Segar, Renyah',
        'description':
            'Sayur mayur organik dipetik langsung dari kebun dataran tinggi, kaya nutrisi dan bebas pestisida.',
        'image_url':
            'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      },
      {
        'id': 'prod_stroberi_batu',
        'name': 'Stroberi Batu',
        'category': 'Recommended',
        'price': 50000,
        'rating': 4.8,
        'taste': 'Manis, Asam Segar',
        'description':
            'Stroberi manis segar berukuran besar khas perkebunan Batu.',
        'image_url':
            'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=600&q=80',
      },
    ];

    try {
      Query<Map<String, dynamic>> query = _db.collection('products');
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      final snap = await query.get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
      }
      if (category == null) {
        final batch = _db.batch();
        for (final item in defaults) {
          batch.set(_db.collection('products').doc(item['id'] as String), item);
        }
        await batch.commit();
      }
    } catch (e) {
      debugPrint('Firestore fetchProducts fallback: $e');
    }
    return defaults;
  }

  // ==========================================
  // --- ORDERS (Collection: orders) ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      final uid = activeUserId;
      final snap = await _db.collection('orders').limit(100).get();
      if (snap.docs.isNotEmpty) {
        final list = snap.docs
            .map((d) => {'id': d.id, ...d.data()})
            .where((o) => o['user_id'] == uid || o['user_id'] == null)
            .toList();
        list.sort((a, b) {
          final tsA = a['created_at'];
          final tsB = b['created_at'];
          if (tsA is Timestamp && tsB is Timestamp) {
            return tsB.compareTo(tsA);
          }
          return 0;
        });
        return list;
      }
      return [];
    } catch (e) {
      debugPrint('Firestore fetchOrders fallback: $e');
    }

    return [];
  }

  Future<bool> createOrder(Map<String, dynamic> order) async {
    try {
      final rawCode = order['order_code']?.toString() ??
          'ORD_${DateTime.now().millisecondsSinceEpoch}';
      final docId = rawCode.replaceAll('#', '').replaceAll('/', '_');
      await _db.collection('orders').doc(docId).set({
        ...order,
        'user_id': activeUserId,
        'created_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Firestore createOrder error: $e');
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderCode, String status) async {
    try {
      final docId = orderCode.replaceAll('#', '').replaceAll('/', '_');
      final docRef = _db.collection('orders').doc(docId);
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({
          'status': status,
          'updated_at': FieldValue.serverTimestamp(),
        });
      } else {
        final snap = await _db
            .collection('orders')
            .where('order_code', isEqualTo: orderCode)
            .get();
        for (final d in snap.docs) {
          await d.reference.update({
            'status': status,
            'updated_at': FieldValue.serverTimestamp(),
          });
        }
      }
      return true;
    } catch (e) {
      debugPrint('Firestore updateOrderStatus error: $e');
      return false;
    }
  }

  Future<bool> cancelOrder(String orderCode) =>
      updateOrderStatus(orderCode, 'Cancelled');

  Future<bool> completeOrder(String orderCode) =>
      updateOrderStatus(orderCode, 'Received');

  // ==========================================
  // --- DONATIONS (Collection: donations) ---
  // ==========================================
  Future<bool> createDonation({
    required String packageTitle,
    required int amount,
    required bool showDonorName,
    String? donorName,
  }) async {
    try {
      await _db.collection('donations').add({
        'user_id': activeUserId,
        'donor_name': showDonorName
            ? (donorName ?? _safeCurrentUser()?.displayName ?? 'Dandi Azaidane')
            : 'Hamba Allah (Anonim)',
        'package_title': packageTitle,
        'amount': amount,
        'show_donor_name': showDonorName,
        'status': 'Berhasil',
        'created_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Firestore createDonation error: $e');
      return false;
    }
  }

  // ==========================================
  // --- GAME APELMON & VOUCHERS ---
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchApelmon() async {
    try {
      final snap = await _db.collection('apelmon').get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (e) {
      debugPrint('Firestore fetchApelmon error: $e');
    }
    return [];
  }

  Future<bool> catchApelmon(String code) async {
    try {
      await _db.collection('user_apelmon').add({
        'user_id': activeUserId,
        'code': code,
        'caught_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Firestore catchApelmon error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchGameVouchers() async {
    try {
      final snap = await _db.collection('game_vouchers').get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (e) {
      debugPrint('Firestore fetchGameVouchers error: $e');
    }
    return [];
  }

  Future<bool> redeemVoucher(String voucherId) async {
    try {
      await _db.collection('redeemed_vouchers').add({
        'user_id': activeUserId,
        'voucher_id': voucherId,
        'redeemed_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Firestore redeemVoucher error: $e');
      return false;
    }
  }
}
