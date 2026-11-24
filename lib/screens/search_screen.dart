import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'checkout_screen.dart';

class SearchScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  final String initialQuery;

  const SearchScreen({
    super.key,
    this.onNavigateToTab,
    this.initialQuery = '',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  String _currentQuery = '';
  int _selectedCategoryIndex = 0; // 0: Semua, 1: Agrowisata, 2: Komoditas Buah, 3: Sayur & Olahan

  final List<String> _categories = [
    'Semua',
    'Agrowisata',
    'Komoditas Buah',
    'Sayur & Olahan',
  ];

  // Recent Searches
  final List<String> _recentSearches = [
    'Apel Manalagi',
    'Kebun Apel Cak Ka',
    'Jeruk Keprok Batu',
    'Panen Sayur Organik',
  ];

  // Popular Trending Searches
  final List<Map<String, String>> _popularSearches = [
    {'text': 'Apel Manalagi Batu', 'icon': '🍎'},
    {'text': 'Petik Apel Cak Ka', 'icon': '🌿'},
    {'text': 'Jeruk Keprok 55', 'icon': '🍊'},
    {'text': 'Sayuran Organik', 'icon': '🥕'},
    {'text': 'Promo Tiket 50%', 'icon': '🎟️'},
    {'text': 'Stroberi Segar', 'icon': '🍓'},
  ];

  // Master Database of Searchable Items
  final List<Map<String, dynamic>> _allItems = [
    // Agrowisata
    {
      'id': 'wisata-1',
      'title': 'Paket Petik Apel Cak Ka',
      'category': 'Agrowisata',
      'subcategory': 'Petik Buah',
      'location': 'Batu, Malang, Jawa Timur',
      'price': 25000,
      'unit': '/ orang',
      'rating': 4.8,
      'reviews': '1.2k ulasan',
      'isBestSeller': true,
      'image': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
      'desc': 'Petik apel Manalagi langsung dari pohonnya di ketinggian Batu dengan pemandu lokal berpengalaman.',
      'tags': ['apel', 'wisata', 'cak ka', 'kebun', 'petik', 'batu', 'keluarga'],
    },
    {
      'id': 'wisata-2',
      'title': 'Paket Wisata Keluarga – Kebun Apel',
      'category': 'Agrowisata',
      'subcategory': 'Paket Keluarga',
      'location': 'Bumiaji, Kota Batu',
      'price': 25000,
      'unit': '/ orang',
      'rating': 4.7,
      'reviews': '850 ulasan',
      'isBestSeller': false,
      'image': 'https://images.unsplash.com/photo-1594498653385-d5172c532c00?auto=format&fit=crop&w=600&q=80',
      'desc': 'Nikmati akhir pekan seru di kebun pilihan keluarga dengan pemandu ramah dan fasilitas lengkap.',
      'tags': ['wisata', 'keluarga', 'kebun', 'apel', 'batu', 'promo'],
    },
    {
      'id': 'wisata-3',
      'title': 'Petualangan Panen Sayur Organik',
      'category': 'Agrowisata',
      'subcategory': 'Edukasi Tani',
      'location': 'Trawas, Mojokerto',
      'price': 45000,
      'unit': '/ orang',
      'rating': 4.9,
      'reviews': '640 ulasan',
      'isBestSeller': true,
      'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      'desc': 'Belajar menanam dan memanen sayuran segar langsung dari lahan organik dataran tinggi yang asri.',
      'tags': ['sayur', 'organik', 'trawas', 'edukasi', 'panen', 'wisata'],
    },
    {
      'id': 'wisata-4',
      'title': 'Wisata Petik Apel Mandiri Kota Batu',
      'category': 'Agrowisata',
      'subcategory': 'Petik Buah',
      'location': 'Pesanggrahan, Kec. Batu',
      'price': 30000,
      'unit': '/ orang',
      'rating': 4.6,
      'reviews': '920 ulasan',
      'isBestSeller': false,
      'image': 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?auto=format&fit=crop&w=600&q=80',
      'desc': 'Wisata mandiri dengan jalur trekking kebun sejuk dan bonus makan apel sepuasnya di kebun.',
      'tags': ['apel', 'mandiri', 'batu', 'wisata', 'petik'],
    },
    {
      'id': 'wisata-5',
      'title': 'Wisata Edukasi Kebun Jeruk Keprok',
      'category': 'Agrowisata',
      'subcategory': 'Petik Jeruk',
      'location': 'Dau, Malang',
      'price': 35000,
      'unit': '/ orang',
      'rating': 4.7,
      'reviews': '510 ulasan',
      'isBestSeller': false,
      'image': 'https://images.unsplash.com/photo-1557800636-894a64c1696f?auto=format&fit=crop&w=600&q=80',
      'desc': 'Rasakan manis dan segarnya jeruk keprok 55 langsung dari dahan pohon di perbukitan Dau.',
      'tags': ['jeruk', 'keprok', 'edukasi', 'wisata', 'malang', 'dau'],
    },

    // Komoditas Buah
    {
      'id': 'buah-1',
      'title': 'Apel Batu Manalagi Super Grade A',
      'category': 'Komoditas Buah',
      'subcategory': 'Apel Segar',
      'location': 'Petani Bumiaji, Batu',
      'price': 30000,
      'unit': '/ kg',
      'rating': 4.8,
      'reviews': '1.5k terjual',
      'isBestSeller': true,
      'image': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
      'desc': 'Apel Manalagi kualitas ekspor dengan aroma harum khas dan rasa manis renyah.',
      'tags': ['apel', 'manalagi', 'batu', 'buah', 'manis', 'segar'],
    },
    {
      'id': 'buah-2',
      'title': 'Apel Anna Segar Khas Batu',
      'category': 'Komoditas Buah',
      'subcategory': 'Apel Segar',
      'location': 'Petani Tulungrejo, Batu',
      'price': 28000,
      'unit': '/ kg',
      'rating': 4.7,
      'reviews': '980 terjual',
      'isBestSeller': false,
      'image': 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?auto=format&fit=crop&w=600&q=80',
      'desc': 'Apel merah merona dengan perpaduan rasa manis asam segar yang sangat cocok untuk jus & diet.',
      'tags': ['apel', 'anna', 'merah', 'buah', 'jus'],
    },
    {
      'id': 'buah-3',
      'title': 'Stroberi Batu Segar Pilihan',
      'category': 'Komoditas Buah',
      'subcategory': 'Buah Berry',
      'location': 'Kebun Stroberi Pandanrejo',
      'price': 50000,
      'unit': '/ box (500g)',
      'rating': 4.8,
      'reviews': '720 terjual',
      'isBestSeller': true,
      'image': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=600&q=80',
      'desc': 'Stroberi berukuran besar dengan warna merah pekat dan rasa manis segar tanpa pengawet.',
      'tags': ['stroberi', 'strawberry', 'batu', 'buah', 'segar'],
    },
    {
      'id': 'buah-4',
      'title': 'Jeruk Keprok 55 Manis Segar',
      'category': 'Komoditas Buah',
      'subcategory': 'Jeruk Segar',
      'location': 'Petani Selorejo, Dau',
      'price': 22000,
      'unit': '/ kg',
      'rating': 4.9,
      'reviews': '1.1k terjual',
      'isBestSeller': true,
      'image': 'https://images.unsplash.com/photo-1557800636-894a64c1696f?auto=format&fit=crop&w=600&q=80',
      'desc': 'Jeruk keprok varietas 55 unggulan berair banyak dengan rasa manis kaya vitamin C.',
      'tags': ['jeruk', 'keprok', '55', 'buah', 'vitamin', 'manis'],
    },

    // Sayur & Olahan
    {
      'id': 'sayur-1',
      'title': 'Sayur Selada & Bayam Organik Segar',
      'category': 'Sayur & Olahan',
      'subcategory': 'Sayuran Hidroponik',
      'location': 'Greenhouse Trawas',
      'price': 5000,
      'unit': '/ ikat',
      'rating': 4.8,
      'reviews': '2.3k terjual',
      'isBestSeller': true,
      'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      'desc': 'Sayur mayur bebas pestisida dipanen pada pagi hari saat kandungan nutrisi sedang maksimal.',
      'tags': ['sayur', 'selada', 'bayam', 'organik', 'hidroponik', 'segar'],
    },
    {
      'id': 'sayur-2',
      'title': 'Kripik Apel Asli Batu Super Renyah',
      'category': 'Sayur & Olahan',
      'subcategory': 'Olahan Buah',
      'location': 'UMKM Batu Sejahtera',
      'price': 18000,
      'unit': '/ bungkus',
      'rating': 4.9,
      'reviews': '3.4k terjual',
      'isBestSeller': true,
      'image': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
      'desc': 'Kripik apel diproses dengan teknologi vacuum frying suhu rendah sehingga nutrisi tetap terjaga.',
      'tags': ['kripik', 'apel', 'camilan', 'oleh-oleh', 'batu', 'olahan'],
    },
    {
      'id': 'sayur-3',
      'title': 'Madu Murni Nektar Bunga Apel',
      'category': 'Sayur & Olahan',
      'subcategory': 'Produk Lebah',
      'location': 'Peternak Lebah Kebun Apel',
      'price': 75000,
      'unit': '/ botol (350ml)',
      'rating': 4.9,
      'reviews': '480 terjual',
      'isBestSeller': false,
      'image': 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&w=600&q=80',
      'desc': 'Madu lebah asli yang menghisap nektar bunga pohon apel Batu, 100% murni tanpa campuran gula.',
      'tags': ['madu', 'murni', 'bunga', 'apel', 'kesehatan', 'herbal'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.initialQuery;
    _searchController = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode();

    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatRupiah(int amount) {
    final buffer = StringBuffer();
    final str = amount.toString();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    final query = _currentQuery.trim().toLowerCase();
    final selectedCategory = _categories[_selectedCategoryIndex];

    return _allItems.where((item) {
      // Category Filter
      if (selectedCategory != 'Semua' && item['category'] != selectedCategory) {
        return false;
      }

      // Query Filter
      if (query.isEmpty) {
        return true;
      }

      final title = (item['title'] as String).toLowerCase();
      final desc = (item['desc'] as String).toLowerCase();
      final location = (item['location'] as String).toLowerCase();
      final subcategory = (item['subcategory'] as String).toLowerCase();
      final tags = (item['tags'] as List<String>).join(' ').toLowerCase();

      return title.contains(query) ||
          desc.contains(query) ||
          location.contains(query) ||
          subcategory.contains(query) ||
          tags.contains(query);
    }).toList();
  }

  void _performSearch(String query) {
    setState(() {
      _currentQuery = query;
      _searchController.text = query;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: query.length),
      );
    });

    if (query.trim().isNotEmpty && !_recentSearches.contains(query.trim())) {
      setState(() {
        _recentSearches.insert(0, query.trim());
        if (_recentSearches.length > 6) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = _getFilteredItems();
    final isQueryActive = _currentQuery.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1F2937), size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF1F4),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.search,
                    onChanged: (val) {
                      setState(() {
                        _currentQuery = val;
                      });
                    },
                    onSubmitted: (val) {
                      _performSearch(val);
                    },
                    style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6B7280), size: 20),
                      hintText: 'Cari buah segar atau paket wisata...',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      suffixIcon: _currentQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.cancel_rounded, color: Color(0xFF9CA3AF), size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _currentQuery = '';
                                });
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF15803D), size: 20),
                              tooltip: 'Pencarian Suara',
                              onPressed: _simulateVoiceSearch,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                return ChoiceChip(
                  label: Text(_categories[index]),
                  selected: isSelected,
                  selectedColor: const Color(0xFF15803D),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF4B5563),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  backgroundColor: const Color(0xFFF3F4F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE5E7EB),
                  ),
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If user has not typed yet, show Recent Searches & Popular Searches
            if (!isQueryActive) ...[
              _buildRecentSearchesSection(),
              const SizedBox(height: 20),
              _buildPopularSearchesSection(),
              const SizedBox(height: 20),
              _buildRecommendationsHeader(),
              const SizedBox(height: 12),
            ] else ...[
              // Search Results Header with Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Hasil untuk ',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                      children: [
                        TextSpan(
                          text: '"$_currentQuery"',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${filteredResults.length} ditemukan',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            // Results List
            if (filteredResults.isEmpty)
              _buildEmptyResultsState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredResults.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildSearchResultCard(filteredResults[index]);
                },
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- RECENT SEARCHES ---
  Widget _buildRecentSearchesSection() {
    if (_recentSearches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.history_rounded, size: 18, color: Color(0xFF6B7280)),
                SizedBox(width: 6),
                Text(
                  'Pencarian Terakhir',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _recentSearches.clear();
                });
              },
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: const Text('Hapus Semua', style: TextStyle(fontSize: 11, color: Color(0xFFDC2626))),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.map((search) {
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _performSearch(search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.north_west_rounded, size: 12, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Text(search, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- POPULAR SEARCHES ---
  Widget _buildPopularSearchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.local_fire_department_rounded, size: 18, color: Color(0xFFEA580C)),
            SizedBox(width: 6),
            Text(
              'Pencarian Populer di Batu & Malang',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularSearches.map((pop) {
            return ActionChip(
              avatar: Text(pop['icon']!, style: const TextStyle(fontSize: 14)),
              label: Text(pop['text']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              onPressed: () => _performSearch(pop['text']!),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- RECOMMENDATIONS HEADER ---
  Widget _buildRecommendationsHeader() {
    return const Row(
      children: [
        Icon(Icons.recommend_rounded, size: 18, color: Color(0xFF15803D)),
        SizedBox(width: 6),
        Text(
          'Rekomendasi Paket & Buah Pilihan',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
        ),
      ],
    );
  }

  // --- SEARCH RESULT CARD ---
  Widget _buildSearchResultCard(Map<String, dynamic> item) {
    final isWisata = item['category'] == 'Agrowisata';
    final priceStr = _formatRupiah(item['price'] as int);
    final isBestSeller = item['isBestSeller'] == true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleItemClick(item),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item['image'] as String,
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 84,
                          height: 84,
                          color: const Color(0xFFE5E7EB),
                          child: const Icon(Icons.image_not_supported_rounded, color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    if (isBestSeller)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEA580C),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'BEST',
                            style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isWisata ? const Color(0xFFDCFCE7) : const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['category'] as String,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: isWisata ? const Color(0xFF15803D) : const Color(0xFFEA580C),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item['subcategory'] as String,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Title
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),

                      // Location / Unit
                      Row(
                        children: [
                          Icon(
                            isWisata ? Icons.location_on_outlined : Icons.storefront_outlined,
                            size: 13,
                            color: const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              item['location'] as String,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Price & Action Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: priceStr,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                              children: [
                                TextSpan(
                                  text: ' ${item['unit']}',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isWisata ? const Color(0xFF15803D) : const Color(0xFF0284C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isWisata ? 'Pesan Tiket' : 'Beli',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
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
        ),
      ),
    );
  }

  // --- EMPTY RESULTS ---
  Widget _buildEmptyResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 14),
            const Text(
              'Tidak Ada Hasil Ditemukan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 6),
            Text(
              'Tidak menemukan buah atau wisata dengan kata kunci "$_currentQuery". Coba cari "apel", "cak ka", atau "sayur".',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _currentQuery = '';
                  _selectedCategoryIndex = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF15803D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reset Pencarian'),
            ),
          ],
        ),
      ),
    );
  }

  // --- HANDLE ITEM CLICK ---
  void _handleItemClick(Map<String, dynamic> item) {
    final isWisata = item['category'] == 'Agrowisata';

    if (isWisata) {
      // Wisata Booking Sheet
      _showWisataBookingSheet(item);
    } else {
      // Product Detail Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(
            product: {
              'title': item['title'],
              'price': item['price'],
              'rating': item['rating'],
              'image': item['image'],
              'desc': item['desc'],
              'taste': 'Segar, Manis alami khas perkebunan Batu',
            },
            onOrderSuccess: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pesanan ${item['title']} berhasil dibuat!'),
                  backgroundColor: const Color(0xFF15803D),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  void _showWisataBookingSheet(Map<String, dynamic> item) {
    int ticketCount = 2;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final totalPrice = (item['price'] as int) * ticketCount;

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item['image'] as String,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Agrowisata Terbaik',
                                style: TextStyle(color: Color(0xFF15803D), fontSize: 9.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item['title'] as String,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_formatRupiah(item['price'] as int)} / orang',
                              style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jumlah Pengunjung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Tiket masuk kebun + petik buah', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF15803D)),
                            onPressed: ticketCount > 1
                                ? () => setSheetState(() => ticketCount--)
                                : null,
                          ),
                          Text(
                            '$ticketCount',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF15803D)),
                            onPressed: () => setSheetState(() => ticketCount++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Pembayaran', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                      Text(
                        _formatRupiah(totalPrice),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(
                              product: {
                                'title': item['title'],
                                'price': item['price'],
                                'image': item['image'],
                              },
                              quantity: ticketCount,
                              totalPrice: totalPrice,
                              onOrderSuccess: () {
                                if (widget.onNavigateToTab != null) {
                                  widget.onNavigateToTab!(3);
                                }
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF15803D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Lanjut ke Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _simulateVoiceSearch() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic_rounded, color: Color(0xFF15803D), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Mendengarkan...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Katakan nama buah atau paket wisata yang Anda cari',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('"Apel Batu"'),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _performSearch('Apel Batu');
                  },
                ),
                ActionChip(
                  label: const Text('"Cak Ka"'),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _performSearch('Cak Ka');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
