import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int _selectedPackageIndex = 1; // Default to 10 kg (Terpopuler)
  bool _showDonorName = true;

  final List<Map<String, dynamic>> _donationPackages = [
    {
      'title': 'Paket 5 kg',
      'desc': 'Hasil panen 5 kg Apel Manalagi',
      'price': 'Rp 100.000',
      'priceInt': 100000,
    },
    {
      'title': 'Paket 10 kg',
      'desc': 'Hasil panen 10 kg + Sertifikat Adopsi Pohon',
      'price': 'Rp 190.000',
      'priceInt': 190000,
      'isPopular': true,
    },
    {
      'title': 'Paket 20 kg',
      'desc': 'Hasil panen 20 kg + Kunjungan Gratis ke Kebun',
      'price': 'Rp 360.000',
      'priceInt': 360000,
    },
    {
      'title': 'Paket 50 kg',
      'desc': 'Adopsi 1 Pohon Penuh + Panen Raya Bersama Petani',
      'price': 'Rp 850.000',
      'priceInt': 850000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedPkg = _donationPackages[_selectedPackageIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Donasi & Program Panen',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF111827)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan program panen berhasil disalin!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Image
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1590005354167-6da97870c757?auto=format&fit=crop&w=800&q=80',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 200,
                    color: const Color(0xFFDCFCE7),
                    child: const Center(
                      child: Icon(Icons.park_rounded, size: 48, color: Color(0xFF16A34A)),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15803D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'CROWDFUNDING TANI',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ],
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
                  // Title
                  const Text(
                    'Program Panen Pohon Apel Batu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, color: Color(0xFF15803D), size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Kelompok Tani Makmur, Kota Batu',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar & Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Rp 8.500.000',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
                            ),
                            Text(
                              '85% Tercapai',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'dari target Rp 10.000.000',
                          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: const LinearProgressIndicator(
                            value: 0.85,
                            backgroundColor: Color(0xFFE5E7EB),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C853)),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.people_outline_rounded, size: 14, color: Color(0xFF4B5563)),
                                SizedBox(width: 4),
                                Text('142 Donatur', style: TextStyle(fontSize: 11, color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF4B5563)),
                                SizedBox(width: 4),
                                Text('Sisa 12 Hari Lagi', style: TextStyle(fontSize: 11, color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi Program
                  const Text(
                    'Tentang Program',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Dukung petani apel lokal di Batu dengan program adopsi pohon apel. Setiap donasi/adopsi akan digunakan untuk pupuk organik, perawatan pohon, dan jaminan panen. Ketika panen raya tiba, Anda akan menerima kiriman buah apel segar langsung ke rumah!',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.45),
                  ),
                  const SizedBox(height: 20),

                  // Pilihan Paket Panen
                  const Text(
                    'Pilih Paket Donasi / Adopsi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 10),

                  ...List.generate(_donationPackages.length, (index) {
                    final pkg = _donationPackages[index];
                    final isSelected = _selectedPackageIndex == index;
                    final isPopular = pkg['isPopular'] == true;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedPackageIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF16A34A) : const Color(0xFFE5E7EB),
                            width: isSelected ? 1.8 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: isSelected ? const Color(0xFF16A34A) : const Color(0xFF9CA3AF),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        pkg['title'] as String,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                      ),
                                      if (isPopular) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFEDD5),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'POPULER',
                                            style: TextStyle(color: Color(0xFFEA580C), fontSize: 9, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    pkg['desc'] as String,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              pkg['price'] as String,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Toggle Anonim
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Tampilkan Nama Donatur', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                          Text('Nama Anda muncul di papan pendukung', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                        ],
                      ),
                      Switch(
                        value: _showDonorName,
                        activeThumbColor: const Color(0xFF00C853),
                        onChanged: (val) => setState(() => _showDonorName = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Donasi', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                Text(
                  selectedPkg['price'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  DatabaseService.instance.createDonation(
                    packageTitle: selectedPkg['title'] as String,
                    amount: selectedPkg['priceInt'] as int,
                    showDonorName: _showDonorName,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Terima kasih telah mendukung ${selectedPkg['title']}!'),
                      backgroundColor: const Color(0xFF15803D),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                child: const Text('Ikuti Program Panen', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
