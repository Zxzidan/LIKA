import 'dart:async';
import 'package:flutter/material.dart';
import '../services/adaptive_device.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentView = 0; // 0: Map, 1: Catch, 2: Success, 3: Inventory
  int _points = 1250;
  int _xp = 450;
  bool _gembrodCaught = false;
  bool _isCatching = false;
  bool _flashOn = false;
  bool _showGrid = true;
  bool _isShutterFlashing = false;
  Offset? _focusPoint;
  Timer? _focusTimer;

  final List<Map<String, dynamic>> _inventory = [
    {
      'name': 'UJANG',
      'desc': 'Jus Apel Segar Batu',
      'image': 'https://images.unsplash.com/photo-1576179635662-9d1983e97e1e?auto=format&fit=crop&w=400&q=80',
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'UDIN',
      'desc': 'Keripik Organik Renyah',
      'image': 'https://images.unsplash.com/photo-1568644396922-5c3bfae12521?auto=format&fit=crop&w=400&q=80',
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': 'MEMED',
      'desc': 'Sari Apel Berkarbonasi',
      'image': 'https://images.unsplash.com/photo-1596560548464-f010549b84d7?auto=format&fit=crop&w=400&q=80',
      'color': const Color(0xFFEAB308),
    },
  ];

  @override
  Widget build(BuildContext context) {
    switch (_currentView) {
      case 1:
        return _buildCatchView();
      case 2:
        return _buildSuccessView();
      case 3:
        return _buildInventoryView();
      case 0:
      default:
        return _buildMapView();
    }
  }

  // ==========================================
  // --- 1. EXPLORATION PHONE CAMERA AR VIEW ---
  // ==========================================
  Widget _buildMapView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: _onTapCamera,
        child: Stack(
          children: [
            // 1. Live Apple Orchard Camera View (First-person perspective)
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=1200&q=80',
                fit: BoxFit.cover,
              ),
            ),

            // 2. Camera Viewfinder Rule-of-Thirds Grid Overlay (Toggleable)
            if (_showGrid)
              Positioned.fill(
                child: CustomPaint(
                  painter: _CameraGridPainter(),
                ),
              ),

            // 3. Subtle Vignette Gradient for Contrast
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.0, 0.18, 0.70, 1.0],
                  ),
                ),
              ),
            ),

            // 4. Central AR Viewfinder Brackets & Focus Crosshair
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF00E676).withValues(alpha: 0.28),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      // Corner brackets
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFF00E676), width: 2.5),
                              left: BorderSide(color: Color(0xFF00E676), width: 2.5),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFF00E676), width: 2.5),
                              right: BorderSide(color: Color(0xFF00E676), width: 2.5),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFF00E676), width: 2.5),
                              left: BorderSide(color: Color(0xFF00E676), width: 2.5),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFF00E676), width: 2.5),
                              right: BorderSide(color: Color(0xFF00E676), width: 2.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 5. Floating AR Creature (Gembrod) in Camera Space
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Target Locked HUD Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00E676), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E676).withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.track_changes_rounded, color: Color(0xFF00E676), size: 14),
                        SizedBox(width: 6),
                        Text(
                          'TERKUNCI: GEMBROD (RARE)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '• 8.2m',
                          style: TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Floating Monster with Interactive Capture Tap
                  GestureDetector(
                    onTap: _triggerShutterCapture,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Pulsing Ring
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00E676).withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                        ),
                        // Inner Ring
                        Container(
                          width: 115,
                          height: 115,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF34D399).withValues(alpha: 0.8),
                              width: 1.5,
                            ),
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          ),
                        ),
                        // Creature Avatar
                        Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                            border: Border.all(color: const Color(0xFF00E676), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E676).withValues(alpha: 0.5),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('🍏👾', style: TextStyle(fontSize: 42)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Distance / Elevation Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Tap Apelmon atau tekan tombol Rana',
                      style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // 6. Tap-to-Focus Indicator (Yellow/Green Box wherever user taps)
            if (_focusPoint != null)
              Positioned(
                left: _focusPoint!.dx - 35,
                top: _focusPoint!.dy - 35,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFACC15), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFACC15),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

            // 7. Top Navigation Bar (Notch & Punch-Hole Safe!)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Column(
                  children: [
                    // Status bar: 9:41, wifi, battery
                    _buildStatusBarHeader(),
                    const SizedBox(height: 8),

                    // Top Bar Row: Left and Right only. Center is intentionally EMPTY to avoid phone camera hole!
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Back button + LIVE AR Tag
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24, width: 0.8),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white24, width: 0.8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.fiber_manual_record_rounded, color: Color(0xFFEF4444), size: 10),
                                  SizedBox(width: 5),
                                  Text(
                                    'AR LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '60 FPS',
                                    style: TextStyle(color: Colors.white60, fontSize: 9),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Center: Empty Spacer (Ensures front camera punch hole / notch never covers UI!)
                        const Spacer(),

                        // Right: Camera Controls (Flash, Grid, Settings)
                        Row(
                          children: [
                            // Flash Toggle
                            InkWell(
                              onTap: () {
                                setState(() => _flashOn = !_flashOn);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_flashOn ? 'Flash Kamera Aktif' : 'Flash Kamera Mati'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _flashOn
                                      ? const Color(0xFFFACC15).withValues(alpha: 0.3)
                                      : Colors.black.withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _flashOn ? const Color(0xFFFACC15) : Colors.white24,
                                    width: 0.8,
                                  ),
                                ),
                                child: Icon(
                                  _flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                                  size: 16,
                                  color: _flashOn ? const Color(0xFFFACC15) : Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Grid Toggle
                            InkWell(
                              onTap: () => setState(() => _showGrid = !_showGrid),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _showGrid
                                      ? const Color(0xFF00E676).withValues(alpha: 0.25)
                                      : Colors.black.withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _showGrid ? const Color(0xFF00E676) : Colors.white24,
                                    width: 0.8,
                                  ),
                                ),
                                child: Icon(
                                  _showGrid ? Icons.grid_on_rounded : Icons.grid_off_rounded,
                                  size: 16,
                                  color: _showGrid ? const Color(0xFF00E676) : Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Settings / Quick Menu
                            InkWell(
                              onTap: () => setState(() => _currentView = 3),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24, width: 0.8),
                                ),
                                child: const Icon(Icons.settings_outlined, size: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Floating Stats Chips (Safely away from camera notch!)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Level & XP Chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24, width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('⭐', style: TextStyle(fontSize: 11)),
                              const SizedBox(width: 5),
                              Text(
                                'LVL 12 • $_xp XP',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right: Collection Progress Chip
                        InkWell(
                          onTap: () => setState(() => _currentView = 3),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.5), width: 0.8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🍎', style: TextStyle(fontSize: 11)),
                                const SizedBox(width: 5),
                                Text(
                                  'Koleksi: ${_inventory.length + (_gembrodCaught ? 1 : 0)}/50',
                                  style: const TextStyle(
                                    color: Color(0xFF34D399),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 8. Bottom Camera HUD & Shutter Controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Subtle Radar Tip Toast (Glassmorphism)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12, width: 0.8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.radar_rounded, color: Color(0xFF00E676), size: 14),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Apelmon langka terdeteksi di kebun apel Batu!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Camera Modes Selector Strip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCameraModeLabel('FOTO', active: false, onTap: null),
                      const SizedBox(width: 20),
                      _buildCameraModeLabel('AR SCAN', active: true, onTap: null),
                      const SizedBox(width: 20),
                      _buildCameraModeLabel('TAS', active: false, onTap: () => setState(() => _currentView = 3)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Phone Camera Shutter Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Bag / Inventory Quick Shortcut
                        InkWell(
                          onTap: () => setState(() => _currentView = 3),
                          borderRadius: BorderRadius.circular(26),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white38, width: 1.5),
                                ),
                                child: const Icon(Icons.backpack_outlined, color: Colors.white, size: 22),
                              ),
                              Positioned(
                                top: -2,
                                right: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00E676),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${_inventory.length + (_gembrodCaught ? 1 : 0)}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Center: Big Smartphone Camera Shutter Button
                        GestureDetector(
                          onTap: _triggerShutterCapture,
                          child: Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00E676).withValues(alpha: 0.4),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 62,
                                height: 62,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00E676),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.track_changes_rounded,
                                  color: Color(0xFF064E3B),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Right: Trophy / Rewards Quick Shortcut
                        InkWell(
                          onTap: () => setState(() => _currentView = 3),
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white38, width: 1.5),
                            ),
                            child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFFACC15), size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 9. Camera Shutter Flash Effect (Flashes white when button is pressed)
            if (_isShutterFlashing)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),

            // 10. Catching In-Progress Overlay
            if (_isCatching)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF00E676), strokeWidth: 3),
                        SizedBox(height: 16),
                        Text(
                          'Menangkap Gembrod...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraModeLabel(String label, {required bool active, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFF00E676) : Colors.white60,
              fontSize: 12,
              fontWeight: active ? FontWeight.w900 : FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          if (active) ...[
            const SizedBox(height: 3),
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFF00E676),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // --- 2. CATCH MINI-GAME VIEW (IMAGE 4) ---
  // ==========================================
  Widget _buildCatchView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Orchard Camera View
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=1200&q=80',
              fit: BoxFit.cover,
            ),
          ),

          // Top Energy Bar & Combo
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => setState(() => _currentView = 0),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF065F46),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'KOMBO x12!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Energy Pill
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '⚡ Energi',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '85%',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.85,
                              backgroundColor: Color(0xFFE5E7EB),
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // "Apelmon Langka Muncul!"
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars_rounded, color: Color(0xFF059669), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Apelmon Langka Muncul!',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Center Capture Reticle & Gembrod Monster
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Concentric Animated Target Rings
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.7), width: 3),
                  ),
                ),
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF34D399), width: 2),
                  ),
                ),
                // Gembrod Creature
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1618160702438-9b02ab6515c9?auto=format&fit=crop&w=400&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.6), blurRadius: 20),
                    ],
                  ),
                  child: const Center(
                    child: Text('🍏👾', style: TextStyle(fontSize: 58)),
                  ),
                ),
              ],
            ),
          ),

          // Catching In-Progress Overlay
          if (_isCatching)
            Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF00E676)),
                    SizedBox(height: 16),
                    Text(
                      'Menangkap Gembrod...',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

          // Tip Bubble
          Positioned(
            left: 20,
            right: 20,
            bottom: 110,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
                ],
              ),
              child: const Row(
                children: [
                  Text('🍏✨', style: TextStyle(fontSize: 26)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '"Tahan lingkaran hingga hijau untuk tangkapan Sempurna!"',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Big Catch Button: TANGKAP GEMBROD
          Positioned(
            left: 20,
            right: 20,
            bottom: 28,
            child: ElevatedButton.icon(
              onPressed: _isCatching ? null : _catchGembrod,
              icon: const Icon(Icons.track_changes_rounded, color: Color(0xFF111827), size: 24),
              label: const Text(
                'TANGKAP GEMBROD',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                foregroundColor: Colors.black,
                elevation: 6,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _catchGembrod() {
    setState(() => _isCatching = true);
    Timer(const Duration(milliseconds: 1200), () {
      setState(() {
        _isCatching = false;
        _gembrodCaught = true;
        _xp += 150;
        _points += 20;
        _currentView = 2; // Open Success Screen
      });
    });
  }

  // ==========================================
  // --- 3. CATCH SUCCESS VIEW (IMAGE 1) ---
  // ==========================================
  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 20),
          onPressed: () => setState(() => _currentView = 0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Color(0xFF111827), size: 24),
            onPressed: () => setState(() => _currentView = 0),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            children: [
              const Text(
                'BERHASIL!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF059669),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kamu menangkap Apelmon baru!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 24),

              // Gembrod Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 18, offset: const Offset(0, 8)),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    // RARE Badge
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF97316),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 13),
                            SizedBox(width: 4),
                            Text(
                              'RARE',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Gembrod Image
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: const Color(0xFFDCFCE7),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 16),
                        ],
                      ),
                      child: const Center(
                        child: Text('🍏👾', style: TextStyle(fontSize: 70)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'GEMBROD',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tags
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTag('Manis'),
                        const SizedBox(width: 8),
                        _buildTag('Hijau'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Rewards Stats Row (XP & Koin)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.bolt_rounded, color: Color(0xFF059669), size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      '+150 XP',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF065F46),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pengalaman',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF047857)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.payments_rounded, color: Color(0xFFD97706), size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      '+20 Koin',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF92400E),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Koin LIKA',
                                  style: TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Button: Simpan ke Tas
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _currentView = 3); // Go to inventory!
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text(
                          'Simpan ke Tas',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Button: Bagikan
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tangkapan berhasil dibagikan!')),
                          );
                        },
                        icon: const Icon(Icons.share_outlined, color: Color(0xFF15803D), size: 18),
                        label: const Text(
                          'Bagikan',
                          style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF15803D), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
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

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4B5563)),
      ),
    );
  }

  // ==========================================
  // --- 4. INVENTORY & VOUCHER VIEW (IMAGE 2) ---
  // ==========================================
  Widget _buildInventoryView() {
    final allItems = [..._inventory];
    if (_gembrodCaught) {
      allItems.add({
        'name': 'GEMBROD',
        'desc': 'Apel Hijau Langka',
        'image': 'https://images.unsplash.com/photo-1618160702438-9b02ab6515c9?auto=format&fit=crop&w=400&q=80',
        'color': const Color(0xFF10B981),
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 20),
          onPressed: () => setState(() => _currentView = 0),
        ),
        title: const Text(
          'Inventaris Kamu',
          style: TextStyle(color: Color(0xFF065F46), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFACC15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.black87, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$_points Poin',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${allItems.length} / 12 Apelmon Terkoleksi',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: allItems.length / 12,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 20),

            // 2x2 Grid of Apelmon
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                if (index < allItems.length) {
                  final item = allItems[index];
                  return _buildApelmonCard(item);
                }
                // Locked Slot
                return _buildLockedSlot();
              },
            ),
            const SizedBox(height: 26),

            // Tukar Hadiah Section
            const Text(
              'Tukar Hadiah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 14),

            // Voucher 1: 20%
            _buildVoucherCard(
              discount: '20%',
              discountColor: const Color(0xFF059669),
              title: 'Kebun Apel Batu',
              subtitle: 'Diskon untuk semua Jus Segar',
              pointsCost: 500,
            ),
            const SizedBox(height: 12),

            // Voucher 2: 15rb
            _buildVoucherCard(
              discount: '15rb',
              discountColor: const Color(0xFFD97706),
              title: 'Omah Apel Batu',
              subtitle: 'Potongan setiap beli Keripik Apel',
              pointsCost: 800,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildApelmonCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              item['image'] as String,
              height: 85,
              width: 85,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 85,
                width: 85,
                color: const Color(0xFFDCFCE7),
                child: const Center(child: Text('🍎', style: TextStyle(fontSize: 32))),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['name'] as String,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
          Text(
            item['desc'] as String,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Apelmon ${item['name']} aktif menemani petualanganmu!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5E7EB),
                foregroundColor: const Color(0xFF065F46),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.zero,
              ),
              child: const Text('Detail', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedSlot() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 28),
          SizedBox(height: 8),
          Text(
            'Jelajahi Batu lebih jauh untuk membuka!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard({
    required String discount,
    required Color discountColor,
    required String title,
    required String subtitle,
    required int pointsCost,
  }) {
    final canRedeem = _points >= pointsCost;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Left Ticket Tag
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: discountColor,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 20),
                const SizedBox(height: 2),
                Text(
                  discount,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pointsCost Pts',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                ),
              ],
            ),
          ),
          // Redeem Button
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: canRedeem
                  ? () {
                      setState(() => _points -= pointsCost);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Voucher $title berhasil ditukar!')),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canRedeem ? const Color(0xFF047857) : Colors.grey.shade300,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: const Size(0, 32),
              ),
              child: const Text('Tukar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapCamera(TapDownDetails details) {
    setState(() {
      _focusPoint = details.localPosition;
    });
    _focusTimer?.cancel();
    _focusTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _focusPoint = null);
    });
  }

  void _triggerShutterCapture() {
    if (_isCatching) return;
    setState(() {
      _isShutterFlashing = true;
      _isCatching = true;
    });

    Timer(const Duration(milliseconds: 140), () {
      if (mounted) setState(() => _isShutterFlashing = false);
    });

    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isCatching = false;
        _gembrodCaught = true;
        _xp += 150;
        _points += 20;
        _currentView = 2; // Open Success Screen
      });
    });
  }

  Widget _buildStatusBarHeader() {
    return const AdaptiveStatusBar(
      contentColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    super.dispose();
  }
}

class _CameraGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 1.0;

    final double colWidth = size.width / 3;
    canvas.drawLine(Offset(colWidth, 0), Offset(colWidth, size.height), paint);
    canvas.drawLine(Offset(colWidth * 2, 0), Offset(colWidth * 2, size.height), paint);

    final double rowHeight = size.height / 3;
    canvas.drawLine(Offset(0, rowHeight), Offset(size.width, rowHeight), paint);
    canvas.drawLine(Offset(0, rowHeight * 2), Offset(size.width, rowHeight * 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
