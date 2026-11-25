import 'package:flutter/material.dart';
import '../services/adaptive_device.dart';
import '../widgets/lika_brand.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool startAtAuthChoice;

  const OnboardingScreen({
    super.key,
    this.startAtAuthChoice = false,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, String>> _slides = const [
    {
      'title': 'Layanan Interaktif Komunitas Agro',
      'desc':
          'Temukan pengalaman agrowisata, belanja hasil panen lokal, serta berinteraksi dengan komunitas petani & Agro AI.',
    },
    {
      'title': 'Memberdayakan UMKM Lokal',
      'desc':
          'Dukung petani dan UMKM desa dengan menikmati olahan buah segar, madu alami, dan produk pertanian berkualitas.',
    },
    {
      'title': 'Dari Kebun Ke Genggaman Anda',
      'desc':
          'Buah dan sayur organik segar dipetik langsung dari kebun pilihan dan diantar cepat ke depan pintu Anda.',
    },
    {
      'title': 'Wisata Cerdas, Mudah Dipesan',
      'desc':
          'Pesan tiket wisata petik apel secara instan, pantau rute kebun interaktif, dan rencanakan liburan keluarga Anda.',
    },
    {
      'title': 'Belanja, Wisata, dan Bermain',
      'desc':
          'Tangkap Apelmon seru di sekitar kebun, kumpulkan koin panen, dan tukarkan dengan berbagai voucher menarik.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.startAtAuthChoice ? _slides.length : 0;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToAuthChoice() {
    _pageController.animateToPage(
      _slides.length,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _slides.length + 1;

    return Scaffold(
      body: LikaGreenBackground(
        darkTop: _currentPage == _slides.length ? false : true,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                child: AdaptiveStatusBar(contentColor: Colors.white),
              ),
              // Top bar: Skip button on onboarding slides
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0 && _currentPage < _slides.length)
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        )
                      else
                        const SizedBox(width: 40),
                      if (_currentPage < _slides.length)
                        TextButton(
                          onPressed: _skipToAuthChoice,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.18),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Lewati',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Main PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (index < _slides.length) {
                      return _buildOnboardingSlide(index);
                    }
                    return _buildAuthChoicePage();
                  },
                ),
              ),

              // Page Indicator Dots (only on the 5 onboarding slides)
              if (_currentPage < _slides.length) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (index) {
                    final active = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 22 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                // Bottom "Lanjutkan" gradient cream/lime pill button
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 26, 28),
                  child: GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFEFCE8), Color(0xFFBEF264)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Lanjutkan',
                          style: TextStyle(
                            color: Color(0xFF14532D),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingSlide(int index) {
    final slide = _slides[index];
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - 16).clamp(0.0, double.infinity),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slide['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    shadows: [
                      Shadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: LikaAppleMascot(slideIndex: index),
                ),
                const SizedBox(height: 18),
                Text(
                  slide['desc']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.94),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthChoicePage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Agrowisata Platform',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  const LikaLogoMark(size: 112),
                  const SizedBox(height: 14),
                  const Text(
                    'LIKA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3.0,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nikmati Pengalaman Petik Buah,\nBelanja Hasil Tani, & Jelajah Kebun',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.90),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),

          // Sign Up Button (Dark-to-green gradient matching Figma)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF16A34A), Color(0xFF14532D)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Sign In Button (Light cream/white matching Figma)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7FEE7),
                foregroundColor: const Color(0xFF14532D),
                elevation: 3,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
