import 'package:flutter/material.dart';
import '../services/adaptive_device.dart';
import '../services/database_service.dart';
import '../services/order_state.dart';
import 'agro_ai_screen.dart';
import 'donation_screen.dart';
import 'explore_screen.dart';
import 'game_screen.dart';
import 'market_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'tracking_screen.dart';
import 'umkm_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _syncFirestoreCollections();
  }

  Future<void> _syncFirestoreCollections() async {
    // Warm up and auto-seed Firestore collections if empty
    await Future.wait([
      DatabaseService.instance.fetchUserProfile(),
      DatabaseService.instance.fetchCategories(),
      DatabaseService.instance.fetchDestinations(),
      DatabaseService.instance.fetchProducts(),
      OrderState.instance.refreshOrders(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 1:
        return ExploreScreen(
          onProfileTap: () {
            setState(() {
              _selectedIndex = 4;
            });
          },
          onBackTap: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
          onNavigateToTab: (tabIndex) {
            setState(() {
              _selectedIndex = tabIndex;
            });
          },
        );
      case 2:
        return MarketScreen(
          onProfileTap: () {
            setState(() {
              _selectedIndex = 4;
            });
          },
          onNavigateToTab: (tabIndex) {
            setState(() {
              _selectedIndex = tabIndex;
            });
          },
        );
      case 3:
        return OrdersScreen(
          onGoToMarket: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
        );
      case 4:
        return ProfileScreen(
          showBackButton: false,
          onNavigateToTab: (tabIndex) {
            setState(() {
              _selectedIndex = tabIndex;
            });
          },
        );
      case 0:
      default:
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Status Bar Mockup Header (9:41 & Icons)
                _buildStatusBarHeader(),
                const SizedBox(height: 12),

                // 2. Search Bar
                _buildSearchBar(),
                const SizedBox(height: 18),

                // 3. Promo Banner Card
                _buildPromoBanner(),
                const SizedBox(height: 22),

                // 4. Category Grid (2 rows x 3 columns)
                _buildCategoryGrid(),
                const SizedBox(height: 22),

                // 5. Active Order Card (Pesanan Aktif)
                _buildActiveOrderCard(),
                const SizedBox(height: 24),

                // 6. Momen Wisata Section
                _buildMomenWisataSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
    }
  }

  // --- 1. STATUS BAR HEADER (ADAPTIVE IOS / ANDROID) ---
  Widget _buildStatusBarHeader() {
    return const AdaptiveStatusBar();
  }

  // --- 2. SEARCH BAR & PROFILE AVATAR ---
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(
                    onNavigateToTab: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF1F4),
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, color: Color(0xFF6B7280), size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cari buah segar atau paket wisata...',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.mic_none_rounded, color: Color(0xFF15803D), size: 20),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = 4;
            });
          },
          child: Container(
            width: 44,
            height: 44,
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
      ],
    );
  }

  // --- 3. PROMO BANNER ---
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16A34A).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative watermark shapes
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag "PROMO TERBATAS"
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PROMO TERBATAS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Headline
                const Text(
                  'Festival Apel &\nPanen Raya!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.22,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                Text(
                  'Diskon s/d 50% untuk semua hasil bumi.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14),

                // Carousel Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 18,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. CATEGORY GRID (2x3) ---
  Widget _buildCategoryGrid() {
    final categories = [
      {
        'title': 'Agro Tourism',
        'icon': Icons.eco_rounded,
        'bg': const Color(0xFFDCFCE7),
        'color': const Color(0xFF15803D),
      },
      {
        'title': 'Pasar',
        'icon': Icons.shopping_basket_rounded,
        'bg': const Color(0xFFFFEDD5),
        'color': const Color(0xFFEA580C),
      },
      {
        'title': 'Game',
        'icon': Icons.sports_esports_rounded,
        'bg': const Color(0xFFE0F2FE),
        'color': const Color(0xFF0284C7),
      },
      {
        'title': 'UMKM Kita',
        'icon': Icons.storefront_rounded,
        'bg': const Color(0xFFCCFBF1),
        'color': const Color(0xFF0F766E),
      },
      {
        'title': 'Donasi',
        'icon': Icons.volunteer_activism_rounded,
        'bg': const Color(0xFFFCE7F3),
        'color': const Color(0xFFDB2777),
      },
      {
        'title': 'Agro AI',
        'isAvatar': true,
        'bg': const Color(0xFFBAE6FD),
        'color': const Color(0xFF0369A1),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.96,
      ),
      itemBuilder: (context, index) {
        final item = categories[index];
        final isAvatar = item['isAvatar'] == true;

        return InkWell(
          onTap: () {
            if (item['title'] == 'Agro Tourism') {
              setState(() {
                _selectedIndex = 1;
              });
            } else if (item['title'] == 'Pasar') {
              setState(() {
                _selectedIndex = 2;
              });
            } else if (item['title'] == 'Game') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameScreen()),
              );
            } else if (item['title'] == 'UMKM Kita') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UmkmScreen()),
              );
            } else if (item['title'] == 'Donasi') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DonationScreen()),
              );
            } else if (item['title'] == 'Agro AI') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgroAiScreen()),
              );
            }
          },
          borderRadius: BorderRadius.circular(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: item['bg'] as Color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: isAvatar
                    ? Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber.shade200,
                          ),
                          child: const Center(
                            child: Text('👨‍🌾', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                      )
                    : Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                        size: 28,
                      ),
              ),
              const SizedBox(height: 7),
              Text(
                item['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 5. ACTIVE ORDER CARD (PESANAN AKTIF) ---
  Widget _buildActiveOrderCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Color(0xFF16A34A), width: 4),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Icon Delivery Truck
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Color(0xFF15803D),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Detail Pesanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'PESANAN AKTIF',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4B5563),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Apel Cak Ka',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const Text(
                      'Trawas, Mojokerto',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Driver sudah di Jl. Ijen',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol LACAK
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrackingScreen(
                        orderCode: '#FH341391',
                        productName: 'Apel Cak Ka (10 kg)',
                        destination: 'Jl. Ijen No. 12, Malang',
                        driverName: 'Cak Yo',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14532D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 34),
                ),
                child: const Text(
                  'LACAK',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 6. MOMEN WISATA SECTION ---
  Widget _buildMomenWisataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Text(
              'Momen Wisata',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEA580C),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'BARU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Color(0xFF15803D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Carousel List
        SizedBox(
          height: 270,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            children: [
              _buildStoryCard(
                username: '@ananda_ganteng',
                caption: 'Pagi Syahdu di Kebun Batu',
                likes: '1.2k',
                views: '8k',
                imageUrl: 'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=600&q=80',
              ),
              const SizedBox(width: 14),
              _buildStoryCard(
                username: '@petani_agro99',
                caption: 'Panen Jeruk Madu Seger Banget!',
                likes: '950',
                views: '5.4k',
                imageUrl: 'https://images.unsplash.com/photo-1618160702438-9b02ab6515c9?auto=format&fit=crop&w=600&q=80',
              ),
              const SizedBox(width: 14),
              _buildStoryCard(
                username: '@kebun_segar',
                caption: 'Wisata Petik Apel Malang',
                likes: '2.3k',
                views: '11k',
                imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Story Card Item
  Widget _buildStoryCard({
    required String username,
    required String caption,
    required String likes,
    required String views,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () => _openStoryModal(
        context: context,
        username: username,
        caption: caption,
        likes: likes,
        views: views,
        imageUrl: imageUrl,
      ),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 172,
        height: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
            // Gambar Background
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2E7D32),
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.white54, size: 40),
                  ),
                );
              },
            ),

            // Gradient Top & Bottom
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.25, 0.55, 1.0],
                ),
              ),
            ),

            // User Info (Atas)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Caption & Stats (Bawah)
            Positioned(
              bottom: 12,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        likes,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.remove_red_eye_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        views,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
    ),
  );
}

  void _openStoryModal({
    required BuildContext context,
    required String username,
    required String caption,
    required String likes,
    required String views,
    required String imageUrl,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFF16A34A),
                                child: Text('🍎', style: TextStyle(fontSize: 16)),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text('$views tayangan • Kota Batu', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(caption, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 18),
                                    const SizedBox(width: 6),
                                    Text(likes, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 18),
                                    SizedBox(width: 6),
                                    Text('Komentar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 7. BOTTOM NAVIGATION BAR ---
  Widget _buildBottomNavigationBar() {
    final navItems = [
      {'label': 'Beranda', 'icon': Icons.home_rounded},
      {'label': 'Jelajah', 'icon': Icons.explore_outlined},
      {'label': 'Pasar', 'icon': Icons.shopping_bag_outlined},
      {'label': 'Pesanan', 'icon': Icons.receipt_long_outlined},
      {'label': 'Profil', 'icon': Icons.person_outline_rounded},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = _selectedIndex == index;

                if (isSelected) {
                  return _buildActiveTab(
                    icon: item['icon'] as IconData,
                    label: item['label'] as String,
                  );
                }

                return _buildInactiveTab(
                  index: index,
                  icon: item['icon'] as IconData,
                  label: item['label'] as String,
                );
              }),
            ),
            const AdaptiveHomeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTab({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF14532D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveTab({
    required int index,
    required IconData icon,
    required String label,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF6B7280), size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
