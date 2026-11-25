// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding_screen.dart';
import 'tracking_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;
  final Function(int)? onNavigateToTab;

  const ProfileScreen({
    super.key,
    this.showBackButton = true,
    this.onNavigateToTab,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User Profile Data
  String _userName = 'Dandi Azaidane';
  String _userHandle = 'dandizidan';
  String _userEmail = 'dandiazaidanedummy@gmail.com';
  String _userPhone = '0813 1903 0599';

  @override
  void initState() {
    super.initState();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
          _userName = user.displayName!.trim();
          _userHandle =
              user.displayName!.trim().toLowerCase().replaceAll(' ', '');
        }
        if (user.email != null && user.email!.trim().isNotEmpty) {
          _userEmail = user.email!.trim();
        }
      }
    } catch (_) {}
  }
  String _userBio = 'Pencinta buah apel segar Batu & penikmat agrowisata lokal.';
  String _userAvatar =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80';

  // Financial & Loyalty Data
  int _walletBalance = 250000;
  int _harvestPoints = 1450;
  int _couponCount = 4;

  // Settings State
  bool _darkMode = false;
  String _selectedLanguage = 'Bahasa Indonesia';
  bool _soundHapticEnabled = true;

  // Notification Preferences
  bool _notifPromo = true;
  bool _notifOrders = true;
  bool _notifHarvest = true;
  bool _notifEmail = false;

  // Security Preferences
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;

  // Address List
  final List<Map<String, dynamic>> _addressList = [
    {
      'label': 'Rumah (Utama)',
      'recipient': 'Dandi Azaidane',
      'phone': '0813 1903 0599',
      'address': 'Jl. Raya Trawas No. 45, Mojokerto, Jawa Timur 61375',
      'isPrimary': true,
    },
    {
      'label': 'Kantor / Kebun',
      'recipient': 'Dandi (Agro Team)',
      'phone': '0813 1903 0599',
      'address': 'Jl. Suropati No. 12, Pesanggrahan, Kec. Batu, Kota Batu 65313',
      'isPrimary': false,
    },
  ];

  // Available Coupons
  final List<Map<String, String>> _coupons = [
    {
      'code': 'PANENRAYA20',
      'title': 'Diskon 20% Paket Wisata Kebun Apel',
      'discount': 'Diskon 20%',
      'minOrder': 'Min. transaksi Rp 50.000',
      'expiry': 'Berlaku s/d 30 Des 2026',
    },
    {
      'code': 'ONGKIRGRATIS',
      'title': 'Gratis Ongkir Buah Segar Se-Jatim',
      'discount': 'Potongan Rp 15.000',
      'minOrder': 'Min. belanja Rp 30.000',
      'expiry': 'Berlaku s/d 15 Jan 2027',
    },
    {
      'code': 'CAKKAFLASH',
      'title': 'Cashback Rp 15.000 Belanja Komoditas',
      'discount': 'Cashback Rp 15.000',
      'minOrder': 'Khusus petik apel & sayur',
      'expiry': 'Berlaku s/d 31 Des 2026',
    },
    {
      'code': 'AGROWELCOME',
      'title': 'Potongan Rp 10.000 Wisata Pertama',
      'discount': 'Potongan Rp 10.000',
      'minOrder': 'Semua wahana mitra',
      'expiry': 'Berlaku s/d 28 Feb 2027',
    },
  ];

  // Favorites List
  final List<Map<String, dynamic>> _favorites = [
    {
      'title': 'Paket Petik Apel Cak Ka',
      'type': 'Agrowisata',
      'rating': '4.8 (1.2k)',
      'price': 'Rp 25.000 / orang',
      'image': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=400&q=80',
    },
    {
      'title': 'Apel Manalagi Super Grade A (1 kg)',
      'type': 'Komoditas',
      'rating': '4.9 (840)',
      'price': 'Rp 22.000',
      'image': 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?auto=format&fit=crop&w=400&q=80',
    },
    {
      'title': 'Wisata Edukasi Kebun Jeruk Batu',
      'type': 'Agrowisata',
      'rating': '4.7 (520)',
      'price': 'Rp 35.000 / orang',
      'image': 'https://images.unsplash.com/photo-1557800636-894a64c1696f?auto=format&fit=crop&w=400&q=80',
    },
  ];

  // Avatar Options
  final List<String> _avatarPresets = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=300&q=80',
  ];

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

  void _showToast(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? const Color(0xFF15803D) : const Color(0xFF374151),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1F2937), size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1F2937)),
            onPressed: _showGeneralSettingsSheet,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Column(
          children: [
            // 1. Profile Card (Avatar + User Info)
            _buildProfileCard(),
            const SizedBox(height: 18),

            // 2. Agro Wallet / Points Summary
            _buildWalletSummaryCard(),
            const SizedBox(height: 22),

            // 3. Section: Akun & Transaksi
            _buildSectionTitle('Akun & Aktivitas'),
            const SizedBox(height: 10),
            _buildMenuCard([
              _MenuItem(
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFF0284C7),
                bgColor: const Color(0xFFE0F2FE),
                title: 'Ubah Profil',
                subtitle: 'Nama, email, dan nomor telepon',
                onTap: _showEditProfileSheet,
              ),
              _MenuItem(
                icon: Icons.location_on_outlined,
                iconColor: const Color(0xFFEA580C),
                bgColor: const Color(0xFFFFEDD5),
                title: 'Alamat Tersimpan',
                subtitle: _addressList.isNotEmpty ? _addressList.first['address'] as String : 'Belum ada alamat',
                onTap: _showAddressManagementSheet,
              ),
              _MenuItem(
                icon: Icons.receipt_long_outlined,
                iconColor: const Color(0xFF15803D),
                bgColor: const Color(0xFFDCFCE7),
                title: 'Riwayat Pesanan',
                subtitle: 'Cek transaksi buah dan tiket wisata',
                badgeText: '1 Aktif',
                onTap: _showOrdersHistorySheet,
              ),
              _MenuItem(
                icon: Icons.favorite_border_rounded,
                iconColor: const Color(0xFFDB2777),
                bgColor: const Color(0xFFFCE7F3),
                title: 'Favorit & Wishlist',
                subtitle: '${_favorites.length} kebun & komoditas disukai',
                onTap: _showFavoritesSheet,
              ),
            ]),
            const SizedBox(height: 22),

            // 4. Section: Pengaturan & Keamanan
            _buildSectionTitle('Pengaturan & Keamanan'),
            const SizedBox(height: 10),
            _buildMenuCard([
              _MenuItem(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF7C3AED),
                bgColor: const Color(0xFFEDE9FE),
                title: 'Keamanan Akun',
                subtitle: 'PIN AgroPay, sandi, & biometrik',
                onTap: _showSecuritySheet,
              ),
              _MenuItem(
                icon: Icons.notifications_none_rounded,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFEF3C7),
                title: 'Notifikasi',
                subtitle: 'Promo panen, update pengiriman',
                onTap: _showNotificationPreferencesSheet,
              ),
              _MenuItem(
                icon: Icons.headset_mic_outlined,
                iconColor: const Color(0xFF0D9488),
                bgColor: const Color(0xFFCCFBF1),
                title: 'Pusat Bantuan',
                subtitle: 'Hubungi CS Agro & FAQ',
                onTap: _showHelpCenterSheet,
              ),
            ]),
            const SizedBox(height: 24),

            // 5. Logout Button
            _buildLogoutButton(context),
            const SizedBox(height: 16),

            // App Version
            const Text(
              'Agro App v1.0.0 • poject_lika',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 1. PROFILE CARD
  // =========================================================================
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          // Avatar with Camera Edit Badge
          GestureDetector(
            onTap: _showAvatarPickerSheet,
            child: Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF16A34A), width: 2.5),
                    image: DecorationImage(
                      image: NetworkImage(_userAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF15803D),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Mitra',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '@$_userHandle',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userEmail,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Edit quick button
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF15803D), size: 24),
            tooltip: 'Ubah Profil',
            onPressed: _showEditProfileSheet,
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 2. WALLET SUMMARY CARD (AgroPay, Poin Panen, Kupon)
  // =========================================================================
  Widget _buildWalletSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF15803D), Color(0xFF16A34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF15803D).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Saldo AgroPay
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _showWalletTopUpSheet,
              child: _buildWalletItem(
                label: 'Saldo AgroPay',
                value: _formatRupiah(_walletBalance),
                icon: Icons.account_balance_wallet_rounded,
                subText: '+ Top Up',
              ),
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.25)),
          // Poin Panen
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _showPointsRedeemSheet,
              child: _buildWalletItem(
                label: 'Poin Panen',
                value: '$_harvestPoints Pts',
                icon: Icons.stars_rounded,
                subText: 'Tukar Hadiah',
              ),
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.25)),
          // Kupon Saya
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _showCouponsSheet,
              child: _buildWalletItem(
                label: 'Kupon Saya',
                value: '$_couponCount Voucher',
                icon: Icons.confirmation_number_rounded,
                subText: 'Gunakan',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletItem({
    required String label,
    required String value,
    required IconData icon,
    required String subText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              subText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 3. SECTION TITLE
  // =========================================================================
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF374151),
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // =========================================================================
  // 4. MENU CARD BUILDER
  // =========================================================================
  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 22),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                subtitle: Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.badgeText != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.badgeText!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 14,
                    ),
                  ],
                ),
                onTap: item.onTap,
              ),
              if (!isLast)
                const Divider(height: 1, indent: 68, endIndent: 16, color: Color(0xFFF3F4F6)),
            ],
          );
        }),
      ),
    );
  }

  // =========================================================================
  // 5. LOGOUT BUTTON
  // =========================================================================
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showLogoutConfirmationDialog,
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 18),
        label: const Text(
          'Keluar dari Akun',
          style: TextStyle(
            color: Color(0xFFDC2626),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.2),
          backgroundColor: const Color(0xFFFEF2F2),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // MODALS & ACTIONS IMPLEMENTATION
  // =========================================================================

  // --- A. TOP SETTINGS SHEET ---
  void _showGeneralSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  const Row(
                    children: [
                      Icon(Icons.settings_rounded, color: Color(0xFF15803D)),
                      SizedBox(width: 8),
                      Text(
                        'Pengaturan Umum',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Dark Mode Toggle
                  SwitchListTile(
                    title: const Text('Mode Gelap (Dark Mode)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Tampilan kontras nyaman untuk malam hari', style: TextStyle(fontSize: 12)),
                    activeColor: const Color(0xFF15803D),
                    value: _darkMode,
                    onChanged: (val) {
                      setModalState(() => _darkMode = val);
                      setState(() => _darkMode = val);
                      _showToast(_darkMode ? 'Mode Gelap diaktifkan' : 'Mode Terang diaktifkan');
                    },
                  ),
                  const Divider(),
                  // Sound & Haptic
                  SwitchListTile(
                    title: const Text('Efek Suara & Haptik', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Getaran saat tap tombol dan booking', style: TextStyle(fontSize: 12)),
                    activeColor: const Color(0xFF15803D),
                    value: _soundHapticEnabled,
                    onChanged: (val) {
                      setModalState(() => _soundHapticEnabled = val);
                      setState(() => _soundHapticEnabled = val);
                      _showToast(_soundHapticEnabled ? 'Suara & Haptik aktif' : 'Suara & Haptik nonaktif');
                    },
                  ),
                  const Divider(),
                  // Bahasa
                  ListTile(
                    title: const Text('Bahasa Aplikasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(_selectedLanguage, style: const TextStyle(fontSize: 12, color: Color(0xFF15803D))),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showLanguagePicker();
                    },
                  ),
                  const Divider(),
                  // Clear Cache
                  ListTile(
                    leading: const Icon(Icons.cleaning_services_rounded, color: Color(0xFFEA580C)),
                    title: const Text('Bersihkan Cache', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Bebaskan 14.8 MB ruang penyimpanan lokal', style: TextStyle(fontSize: 12)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showToast('Cache 14.8 MB berhasil dibersihkan!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF7ED),
                        foregroundColor: const Color(0xFFEA580C),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Hapus', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pilih Bahasa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Bahasa Indonesia'),
              value: 'Bahasa Indonesia',
              groupValue: _selectedLanguage,
              activeColor: const Color(0xFF15803D),
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(ctx);
                _showToast('Bahasa diubah ke Bahasa Indonesia');
              },
            ),
            RadioListTile<String>(
              title: const Text('English (US)'),
              value: 'English (US)',
              groupValue: _selectedLanguage,
              activeColor: const Color(0xFF15803D),
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(ctx);
                _showToast('Language changed to English (US)');
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- B. AVATAR PICKER SHEET ---
  void _showAvatarPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            const Text(
              'Ganti Foto Profil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih avatar agrowisata atau gunakan foto profil Anda',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 18),
            // Avatar Presets Grid
            SizedBox(
              height: 75,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _avatarPresets.length,
                separatorBuilder: (_, index) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final url = _avatarPresets[index];
                  final isSelected = _userAvatar == url;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _userAvatar = url);
                      Navigator.pop(ctx);
                      _showToast('Foto profil berhasil diperbarui!');
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF15803D) : const Color(0xFFE5E7EB),
                          width: isSelected ? 3 : 1.5,
                        ),
                        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                      ),
                      child: isSelected
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF15803D).withValues(alpha: 0.3),
                              ),
                              child: const Icon(Icons.check, color: Colors.white, size: 24),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showToast('Membuka Galeri Foto... Foto berhasil dipilih!');
                    },
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Buka Galeri'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF15803D),
                      side: const BorderSide(color: Color(0xFF15803D)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showToast('Membuka Kamera... Foto berhasil diambil!');
                    },
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Kamera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15803D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // --- C. WALLET TOP UP SHEET ---
  void _showWalletTopUpSheet() {
    int selectedAmount = 50000;
    String selectedMethod = 'QRIS';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF15803D)),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Top Up AgroPay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Saldo saat ini: ${_formatRupiah(_walletBalance)}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text('Pilih Nominal Top Up', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [20000, 50000, 100000, 200000, 500000].map((nominal) {
                        final isSel = selectedAmount == nominal;
                        return ChoiceChip(
                          label: Text(_formatRupiah(nominal)),
                          selected: isSel,
                          selectedColor: const Color(0xFF15803D),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : const Color(0xFF374151),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          backgroundColor: const Color(0xFFF3F4F6),
                          onSelected: (val) {
                            if (val) setModalState(() => selectedAmount = nominal);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    const Text('Metode Pembayaran', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Row(
                              children: [
                                Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF15803D), size: 20),
                                SizedBox(width: 8),
                                Text('QRIS (GoPay, OVO, ShopeePay, DANA)', style: TextStyle(fontSize: 12.5)),
                              ],
                            ),
                            value: 'QRIS',
                            groupValue: selectedMethod,
                            activeColor: const Color(0xFF15803D),
                            onChanged: (val) => setModalState(() => selectedMethod = val!),
                          ),
                          const Divider(height: 1),
                          RadioListTile<String>(
                            title: const Row(
                              children: [
                                Icon(Icons.account_balance_rounded, color: Color(0xFF0284C7), size: 20),
                                SizedBox(width: 8),
                                Text('Virtual Account (BCA / Mandiri / BRI)', style: TextStyle(fontSize: 12.5)),
                              ],
                            ),
                            value: 'VA',
                            groupValue: selectedMethod,
                            activeColor: const Color(0xFF15803D),
                            onChanged: (val) => setModalState(() => selectedMethod = val!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _walletBalance += selectedAmount;
                          });
                          Navigator.pop(ctx);
                          _showToast('Top Up ${_formatRupiah(selectedAmount)} via $selectedMethod Berhasil!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF15803D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          'Isi Saldo ${_formatRupiah(selectedAmount)} Sekarang',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- D. POINTS REDEEM SHEET ---
  void _showPointsRedeemSheet() {
    final List<Map<String, dynamic>> rewards = [
      {
        'title': 'Voucher Diskon Rp 25.000 Tiket Wisata',
        'points': 300,
        'icon': Icons.confirmation_number_rounded,
        'color': const Color(0xFF0284C7),
      },
      {
        'title': 'Gratis 1 Kg Apel Manalagi Petik Sendiri',
        'points': 600,
        'icon': Icons.eco_rounded,
        'color': const Color(0xFF15803D),
      },
      {
        'title': 'Topi Petani Agro Lika Eksklusif',
        'points': 1000,
        'icon': Icons.storefront_rounded,
        'color': const Color(0xFFEA580C),
      },
      {
        'title': 'Tiket VIP Masuk Agrowisata Cak Ka',
        'points': 1200,
        'icon': Icons.card_membership_rounded,
        'color': const Color(0xFF7C3AED),
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Tukar Poin Panen',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars_rounded, color: Color(0xFFD97706), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$_harvestPoints Pts',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB45309), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kumpulkan poin dari setiap transaksi belanja buah & tiket',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 16),
                  ...rewards.map((reward) {
                    final pointsNeeded = reward['points'] as int;
                    final canRedeem = _harvestPoints >= pointsNeeded;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: (reward['color'] as Color).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(reward['icon'] as IconData, color: reward['color'] as Color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reward['title'] as String,
                                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$pointsNeeded Poin',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: canRedeem ? const Color(0xFF15803D) : const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: canRedeem
                                ? () {
                                    setState(() {
                                      _harvestPoints -= pointsNeeded;
                                      _couponCount += 1;
                                    });
                                    setModalState(() {});
                                    _showToast('Selamat! Berhasil menukar reward: ${reward['title']}');
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF15803D),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFFE5E7EB),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text('Tukar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- E. COUPONS SHEET ---
  void _showCouponsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Kupon & Voucher Saya',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '${_coupons.length} Kupon Aktif',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Gunakan saat checkout di tiket wisata atau pasar buah',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            ..._coupons.map((c) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.confirmation_number_rounded, color: Color(0xFF15803D), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                          const SizedBox(height: 2),
                          Text('${c['discount']} • ${c['minOrder']}',
                              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(c['expiry']!,
                              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: c['code']!));
                        Navigator.pop(ctx);
                        _showToast('Kode voucher ${c['code']} berhasil disalin!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF15803D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Salin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // --- F. EDIT PROFILE SHEET ---
  void _showEditProfileSheet() {
    final nameCtrl = TextEditingController(text: _userName);
    final handleCtrl = TextEditingController(text: _userHandle);
    final emailCtrl = TextEditingController(text: _userEmail);
    final phoneCtrl = TextEditingController(text: _userPhone);
    final bioCtrl = TextEditingController(text: _userBio);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
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
              const Row(
                children: [
                  Icon(Icons.edit_note_rounded, color: Color(0xFF15803D)),
                  SizedBox(width: 8),
                  Text('Ubah Profil Saya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputLabel('Nama Lengkap'),
              TextField(
                controller: nameCtrl,
                decoration: _inputDecoration(hint: 'Masukkan nama lengkap', icon: Icons.person_outline),
              ),
              const SizedBox(height: 12),
              _buildInputLabel('Username / Panggilan'),
              TextField(
                controller: handleCtrl,
                decoration: _inputDecoration(hint: 'Username', icon: Icons.alternate_email_rounded),
              ),
              const SizedBox(height: 12),
              _buildInputLabel('Alamat Email'),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(hint: 'Email aktif', icon: Icons.mail_outline_rounded),
              ),
              const SizedBox(height: 12),
              _buildInputLabel('Nomor WhatsApp / HP'),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(hint: '0812xxxx', icon: Icons.phone_outlined),
              ),
              const SizedBox(height: 12),
              _buildInputLabel('Bio Singkat'),
              TextField(
                controller: bioCtrl,
                maxLines: 2,
                decoration: _inputDecoration(hint: 'Ceritakan minat Anda tentang agrowisata...', icon: Icons.info_outline),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userName = nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : _userName;
                      _userHandle = handleCtrl.text.trim().isNotEmpty ? handleCtrl.text.trim() : _userHandle;
                      _userEmail = emailCtrl.text.trim().isNotEmpty ? emailCtrl.text.trim() : _userEmail;
                      _userPhone = phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : _userPhone;
                      _userBio = bioCtrl.text.trim().isNotEmpty ? bioCtrl.text.trim() : _userBio;
                    });
                    Navigator.pop(ctx);
                    _showToast('Profil Anda berhasil diperbarui!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15803D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF15803D), width: 1.5)),
    );
  }

  // --- G. ADDRESS MANAGEMENT SHEET ---
  void _showAddressManagementSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Alamat Tersimpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          _showAddAddressDialog(() {
                            setModalState(() {});
                          });
                        },
                        icon: const Icon(Icons.add_rounded, size: 18, color: Color(0xFF15803D)),
                        label: const Text('Tambah Alamat', style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._addressList.map((addr) {
                    final isPrimary = addr['isPrimary'] == true;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isPrimary ? const Color(0xFF15803D) : const Color(0xFFE5E7EB),
                          width: isPrimary ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: isPrimary ? const Color(0xFFF0FDF4) : Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(addr['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  if (isPrimary) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF15803D),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text('Utama', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ],
                              ),
                              if (!isPrimary)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      for (var a in _addressList) {
                                        a['isPrimary'] = false;
                                      }
                                      addr['isPrimary'] = true;
                                    });
                                    setModalState(() {});
                                    _showToast('Alamat utama berhasil diubah');
                                  },
                                  child: const Text('Jadikan Utama', style: TextStyle(fontSize: 11, color: Color(0xFF15803D))),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${addr['recipient']} • ${addr['phone']}', style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563))),
                          const SizedBox(height: 2),
                          Text(addr['address'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF1F2937))),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddAddressDialog(VoidCallback onAdded) {
    final labelCtrl = TextEditingController();
    final recipientCtrl = TextEditingController(text: _userName);
    final phoneCtrl = TextEditingController(text: _userPhone);
    final addressCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Alamat Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelCtrl,
                decoration: const InputDecoration(labelText: 'Label Alamat (Contoh: Villa / Kantor / Rumah Baru)'),
              ),
              TextField(
                controller: recipientCtrl,
                decoration: const InputDecoration(labelText: 'Nama Penerima'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Nomor HP'),
              ),
              TextField(
                controller: addressCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Alamat Lengkap & Kota'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (addressCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _addressList.add({
                    'label': labelCtrl.text.trim().isNotEmpty ? labelCtrl.text.trim() : 'Alamat Lain',
                    'recipient': recipientCtrl.text.trim(),
                    'phone': phoneCtrl.text.trim(),
                    'address': addressCtrl.text.trim(),
                    'isPrimary': false,
                  });
                });
                onAdded();
                Navigator.pop(ctx);
                _showToast('Alamat baru berhasil ditambahkan');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // --- H. ORDERS HISTORY SHEET & TAB NAVIGATION ---
  void _showOrdersHistorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Riwayat & Status Pesanan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF9CA3AF), size: 20),
                  onPressed: () => Navigator.pop(ctx),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Active Order Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                border: Border.all(color: const Color(0xFF86EFAC)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF15803D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Sedang Dikirim', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const Text('#FH3413919204', style: TextStyle(fontSize: 11, color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Apel Cak Ka (10 kg)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Driver: Cak Yo • Menuju Jl. Ijen No. 12, Malang', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TrackingScreen()),
                            );
                          },
                          icon: const Icon(Icons.delivery_dining_rounded, size: 18),
                          label: const Text('Lacak Kurir Live'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF15803D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Past Order Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: Color(0xFF15803D)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tiket Masuk Kebun Apel Cak Ka', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('2 Tiket Dewasa • 20 Nov 2026', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                        Text('Total: Rp 50.000 (Selesai)', style: TextStyle(fontSize: 11, color: Color(0xFF15803D), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _showToast('Invoice terunduh ke perangkat Anda');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF15803D),
                      side: const BorderSide(color: Color(0xFF15803D)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    child: const Text('Invoice', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
            if (widget.onNavigateToTab != null) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onNavigateToTab!(3);
                  },
                  icon: const Icon(Icons.receipt_long_rounded, size: 16, color: Color(0xFF15803D)),
                  label: const Text(
                    'Buka Semua di Tab Pesanan',
                    style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF0FDF4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- I. FAVORITES & WISHLIST SHEET ---
  void _showFavoritesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Favorit & Wishlist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Text('${_favorites.length} Disimpan',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFDB2777))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ..._favorites.map((fav) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              fav['image'] as String,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFCE7F3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    fav['type'] as String,
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFDB2777)),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(fav['title'] as String,
                                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(fav['price'] as String,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF15803D))),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_rounded, color: Color(0xFFDB2777), size: 22),
                            onPressed: () {
                              setState(() {
                                _favorites.remove(fav);
                              });
                              setModalState(() {});
                              _showToast('Dihapus dari wishlist');
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- J. SECURITY SHEET ---
  void _showSecuritySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: Color(0xFF7C3AED)),
                      SizedBox(width: 8),
                      Text('Keamanan Akun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Ubah PIN AgroPay
                  ListTile(
                    leading: const Icon(Icons.pin_rounded, color: Color(0xFF15803D)),
                    title: const Text('Ubah PIN AgroPay (6-Digit)', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Digunakan untuk konfirmasi transaksi pembayaran', style: TextStyle(fontSize: 11.5)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showChangePinDialog();
                    },
                  ),
                  const Divider(),
                  // Ganti Kata Sandi
                  ListTile(
                    leading: const Icon(Icons.lock_reset_rounded, color: Color(0xFF0284C7)),
                    title: const Text('Ganti Kata Sandi', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Terakhir diubah 30 hari yang lalu', style: TextStyle(fontSize: 11.5)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showChangePasswordDialog();
                    },
                  ),
                  const Divider(),
                  // Biometrik
                  SwitchListTile(
                    secondary: const Icon(Icons.fingerprint_rounded, color: Color(0xFF7C3AED)),
                    title: const Text('Autentikasi Biometrik', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Login & bayar cepat dengan Sidik Jari / Face ID', style: TextStyle(fontSize: 11.5)),
                    activeColor: const Color(0xFF15803D),
                    value: _biometricEnabled,
                    onChanged: (val) {
                      setModalState(() => _biometricEnabled = val);
                      setState(() => _biometricEnabled = val);
                      _showToast(_biometricEnabled ? 'Biometrik diaktifkan' : 'Biometrik dinonaktifkan');
                    },
                  ),
                  const Divider(),
                  // 2FA
                  SwitchListTile(
                    secondary: const Icon(Icons.phonelink_lock_rounded, color: Color(0xFFD97706)),
                    title: const Text('Verifikasi 2 Langkah (2FA)', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Kirim kode SMS / WhatsApp saat login dari device baru', style: TextStyle(fontSize: 11.5)),
                    activeColor: const Color(0xFF15803D),
                    value: _twoFactorEnabled,
                    onChanged: (val) {
                      setModalState(() => _twoFactorEnabled = val);
                      setState(() => _twoFactorEnabled = val);
                      _showToast(_twoFactorEnabled ? '2FA diaktifkan' : '2FA dinonaktifkan');
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangePinDialog() {
    final pinCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah PIN AgroPay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan 6 angka PIN baru untuk keamanan transaksi dompet AgroPay Anda.', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 14),
            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, letterSpacing: 8, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••••',
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (pinCtrl.text.length == 6) {
                Navigator.pop(ctx);
                _showToast('PIN AgroPay berhasil diperbarui!');
              } else {
                _showToast('PIN harus terdiri dari 6 angka', isSuccess: false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white),
            child: const Text('Simpan PIN'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ganti Kata Sandi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Kata Sandi Lama', icon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Kata Sandi Baru (Min. 8 Karakter)', icon: Icon(Icons.lock_reset)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (newPassCtrl.text.length >= 6) {
                Navigator.pop(ctx);
                _showToast('Kata sandi berhasil diubah!');
              } else {
                _showToast('Kata sandi minimal 6 karakter', isSuccess: false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // --- K. NOTIFICATION PREFERENCES SHEET ---
  void _showNotificationPreferencesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  const Row(
                    children: [
                      Icon(Icons.notifications_active_rounded, color: Color(0xFFD97706)),
                      SizedBox(width: 8),
                      Text('Pengaturan Notifikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Promo & Flash Deal Panen', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Dapatkan voucher diskon hingga 50% tiket wisata', style: TextStyle(fontSize: 11.5)),
                    activeColor: const Color(0xFF15803D),
                    value: _notifPromo,
                    onChanged: (val) {
                      setModalState(() => _notifPromo = val);
                      setState(() => _notifPromo = val);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Status Pesanan & Pengiriman', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Live update lokasi kurir dan konfirmasi tiket', style: TextStyle(fontSize: 11.5)),
                    activeColor: const Color(0xFF15803D),
                    value: _notifOrders,
                    onChanged: (val) {
                      setModalState(() => _notifOrders = val);
                      setState(() => _notifOrders = val);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Kalender Musim Panen Buah', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Pemberitahuan saat Apel Manalagi & Jeruk siap petik', style: TextStyle(fontSize: 11.5)),
                    activeColor: const Color(0xFF15803D),
                    value: _notifHarvest,
                    onChanged: (val) {
                      setModalState(() => _notifHarvest = val);
                      setState(() => _notifHarvest = val);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Buletin & Tips Pertanian via Email', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Kabar mitra tani dan rilis fitur baru', style: TextStyle(fontSize: 11.5)),
                    activeColor: const Color(0xFF15803D),
                    value: _notifEmail,
                    onChanged: (val) {
                      setModalState(() => _notifEmail = val);
                      setState(() => _notifEmail = val);
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showToast('Preferensi notifikasi berhasil disimpan');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF15803D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Simpan Preferensi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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

  // --- L. HELP CENTER SHEET ---
  void _showHelpCenterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
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
              const Row(
                children: [
                  Icon(Icons.headset_mic_rounded, color: Color(0xFF0D9488)),
                  SizedBox(width: 8),
                  Text('Pusat Bantuan & Layanan CS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Tim Agro App siap membantu setiap hari pukul 08:00 - 21:00 WIB',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 16),
              // Contact Channels
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        _showLiveChatCsDialog();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF99F6E4)),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF0D9488), size: 24),
                            SizedBox(height: 6),
                            Text('Live Chat CS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
                            Text('Online 24/7', style: TextStyle(fontSize: 10, color: Color(0xFF115E59))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: '+6281319030599'));
                        Navigator.pop(ctx);
                        _showToast('Nomor WhatsApp CS (+62 813-1903-0599) disalin!');
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.phone_in_talk_rounded, color: Color(0xFF15803D), size: 24),
                            SizedBox(height: 6),
                            Text('WhatsApp CS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                            Text('Respon Cepat', style: TextStyle(fontSize: 10, color: Color(0xFF14532D))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text('Pertanyaan Populer (FAQ)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
              const SizedBox(height: 8),
              _buildFaqItem(
                'Bagaimana cara booking paket wisata petik apel?',
                'Pilih menu Jelajah atau Beranda, pilih paket wisata petik apel yang diinginkan, tentukan tanggal kunjungan dan jumlah orang, lalu lakukan pembayaran via AgroPay atau QRIS.',
              ),
              _buildFaqItem(
                'Berapa lama estimasi pengiriman buah segar?',
                'Pengiriman instan area Kota Batu & Malang memakan waktu 1-3 jam dengan armada kurir lokal Cak Yo. Luar kota membutuhkan 1-2 hari via ekspedisi khusus buah.',
              ),
              _buildFaqItem(
                'Apakah tiket wisata bisa di-reschedule?',
                'Ya, Anda dapat mengajukan jadwal ulang selambat-lambatnya 24 jam sebelum tanggal kunjungan melalui menu Riwayat Pesanan.',
              ),
              _buildFaqItem(
                'Bagaimana cara mendaftar jadi Mitra Kebun?',
                'Hubungi CS kami melalui WhatsApp atau email kemitraan di mitra@agroapp.id dengan melampirkan lokasi dan luas kebun Anda.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        title: Text(question, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
        children: [
          Text(answer, style: const TextStyle(fontSize: 11.5, color: Color(0xFF4B5563), height: 1.4)),
        ],
      ),
    );
  }

  void _showLiveChatCsDialog() {
    final chatCtrl = TextEditingController();
    final List<Map<String, String>> messages = [
      {'sender': 'cs', 'text': 'Halo Kak Dandi! Ada yang bisa kami bantu seputar tiket wisata atau pesanan buah hari ini? 😊'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setChatState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            titlePadding: const EdgeInsets.all(16),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF15803D),
                  radius: 16,
                  child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 20),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CS Agro Lika Support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Online • Siap Membantu', style: TextStyle(fontSize: 10, color: Color(0xFF15803D))),
                  ],
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 280,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, idx) {
                        final msg = messages[idx];
                        final isUser = msg['sender'] == 'user';
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isUser ? const Color(0xFF15803D) : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              msg['text']!,
                              style: TextStyle(fontSize: 12, color: isUser ? Colors.white : const Color(0xFF1F2937)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatCtrl,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: 'Tulis pesan bantuan...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: Color(0xFF15803D)),
                        onPressed: () {
                          if (chatCtrl.text.trim().isNotEmpty) {
                            final userText = chatCtrl.text.trim();
                            chatCtrl.clear();
                            setChatState(() {
                              messages.add({'sender': 'user', 'text': userText});
                            });
                            Future.delayed(const Duration(milliseconds: 700), () {
                              setChatState(() {
                                messages.add({
                                  'sender': 'cs',
                                  'text': 'Terima kasih informasinya Kak Dandi! Tim kami sedang menindaklanjuti permintaan Anda.',
                                });
                              });
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
            ],
          );
        },
      ),
    );
  }

  // --- M. LOGOUT CONFIRMATION DIALOG ---
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keluar dari Akun?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anda harus masuk kembali untuk mengakses pesanan aktif, keranjang belanja, dan saldo AgroPay Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Batal', style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    try {
                      await FirebaseAuth.instance.signOut();
                    } catch (_) {}
                    if (!mounted) return;
                    _showToast('Berhasil keluar dari akun LIKA');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) =>
                            const OnboardingScreen(startAtAuthChoice: true),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Ya, Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String? badgeText;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.onTap,
  });
}
