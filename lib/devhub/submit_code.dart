import 'package:flutter/material.dart';

class SubmitCodeScreen extends StatefulWidget {
  const SubmitCodeScreen({super.key});

  @override
  State<SubmitCodeScreen> createState() => _SubmitCodeScreenState();
}

class _SubmitCodeScreenState extends State<SubmitCodeScreen> {
  // Controller untuk mengambil isi kode yang diketik
  final TextEditingController _codeController = TextEditingController(
    text: "// Tulis kode kamu di sini...",
  );

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.menu, color: Colors.black), onPressed: () {}),
        ],
        centerTitle: true,
        title: const Text(
          'Development Hub',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView( // Tambahkan ini agar layar bisa di-scroll saat keyboard muncul
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header File (Abu-abu)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFE2E8F0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attachment, size: 20, color: Colors.black54),
                  const SizedBox(width: 10),
                  const Text("CheckoutForm.jsx", style: TextStyle(fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF64748B), borderRadius: BorderRadius.circular(4)),
                    child: const Text("JSX", style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
              ),
            ),
            
            // --- PERBAIKAN: Area Editor yang Bisa Diklik dan Diketik ---
            Container(
              height: 400, // Ukuran editor
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: TextField(
                controller: _codeController,
                maxLines: null, // Membuatnya bisa banyak baris
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: Colors.white, 
                  fontFamily: 'monospace', 
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none, // Menghilangkan garis bawah default
                  hintText: "Mulai mengetik kode...",
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Tombol Review
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Cara mengambil teks kode: print(_codeController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Review My Code", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}