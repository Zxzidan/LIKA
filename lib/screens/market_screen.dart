import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class MarketScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;
  final Function(int)? onNavigateToTab;

  const MarketScreen({super.key, this.onProfileTap, this.onNavigateToTab});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _selectedTab = 0; // 0: Komoditas, 1: Popular, 2: Recommended

  final List<Map<String, dynamic>> _horizontalProducts = [
    {
      'title': 'Apel Batu',
      'price': 30000,
      'rating': 4.5,
      'image': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
      'desc': 'Apel segar langsung dari kota Batu, Malang, dikenal dengan rasanya yang manis sedikit asam dan teksturnya yang renyah.',
      'taste': 'Manis, Segar, Asam',
    },
    {
      'title': 'Sayur Segar',
      'price': 5000,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      'desc': 'Sayur mayur organik dipetik langsung dari kebun dataran tinggi, kaya nutrisi dan bebas pestisida.',
      'taste': 'Segar, Renyah',
    },
  ];

  final List<Map<String, dynamic>> _verticalProducts = [
    {
      'title': 'Apel Batu',
      'price': 30000,
      'rating': 4.5,
      'image': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
      'desc': 'Apel segar langsung dari kota Batu, Malang, dikenal dengan rasanya yang manis sedikit asam dan teksturnya yang renyah.',
      'taste': 'Manis, Segar, Asam',
    },
    {
      'title': 'Sayur Segar',
      'price': 5000,
      'rating': 4.7,
      'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      'desc': 'Sayur mayur segar pilihan langsung dari petani lokal.',
      'taste': 'Segar, Alami',
    },
    {
      'title': 'Stroberi Batu',
      'price': 50000,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=600&q=80',
      'desc': 'Stroberi manis segar berukuran besar khas perkebunan Batu.',
      'taste': 'Manis, Asam Segar',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Bar 9:41
            _buildStatusBarHeader(),
            const SizedBox(height: 14),

            // Header Title + Subtitle + Profile Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pasar Rakyat',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jelajahi Aneka Komoditas\nUnggulan Kami!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: widget.onProfileTap,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
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
            ),
            const SizedBox(height: 20),

            // Top Horizontal Cards
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _horizontalProducts.length,
                itemBuilder: (context, index) {
                  final p = _horizontalProducts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: _buildHorizontalCard(p),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Category Tabs (Komoditas, Popular, Recommended)
            Row(
              children: [
                _buildCategoryTab(0, 'Komoditas'),
                const SizedBox(width: 20),
                _buildCategoryTab(1, 'Popular'),
                const SizedBox(width: 20),
                _buildCategoryTab(2, 'Recommended'),
              ],
            ),
            const SizedBox(height: 16),

            // Vertical Products List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _verticalProducts.length,
              itemBuilder: (context, index) {
                final p = _verticalProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: _buildVerticalCard(p),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBarHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '9:41',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        Row(
          children: [
            Icon(Icons.signal_cellular_alt_rounded, size: 16, color: Color(0xFF111827)),
            SizedBox(width: 4),
            Icon(Icons.wifi_rounded, size: 16, color: Color(0xFF111827)),
            SizedBox(width: 6),
            Icon(Icons.battery_full_rounded, size: 20, color: Color(0xFF111827)),
          ],
        ),
      ],
    );
  }

  Widget _buildHorizontalCard(Map<String, dynamic> p) {
    return InkWell(
      onTap: () => _openDetail(p),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                p['image'] as String,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (starIdx) => Icon(
                          starIdx < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                          color: const Color(0xFFF59E0B),
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${p['rating']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
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
    );
  }

  Widget _buildCategoryTab(int index, String label) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 30,
              height: 2.5,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerticalCard(Map<String, dynamic> p) {
    return InkWell(
      onTap: () => _openDetail(p),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                p['image'] as String,
                width: 65,
                height: 65,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 65,
                  height: 65,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p['title'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'IDR ${_formatNumber(p['price'] as int)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ...List.generate(
                  5,
                  (starIdx) => Icon(
                    starIdx < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${p['rating']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          onOrderSuccess: () {
            // When payment completes, switch to Pesanan (tab 3)!
            if (widget.onNavigateToTab != null) {
              widget.onNavigateToTab!(3);
            }
          },
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
