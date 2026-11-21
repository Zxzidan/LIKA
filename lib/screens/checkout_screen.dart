import 'package:flutter/material.dart';
import '../services/order_state.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final int quantity;
  final int totalPrice;
  final VoidCallback onOrderSuccess;

  const CheckoutScreen({
    super.key,
    required this.product,
    required this.quantity,
    required this.totalPrice,
    required this.onOrderSuccess,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Tunai';
  final String _orderId = '#FH341391';

  @override
  Widget build(BuildContext context) {
    final itemTotal = widget.totalPrice;
    final adminFee = (itemTotal * 0.05).round();
    final grandTotal = itemTotal + adminFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pembayaran',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Cek Detail Pesanan',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Item Dipilih
            const Text(
              'Item Dipilih',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    widget.product['image'] as String,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
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
                        widget.product['title'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'IDR ${_formatNumber(widget.totalPrice)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${widget.quantity} items',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Detail Transaksi
            const Text(
              'Detail Transaksi :',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            _buildRowText(widget.product['title'] as String, 'IDR ${_formatNumber(itemTotal)}'),
            const SizedBox(height: 8),
            _buildRowText('Admin 5%', 'IDR ${_formatNumber(adminFee)}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Harga',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
                Text(
                  'IDR ${_formatNumber(grandTotal)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BFA5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 3. Detail Pemesan
            const Text(
              'Detail Pemesan :',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            _buildRowText('Nama', 'Ansellma Putri'),
            const SizedBox(height: 8),
            _buildRowText('No Telepon', '0813 1903 0599'),
            const SizedBox(height: 8),
            _buildRowText('Alamat', 'Pulau Jeju blok A no 56'),
            const SizedBox(height: 8),
            _buildRowText('Kota', 'Jeju'),
            const SizedBox(height: 32),

            // 4. Metode Pembayaran Selector
            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _openPaymentMethodSelection,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
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
                    _getPaymentIcon(_selectedPaymentMethod),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedPaymentMethod,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    Text(
                      'IDR ${_formatNumber(grandTotal)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00BFA5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 5. Button: Bayar Sekarang
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handlePayment(grandTotal, adminFee),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowText(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _getPaymentIcon(String method) {
    if (method.contains('Dana')) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFF0284C7),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text('D', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      );
    }
    if (method.contains('Bank')) {
      return const Icon(Icons.credit_card_rounded, color: Color(0xFF1E40AF), size: 22);
    }
    return const Icon(Icons.payments_outlined, color: Color(0xFF059669), size: 22);
  }

  void _openPaymentMethodSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodPickerScreen(
          selectedMethod: _selectedPaymentMethod,
          onSelect: (method) {
            setState(() {
              _selectedPaymentMethod = method;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _handlePayment(int grandTotal, int adminFee) {
    // 1. Simpan pesanan ke dalam OrderState
    final newOrder = OrderItem(
      orderId: _orderId,
      productName: widget.product['title'] as String,
      quantity: widget.quantity,
      itemPrice: widget.totalPrice,
      adminFee: adminFee,
      totalPrice: grandTotal,
      customerName: 'Ansellma Putri',
      customerPhone: '0813 1903 0599',
      customerAddress: 'Pulau Jeju blok A no 56',
      customerCity: 'Jeju',
      paymentMethod: _selectedPaymentMethod,
      status: 'Paid',
    );

    OrderState.instance.addOrder(newOrder);

    // 2. Buka Success Screen "Yeay! Pesananmu telah terselesaikan"
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          onGoToOrders: () {
            Navigator.of(context).pop(); // Tutup success screen
            widget.onOrderSuccess(); // Pindah ke tab Pesanan!
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

// ==========================================
// --- SCREEN PILIH METODE PEMBAYARAN ---
// ==========================================
class PaymentMethodPickerScreen extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onSelect;

  const PaymentMethodPickerScreen({
    super.key,
    required this.selectedMethod,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pembayaran',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Cek Detail Pesanan',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tunai
            _buildOptionCard(
              title: 'Tunai',
              iconWidget: const Icon(Icons.payments_outlined, color: Colors.black87, size: 24),
              onTap: () => onSelect('Tunai'),
            ),
            const SizedBox(height: 14),

            // Dana
            _buildOptionCard(
              title: 'Dana',
              iconWidget: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF0284C7),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('D', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
              onTap: () => onSelect('Dana'),
            ),
            const SizedBox(height: 24),

            // Section Header: Credit/Debit Card
            const Row(
              children: [
                Icon(Icons.credit_card_rounded, color: Colors.black87, size: 20),
                SizedBox(width: 10),
                Text(
                  'Credit/Debit Card',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Bank Cards
            _buildBankCard('Bank BRI **** 8917', 'BRI', const Color(0xFF00529C)),
            const SizedBox(height: 12),
            _buildBankCard('Bank BNI **** 1903', 'BNI', const Color(0xFFF15A24)),
            const SizedBox(height: 12),
            _buildBankCard('Bank BCA **** 0923', 'BCA', const Color(0xFF003D79)),
            const SizedBox(height: 12),
            _buildBankCard('Bank BTN **** 0923', 'BTN', const Color(0xFFEAB308)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCard(String title, String bankName, Color bankColor) {
    return InkWell(
      onTap: () => onSelect(title),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: bankColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                bankName,
                style: TextStyle(
                  color: bankColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// --- SCREEN SUCCESS "YEAY! PESANANMU TELAH TERSELESAIKAN" ---
// ==========================================
class PaymentSuccessScreen extends StatelessWidget {
  final VoidCallback onGoToOrders;

  const PaymentSuccessScreen({super.key, required this.onGoToOrders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Illustration
              Container(
                width: 260,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text('🎉👩‍🍳🍲', style: TextStyle(fontSize: 64)),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Yeay! Pesananmu telah\nterselesaikan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Sekarang Anda dapat menikmati komoditas unggulan dari daerah kami\nSelamat Menikmati!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Button Cari Komoditas / Masuk ke Pesanan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onGoToOrders,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Lihat di Pesanan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
