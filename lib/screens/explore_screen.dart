import 'package:flutter/material.dart';
import '../services/adaptive_device.dart';
import 'checkout_screen.dart';
import 'search_screen.dart';

class ExploreScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;
  final Function(int)? onNavigateToTab;

  const ExploreScreen({
    super.key,
    this.onProfileTap,
    this.onBackTap,
    this.onNavigateToTab,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // 0: Promo & Listing Screen (Image 3)
  // 1: Map Screen (Image 2)
  // 2: Dashboard Lokasi Detail Screen (Image 1)
  int _exploreView = 0;
  int _previousView = 0;

  // Filters & Tabs
  int _selectedPromoCategory = 0;
  final List<String> _promoCategories = ['Semua', 'Petik Apel', 'Kebun Sayur'];

  int _selectedMapCategory = 0;
  final List<Map<String, dynamic>> _mapCategories = [
    {'title': 'Kebun Apel', 'icon': Icons.park_rounded},
    {'title': 'Petik Jeruk', 'icon': Icons.wb_sunny_rounded},
    {'title': 'Edukasi', 'icon': Icons.menu_book_rounded},
  ];

  int _selectedDetailTab = 0;
  final List<String> _detailTabs = ['Tentang Paket', 'Fasilitas', 'Ulasan', 'Diskusi'];

  bool _isDetailFavorite = false;
  bool _isFaqExpanded = true;

  // Selected package data for detail & checkout
  late Map<String, dynamic> _selectedPackage;

  final List<Map<String, dynamic>> _packages = [
    {
      'id': 'pkg_cak_ka',
      'title': 'Paket Petik Apel Cak Ka',
      'subtitle': 'Paket Wisata Keluarga - Kebun Apel',
      'desc':
          'Nikmati pengalaman autentik memetik apel Manalagi langsung dari pohonnya di ketinggian Batu, Malang. Apel Manalagi dikenal dengan rasa manisnya yang khas dan aroma yang harum. Anda akan diajak berkeliling kebun yang asri sambil belajar teknik memetik yang benar agar buah tetap segar.',
      'location': 'Batu, Malang, Jawa Timur',
      'rating': 4.8,
      'reviews': '1.2k',
      'duration': '2 – 3 Jam',
      'capacity': 'Min. 2 Orang',
      'price': 'Rp 25.000',
      'originalPrice': 'Rp 45.000',
      'priceInt': 25000,
      'badge': 'Hemat 30%',
      'tag': 'BEST SELLER',
      'timeLeft': 'Sisa 3 Jam',
      'image':
          'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=800&q=80',
      'category': 'Petik Apel',
    },
    {
      'id': 'pkg_sayur_organik',
      'title': 'Petualangan Panen Sayur Organik',
      'subtitle': 'Belajar Menanam & Memanen Sayuran',
      'desc':
          'Belajar menanam dan memanen sayuran segar langsung dari lahan organik kami yang subur. Termasuk edukasi nutrisi tanaman, petik bebas sayuran segar hidroponik dan organik.',
      'location': 'Batu, Malang, Jawa Timur',
      'rating': 4.9,
      'reviews': '850',
      'duration': '1 – 2 Jam',
      'capacity': 'Min. 1 Orang',
      'price': 'Rp 45.000',
      'originalPrice': 'Rp 65.000',
      'priceInt': 45000,
      'badge': 'Promo Eksklusif',
      'tag': 'ORGANIK',
      'timeLeft': 'Sisa 5 Jam',
      'image':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
      'category': 'Kebun Sayur',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedPackage = _packages[0];
  }

  void _openPackageDetail(Map<String, dynamic> pkg) {
    setState(() {
      _selectedPackage = pkg;
      _previousView = _exploreView;
      _exploreView = 2;
    });
  }

  void _openCheckout(Map<String, dynamic> pkg) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          product: {
            'name': pkg['title'],
            'category': 'Agro Tourism',
            'image': pkg['image'],
            'price': pkg['priceInt'],
            'rating': pkg['rating'],
            'sold': pkg['reviews'],
            'location': pkg['location'],
          },
          quantity: 1,
          totalPrice: pkg['priceInt'],
          onOrderSuccess: () {
            if (widget.onNavigateToTab != null) {
              widget.onNavigateToTab!(3); // Navigate to Pesanan
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_exploreView) {
      case 1:
        return _buildMapExploreView();
      case 2:
        return _buildDashboardLokasiView();
      case 0:
      default:
        return _buildPromoListingView();
    }
  }

  // ===========================================================================
  // SCREEN 1: PROMO & AGRO TOURISM LISTING (IMAGE 3)
  // ===========================================================================
  Widget _buildPromoListingView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Bar Header (9:41)
              _buildStatusBarHeader(onBack: widget.onBackTap),
              const SizedBox(height: 12),

              // Search Bar + Profile Avatar
              _buildSearchBar(
                hintText: 'Cari di sini',
                trailing: GestureDetector(
                  onTap: widget.onProfileTap,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF16A34A), width: 1.5),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Section Title: Akses dan Dapatkan Promo Anda!
              const Text(
                'Akses dan Dapatkan Promo Anda!',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),

              // Hero Promo Banner (Flash Deal Diskon s/d 50%)
              GestureDetector(
                onTap: () => _openPackageDetail(_packages[0]),
                child: Container(
                  width: double.infinity,
                  height: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1568644396922-5c3bfae12521?auto=format&fit=crop&w=800&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Dark gradient for contrast
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.72),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // FLASH DEAL Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEA580C),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'FLASH DEAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Diskon s/d 50%
                            const Text(
                              'Diskon s/d 50%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),

                            // Subtitle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Panen Raya: Nikmati Agrowisata Terbaik Lika...',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Dots indicator
                                Row(
                                  children: [
                                    Container(
                                      width: 14,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.5),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.5),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Filter Category Chips + Switch to Map View Button
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _promoCategories.length,
                        itemBuilder: (context, index) {
                          final isSelected = _selectedPromoCategory == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () => setState(() => _selectedPromoCategory = index),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF00C853) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF00C853) : const Color(0xFFE5E7EB),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _promoCategories[index],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFF374151),
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Button to switch to MAP VIEW
                  InkWell(
                    onTap: () => setState(() => _exploreView = 1),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14532D),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF14532D).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.map_rounded, color: Colors.white, size: 15),
                          SizedBox(width: 5),
                          Text(
                            'Peta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section Header: Promo Terbatas & LIHAT SEMUA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Promo Terbatas',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'LIHAT SEMUA',
                      style: TextStyle(
                        color: Color(0xFF15803D),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Package 1: Paket Wisata Keluarga - Kebun Apel
              _buildPromoPackageCard(_packages[0]),
              const SizedBox(height: 16),

              // Package 2: Petualangan Panen Sayur Organik
              _buildPromoPackageCard(_packages[1]),
              const SizedBox(height: 20),

              // Bottom Feature Cards (Side-by-Side: Bonus & Referral)
              Row(
                children: [
                  // Card 1: Bonus Gratis Voucher
                  Expanded(
                    child: Container(
                      height: 135,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E676), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF059669).withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 20),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'BONUS',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Gratis Voucher\nSouvenir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Card 2: Referral Ajak Teman
                  Expanded(
                    child: Container(
                      height: 135,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF047857)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF047857).withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 20),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'REFERRAL',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Ajak Teman &\nDapat Koin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoPackageCard(Map<String, dynamic> pkg) {
    return GestureDetector(
      onTap: () => _openPackageDetail(pkg),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: Image.network(
                    pkg['image'],
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 165,
                        width: double.infinity,
                        color: const Color(0xFFF3F4F6),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 165,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFDCFCE7), Color(0xFFBBF7D0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                pkg['category'] == 'Kebun Sayur' ? Icons.eco_rounded : Icons.park_rounded,
                                size: 44,
                                color: const Color(0xFF16A34A),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                pkg['title'] ?? 'Wisata Alam Agro',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Badge top left: Hemat 30% / Promo Eksklusif
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_offer_rounded, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          pkg['badge'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Badge bottom right: Sisa 3 Jam
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_rounded, color: Color(0xFF374151), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          pkg['timeLeft'],
                          style: const TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pkg['subtitle'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pkg['desc'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),

                  // Price & Action Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pkg['originalPrice'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            pkg['price'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => _openCheckout(pkg),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          'Pesan Sekarang',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // SCREEN 2: AGRO TOURISM MAP VIEW (IMAGE 2)
  // ===========================================================================
  Widget _buildMapExploreView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Satellite Map Imagery with Blue Route Overlays
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=1200&q=80',
              fit: BoxFit.cover,
            ),
          ),

          // Custom Vector Blueprint Roads Overlay (Authentic Map Feel)
          Positioned.fill(
            child: CustomPaint(
              painter: _MapRoutePainter(),
            ),
          ),

          // Interactive Map Pins
          // Pin 1: Kebun Apel Manalagi
          Positioned(
            top: 240,
            left: 140,
            child: _buildMapPin(
              title: 'Kebun Apel Manalagi',
              icon: Icons.park_rounded,
              color: const Color(0xFF15803D),
              onTap: () => _openPackageDetail(_packages[0]),
            ),
          ),

          // Pin 2: Wisata Petik Apel Mandiri Kota Batu
          Positioned(
            top: 340,
            left: 60,
            child: _buildMapPin(
              title: 'Wisata Petik Apel\nMandiri Kota Batu',
              icon: Icons.location_on_rounded,
              color: const Color(0xFFDC2626),
              isPulsing: true,
              onTap: () => _openPackageDetail(_packages[0]),
            ),
          ),

          // Pin 3: Trans / Halte Bus
          Positioned(
            top: 420,
            left: 65,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 14),
            ),
          ),

          // Pin 4: Villa / Hotel
          Positioned(
            top: 210,
            left: 45,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFDB2777),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.hotel_rounded, color: Colors.white, size: 14),
            ),
          ),

          // 2. Top Header Controls (Search + Category Filter Chips)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Bar Header (9:41)
                  _buildStatusBarHeader(
                    onBack: () => setState(() => _exploreView = 0),
                  ),
                  const SizedBox(height: 10),

                  // Search Bar
                  _buildSearchBar(
                    hintText: 'Cari di sini',
                    backgroundColor: Colors.white.withValues(alpha: 0.95),
                  ),
                  const SizedBox(height: 10),

                  // Category Pills Row
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _mapCategories.length,
                            itemBuilder: (context, index) {
                              final item = _mapCategories[index];
                              final isSelected = _selectedMapCategory == index;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  onTap: () => setState(() => _selectedMapCategory = index),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF14532D) : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          item['icon'] as IconData,
                                          color: isSelected ? Colors.white : const Color(0xFF374151),
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          item['title'] as String,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : const Color(0xFF1F2937),
                                            fontSize: 12,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Layer button
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.layers_outlined, color: Color(0xFF15803D), size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Popup Card: Kebun Apel Cak Ka
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: GestureDetector(
              onTap: () => _openPackageDetail(_packages[0]),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag pill indicator & cap icon
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Info Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kebun Apel Cak Ka',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Text(
                                    '4.8',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 15),
                                  SizedBox(width: 4),
                                  Text(
                                    '(1.2k reviews)',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'AGROWISATA',
                                      style: TextStyle(
                                        color: Color(0xFF15803D),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '🕒 Buka • 08:00 - 17:00',
                                    style: TextStyle(fontSize: 10, color: Color(0xFF4B5563)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Orchard Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=300&q=80',
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 65,
                              height: 65,
                              color: const Color(0xFFDCFCE7),
                              child: const Icon(Icons.park_rounded, color: Color(0xFF16A34A)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons Row: Petunjuk Arah, Call, Bookmark
                    Row(
                      children: [
                        // Petunjuk Arah
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _openPackageDetail(_packages[0]),
                            icon: const Icon(Icons.directions_rounded, size: 18, color: Colors.white),
                            label: const Text(
                              'Petunjuk Arah',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF14532D),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Call Icon Button
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Menghubungi pengelola Kebun Apel Cak Ka...')),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.phone_outlined, color: Color(0xFF15803D), size: 20),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Bookmark Icon Button
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lokasi disimpan ke favorit!')),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.bookmark_border_rounded, color: Color(0xFF15803D), size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isPulsing = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SCREEN 3: DASHBOARD LOKASI (DETAIL PAKET WISATA - IMAGE 1)
  // ===========================================================================
  Widget _buildDashboardLokasiView() {
    final pkg = _selectedPackage;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 18),
          onPressed: () => setState(() => _exploreView = _previousView),
        ),
        title: const Text(
          'Dashboard Lokasi',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF111827), size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan lokasi berhasil disalin!')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isDetailFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isDetailFavorite ? Colors.red : const Color(0xFF111827),
              size: 22,
            ),
            onPressed: () {
              setState(() => _isDetailFavorite = !_isDetailFavorite);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image with 1/4 counter
                Stack(
                  children: [
                    Image.network(
                      pkg['image'],
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 250,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFDCFCE7), Color(0xFFBBF7D0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.park_rounded, size: 56, color: Color(0xFF16A34A)),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          '1/4',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BEST SELLER & Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              pkg['tag'] ?? 'BEST SELLER',
                              style: const TextStyle(
                                color: Color(0xFFC2410C),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                          const SizedBox(width: 3),
                          Text(
                            '${pkg['rating']} (${pkg['reviews']} ulasan)',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Package Title
                      Text(
                        pkg['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Color(0xFF15803D), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            pkg['location'],
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tab Bar (Tentang Paket, Fasilitas, Ulasan, Diskusi)
                      _buildDetailTabBar(),
                      const SizedBox(height: 18),

                      // 2 Info Badges: Durasi & Kapasitas
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFDCFCE7)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDCFCE7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.access_time_rounded, color: Color(0xFF15803D), size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'DURASI',
                                        style: TextStyle(fontSize: 9, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        pkg['duration'],
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFFFEDD5)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFEDD5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.people_alt_rounded, color: Color(0xFFEA580C), size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'KAPASITAS',
                                        style: TextStyle(fontSize: 9, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        pkg['capacity'],
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // Section: Tentang Paket
                      const Text(
                        'Tentang Paket',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pkg['desc'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Section: Fasilitas
                      const Text(
                        'Fasilitas',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 12),
                      _buildFacilityItem(Icons.person_pin_rounded, 'Pemandu Lokal Berpengalaman'),
                      _buildFacilityItem(Icons.shopping_basket_rounded, 'Alat Petik & Keranjang Bambu'),
                      _buildFacilityItem(Icons.shopping_cart_checkout_rounded, 'Hasil Panen 1kg (Bisa dibawa pulang)'),
                      _buildFacilityItem(Icons.local_cafe_rounded, 'Welcome Drink Jus Apel Segar'),
                      const SizedBox(height: 22),

                      // Section: Ulasan Pengunjung
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ulasan Pengunjung',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Review 1: Budi Santoso
                      _buildReviewItem(
                        name: 'Budi Santoso',
                        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
                        date: '2 hari yang lalu',
                        comment: 'Apelnya manis-manis banget! Guide-nya juga ramah banget ngasih tau mana yang udah mateng.',
                        photos: const [
                          'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=200&q=80',
                          'https://images.unsplash.com/photo-1568644396922-5c3bfae12521?auto=format&fit=crop&w=200&q=80',
                        ],
                      ),
                      const Divider(height: 28),

                      // Review 2: Siti Aminah
                      _buildReviewItem(
                        name: 'Siti Aminah',
                        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
                        date: '1 minggu yang lalu',
                        comment: 'Seru buat ajak anak-anak. Udaranya sejuk dan kebunnya bersih.',
                      ),
                      const SizedBox(height: 24),

                      // Section: Pertanyaan Populer (FAQ)
                      const Text(
                        'Pertanyaan Populer',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => setState(() => _isFaqExpanded = !_isFaqExpanded),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF15803D),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('T', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Apakah boleh membawa hewan peliharaan?',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                    ),
                                  ),
                                  Icon(
                                    _isFaqExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                    size: 20,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ],
                              ),
                              if (_isFaqExpanded) ...[
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEA580C),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text('i', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Mohon maaf, demi kenyamanan bersama hewan peliharaan tidak diperkenankan di area kebun.',
                                        style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Button: Tanya Penyelenggara
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Membuka ruang diskusi dengan pengelola kebun...')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Tanya Penyelenggara',
                            style: TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Sticky Bottom Action Bar (Keranjang, Chat, Pesan Sekarang)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon Keranjang
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Paket ditambahkan ke Keranjang!')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.shopping_cart_outlined, color: Color(0xFF4B5563), size: 22),
                          SizedBox(height: 2),
                          Text('KERANJANG', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Icon Chat
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka obrolan dengan pemandu kebun...')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF4B5563), size: 22),
                          SizedBox(height: 2),
                          Text('CHAT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Big Green Button: Pesan Sekarang
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openCheckout(pkg),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Pesan Sekarang',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_detailTabs.length, (index) {
          final isSelected = _selectedDetailTab == index;
          return Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: InkWell(
              onTap: () => setState(() => _selectedDetailTab = index),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _detailTabs[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF14532D) : const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 2.5,
                      color: isSelected ? const Color(0xFF14532D) : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFacilityItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF15803D), size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String avatar,
    required String date,
    required String comment,
    List<String>? photos,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(avatar),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                Row(
                  children: List.generate(
                    5,
                    (i) => const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
          ],
        ),
        const SizedBox(height: 8),
        Text(comment, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.35)),
        if (photos != null && photos.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: photos.map((url) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    url,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: const Color(0xFFE5E7EB),
                      child: const Icon(Icons.image_not_supported_rounded, color: Color(0xFF9CA3AF), size: 20),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // ===========================================================================
  // COMMON HELPER WIDGETS
  // ===========================================================================
  Widget _buildStatusBarHeader({VoidCallback? onBack}) {
    return Row(
      children: [
        if (onBack != null)
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF111827)),
              ),
            ),
          ),
        const Expanded(
          child: AdaptiveStatusBar(),
        ),
      ],
    );
  }

  Widget _buildSearchBar({
    required String hintText,
    Widget? trailing,
    Color backgroundColor = const Color(0xFFF3F4F6),
  }) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(
                    onNavigateToTab: widget.onNavigateToTab,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF6B7280), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      hintText,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(Icons.mic_none_rounded, color: Color(0xFF15803D), size: 20),
                ],
              ),
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 10),
          trailing,
        ],
      ],
    );
  }
}

// Custom Painter for Map Route (Blue Blueprint Roads)
class _MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.85)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final secondaryPaint = Paint()
      ..color = const Color(0xFF60A5FA).withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Route 1 (Main Road through Batu)
    final path1 = Path();
    path1.moveTo(20, 100);
    path1.lineTo(80, 200);
    path1.lineTo(150, 280);
    path1.lineTo(240, 310);
    path1.lineTo(size.width, 360);
    canvas.drawPath(path1, routePaint);

    // Route 2 (Connecting orchard roads)
    final path2 = Path();
    path2.moveTo(80, 200);
    path2.lineTo(70, 360);
    path2.lineTo(160, 480);
    path2.lineTo(260, 520);
    canvas.drawPath(path2, routePaint);

    // Secondary connecting road
    final path3 = Path();
    path3.moveTo(150, 280);
    path3.lineTo(170, 180);
    path3.lineTo(280, 140);
    canvas.drawPath(path3, secondaryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
