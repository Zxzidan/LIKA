import 'package:flutter/material.dart';
import '../services/adaptive_device.dart';
import '../services/order_state.dart';

class TrackingScreen extends StatefulWidget {
  final String? orderCode;
  final String? productName;
  final String? destination;
  final String driverName;
  final int? totalPrice;
  final int? quantity;

  const TrackingScreen({
    super.key,
    this.orderCode,
    this.productName,
    this.destination,
    this.driverName = 'Cak Yo',
    this.totalPrice,
    this.quantity,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  bool _isReceived = false;
  late final AnimationController _driverAnimController;
  late final Animation<double> _driverProgress;

  @override
  void initState() {
    super.initState();
    _driverAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _driverProgress = Tween<double>(begin: 0.45, end: 0.72).animate(
      CurvedAnimation(parent: _driverAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _driverAnimController.dispose();
    super.dispose();
  }

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final formatted = str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    // Fallback to latest active order if not explicitly provided
    final orders = OrderState.instance.orders;
    final activeOrder = orders.isNotEmpty ? orders.first : null;

    final resolvedOrderCode =
        widget.orderCode ?? activeOrder?.orderId ?? '#FH341391';
    final resolvedProduct =
        widget.productName ?? activeOrder?.productName ?? 'Apel Cak Ka';
    final resolvedDestination = widget.destination ??
        (activeOrder != null
            ? '${activeOrder.customerAddress}, ${activeOrder.customerCity}'
            : 'Jl. Raya Trawas No. 45, Mojokerto');
    final resolvedTotal =
        widget.totalPrice ?? activeOrder?.totalPrice ?? 315000;
    final resolvedQty = widget.quantity ?? activeOrder?.quantity ?? 10;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4EC),
      body: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            // Responsive map anchor points in the upper visible map area (above bottom sheet)
            final mapTop = 105.0;
            final mapBottom = (h * 0.50).clamp(240.0, h - 310.0);
            final origin = Offset(w * 0.24, mapTop + (mapBottom - mapTop) * 0.18);
            final midPoint = Offset(w * 0.48, mapTop + (mapBottom - mapTop) * 0.52);
            final dest = Offset(w * 0.76, mapTop + (mapBottom - mapTop) * 0.78);

            return Stack(
              children: [
                // 1. Full Screen Vector Road & Agro Map Background
                Positioned.fill(
                  child: CustomPaint(
                    painter: _AgroStreetMapPainter(),
                  ),
                ),

                // 2. Delivery Route Path
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TrackingRoutePainter(
                      origin: origin,
                      midPoint: midPoint,
                      destination: dest,
                    ),
                  ),
                ),

                // 3. Orchard Origin Pin
                Positioned(
                  left: (origin.dx - 54).clamp(8.0, w - 120),
                  top: (origin.dy - 54).clamp(72.0, mapBottom - 60),
                  child: _buildLocationPin(
                    label: 'Kebun LIKA\n(Kota Batu)',
                    icon: Icons.park_rounded,
                    color: const Color(0xFF15803D),
                  ),
                ),

                // 4. Destination Customer Pin
                Positioned(
                  left: (dest.dx - 52).clamp(8.0, w - 120),
                  top: (dest.dy - 56).clamp(80.0, mapBottom - 56),
                  child: _buildLocationPin(
                    label: 'Tujuan Anda',
                    icon: Icons.home_rounded,
                    color: const Color(0xFFDC2626),
                  ),
                ),

                // 5. Animated Moving Driver Motorbike Pin
                AnimatedBuilder(
                  animation: _driverProgress,
                  builder: (context, child) {
                    final t = _driverProgress.value;
                    final driverPos = _evalBezier(origin, midPoint, dest, t);
                    return Positioned(
                      left: (driverPos.dx - 64).clamp(8.0, w - 135),
                      top: (driverPos.dy - 48).clamp(75.0, mapBottom - 50),
                      child: child!,
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14532D),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '🛵 ${widget.driverName} (Driver LIKA)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E676)
                                  .withValues(alpha: 0.55),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.two_wheeler_rounded,
                          color: Color(0xFF064E3B),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                // 6. Top Adaptive Status Bar + Header
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 6.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AdaptiveStatusBar(contentColor: Color(0xFF111827)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 18,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 9),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.near_me_rounded,
                                          color: Color(0xFF16A34A), size: 16),
                                      SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          'Lacak Pengiriman Langsung',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF111827),
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                ),

                // 7. Bottom Sliding Delivery Details Card
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 16,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: h * 0.50,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.16),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Handle
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
                            const SizedBox(height: 10),

                            // Order Header & Status Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'STATUS ORDER',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF6B7280),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$resolvedOrderCode • $resolvedProduct',
                                        style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF111827)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _isReceived
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFFFEDD5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _isReceived
                                        ? '✓ Pesanan Selesai'
                                        : '🕒 Sedang Dikirim',
                                    style: TextStyle(
                                      color: _isReceived
                                          ? const Color(0xFF15803D)
                                          : const Color(0xFFEA580C),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Driver Info Card
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 19,
                                    backgroundColor: Color(0xFFDCFCE7),
                                    child: Text('👨‍✈️',
                                        style: TextStyle(fontSize: 18)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.driverName,
                                          style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF111827)),
                                        ),
                                        const Text(
                                          'Kurir LIKA • Estimasi tiba 15 menit',
                                          style: TextStyle(
                                              fontSize: 10.5,
                                              color: Color(0xFF6B7280)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Menghubungi ${widget.driverName}...'),
                                          backgroundColor:
                                              const Color(0xFF15803D),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                        Icons.phone_in_talk_rounded,
                                        color: Color(0xFF15803D),
                                        size: 21),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Summary: Total Belanja & Jumlah
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Total Belanja',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF6B7280))),
                                        const SizedBox(height: 2),
                                        Text(
                                          _formatRupiah(resolvedTotal),
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF111827)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Jumlah Item',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF6B7280))),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$resolvedQty items',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF111827)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Address info
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    color: Color(0xFF15803D), size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    resolvedDestination,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF4B5563),
                                        fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Button: Konfirmasi Penerimaan
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isReceived
                                    ? null
                                    : () async {
                                        setState(() => _isReceived = true);
                                        await OrderState.instance
                                            .completeOrder(resolvedOrderCode);
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Terima kasih! Pesanan Anda telah diterima.'),
                                            backgroundColor: Color(0xFF15803D),
                                          ),
                                        );
                                        await Future.delayed(
                                            const Duration(milliseconds: 700));
                                        if (context.mounted) {
                                          Navigator.of(context).maybePop();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isReceived
                                      ? Colors.grey.shade400
                                      : const Color(0xFF00C853),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  _isReceived
                                      ? 'Sudah Diterima'
                                      : 'Konfirmasi Penerimaan',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Offset _evalBezier(Offset p0, Offset p1, Offset p2, double t) {
    final u = 1 - t;
    return Offset(
      u * u * p0.dx + 2 * u * t * p1.dx + t * t * p2.dx,
      u * u * p0.dy + 2 * u * t * p1.dy + t * t * p2.dy,
    );
  }

  Widget _buildLocationPin({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
      ],
    );
  }
}

/// Custom vector street & orchard map background (never fails offline / never shows world map)
class _AgroStreetMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Base map land
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFFECEFE9),
    );

    // Green orchard & park blocks
    final greenZone = Paint()..color = const Color(0xFFD5F0DA);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.05, h * 0.08, w * 0.42, h * 0.22),
          const Radius.circular(18)),
      greenZone,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.56, h * 0.16, w * 0.38, h * 0.18),
          const Radius.circular(16)),
      greenZone,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.08, h * 0.36, w * 0.28, h * 0.20),
          const Radius.circular(14)),
      greenZone,
    );

    // Subtle river stream
    final riverPaint = Paint()
      ..color = const Color(0xFFBFDBFE)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final river = Path()
      ..moveTo(0, h * 0.28)
      ..quadraticBezierTo(w * 0.45, h * 0.22, w, h * 0.34);
    canvas.drawPath(river, riverPaint);

    // Secondary white local roads
    final minorRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final yFrac in [0.16, 0.32, 0.44]) {
      canvas.drawLine(
        Offset(0, h * yFrac),
        Offset(w, h * (yFrac + 0.04)),
        minorRoad,
      );
    }
    for (final xFrac in [0.18, 0.45, 0.72]) {
      canvas.drawLine(
        Offset(w * xFrac, 0),
        Offset(w * (xFrac + 0.06), h),
        minorRoad,
      );
    }

    // Main yellow-cream highway
    final majorBorder = Paint()
      ..color = const Color(0xFFE5C158)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final majorFill = Paint()
      ..color = const Color(0xFFFEF3C7)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final highway = Path()
      ..moveTo(0, h * 0.14)
      ..quadraticBezierTo(w * 0.5, h * 0.26, w, h * 0.42);
    canvas.drawPath(highway, majorBorder);
    canvas.drawPath(highway, majorFill);

    // Map street labels
    _drawLabel(canvas, 'Kota Batu', Offset(w * 0.10, h * 0.13));
    _drawLabel(canvas, 'Jl. Raya Trawas', Offset(w * 0.56, h * 0.24));
    _drawLabel(canvas, 'Jl. Ijen, Malang', Offset(w * 0.58, h * 0.42));
  }

  void _drawLabel(Canvas canvas, String text, Offset offset) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrackingRoutePainter extends CustomPainter {
  final Offset origin;
  final Offset midPoint;
  final Offset destination;

  _TrackingRoutePainter({
    required this.origin,
    required this.midPoint,
    required this.destination,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final routeShadow = Paint()
      ..color = const Color(0xFF14532D).withValues(alpha: 0.25)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..color = const Color(0xFF16A34A)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(origin.dx, origin.dy)
      ..quadraticBezierTo(midPoint.dx, midPoint.dy, destination.dx, destination.dy);

    canvas.drawPath(path, routeShadow);
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant _TrackingRoutePainter oldDelegate) {
    return oldDelegate.origin != origin ||
        oldDelegate.midPoint != midPoint ||
        oldDelegate.destination != destination;
  }
}
