import 'package:flutter/material.dart';

class AgroAiScreen extends StatefulWidget {
  const AgroAiScreen({super.key});

  @override
  State<AgroAiScreen> createState() => _AgroAiScreenState();
}

class _AgroAiScreenState extends State<AgroAiScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text':
          'Halo Sobat Agro! 🌱 Saya Agro AI dari LIKA.\n\nSaya siap membantu Anda dengan informasi harga komoditas pasar apel Batu, tips budidaya pohon apel, jadwal panen raya, dan panduan agrowisata!',
      'time': '9:41',
    },
  ];

  final List<String> _quickPrompts = [
    '🍎 Harga Pasar Apel Hari Ini',
    '🐛 Cara Basmi Hama Kutu Apel',
    '🌦️ Prakiraan Cuaca Panen Batu',
    '📍 Rekomendasi Kebun Ramah Anak',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text,
        'time': 'Sekarang',
      });
    });

    _scrollToBottom();

    // AI Simulated response
    Future.delayed(const Duration(milliseconds: 600), () {
      String reply = 'Pertanyaan Anda sangat menarik! ';
      if (text.contains('Harga') || text.contains('pasar')) {
        reply =
            '📊 **Update Harga Komoditas Pasar Batu Hari Ini:**\n• Apel Manalagi Super: Rp 25.000 – 30.000/kg\n• Apel Anna (Merah Asam Segar): Rp 22.000/kg\n• Apel Rome Beauty: Rp 20.000/kg\n\nPasar LIKA siap melayani pengiriman langsung ke rumah Anda.';
      } else if (text.contains('Hama') || text.contains('Basmi')) {
        reply =
            '🌿 **Solusi Organik Hama Apel:**\n1. Semprotkan larutan minyak mimba (neem oil) atau sabun kalium cair tiap 5 hari.\n2. Jaga sirkulasi udara kanopi dengan pemangkasan tunas air.\n3. Pasang perangkap kuning berperekat untuk lalat buah.';
      } else if (text.contains('Cuaca') || text.contains('Prakiraan')) {
        reply =
            '⛅ **Prakiraan Cuaca Kota Batu:**\nPagi cerah berawan (20°C), siang sejuk (24°C), dan sore kemungkinan berkabut ringan. Kondisi sangat ideal untuk aktivitas wisata petik apel!';
      } else {
        reply =
            'Kebun Apel Cak Ka dan Kebun Apel Manalagi adalah pilihan terbaik minggu ini! Anda bisa menikmati tiket promo mulai Rp 25.000 di menu Agro Tourism.';
      }

      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'text': reply,
            'time': 'Sekarang',
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_rounded, color: Color(0xFF15803D), size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Agro AI Assistant',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                Text(
                  '● Online • Cerdas & Siap Membantu',
                  style: TextStyle(fontSize: 10, color: Color(0xFF15803D), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] == true;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF15803D) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isUser ? 18 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: isUser ? null : Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'] as String,
                          style: TextStyle(
                            color: isUser ? Colors.white : const Color(0xFF1F2937),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg['time'] as String,
                            style: TextStyle(
                              color: isUser ? Colors.white70 : const Color(0xFF9CA3AF),
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Prompt Pills
          Container(
            height: 38,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickPrompts.length,
              itemBuilder: (context, index) {
                final prompt = _quickPrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () => _sendMessage(prompt),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFDCFCE7), width: 1.2),
                      ),
                      child: Text(
                        prompt,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Tanyakan sesuatu ke Agro AI...',
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _sendMessage(_textController.text),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C853),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
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
}
