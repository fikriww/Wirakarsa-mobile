import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../widgets/segment_button.dart';

class SubmitCodePage extends StatefulWidget {
  const SubmitCodePage({super.key});

  @override
  State<SubmitCodePage> createState() => _SubmitCodePageState();
}

class _SubmitCodePageState extends State<SubmitCodePage> {
  int _selectedIndex = 2;
  bool _isReviewed = false;

  // Controller untuk mengambil isi kode yang diketik
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () { if (context.canPop()) { context.pop(); } else { context.go('/devhub'); } },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.menu, color: Colors.black), onPressed: () {}),
        ],
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'Development Hub',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Level up your skills and work readiness',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 100.0),
        child: Column(
          children: [
            Row(
              children: [
                SegmentButton(
                  label: "Mini Project",
                  isActive: false,
                  onTap: () => context.go('/devhub', extra: {'isCodeReviewActive': false}),
                ),
                const SizedBox(width: 12),
                SegmentButton(
                  label: "Code Review",
                  isActive: true,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 25),
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
            
            // Area Editor yang Bisa Diklik dan Diketik
            Container(
              height: 400,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: TextField(
                controller: _codeController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: Colors.white, 
                  fontFamily: 'monospace', 
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: "// Write your code here...",
                  hintStyle: TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Tombol Review
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isReviewed = true;
                  });
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
            
            if (_isReviewed) ...[
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Review Results", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              _buildReviewCard(
                type: "Critical",
                badgeColor: const Color(0xFFF59E0B),
                bgColor: const Color(0xFFFDE68A),
                location: "Line 2",
                description: "Avoid using var. Use const or let instead to prevent hoisting issues.",
                codeSnippet: "const userData = await fetchUser()",
                codeBgColor: const Color(0xFFB45309),
              ),
              _buildReviewCard(
                type: "Warning",
                badgeColor: const Color(0xFFEF4444),
                bgColor: const Color(0xFFFECACA),
                location: "Line 4 - 8",
                description: "Functions handleSubmit does too many things. Split into smaller, single-responsibility functions.",
              ),
              _buildReviewCard(
                type: "Insight",
                badgeColor: const Color(0xFF3B82F6),
                bgColor: const Color(0xFFBFDBFE),
                location: "Overall",
                description: "No unit test coverage detected. Add Jest tests for handleSubmit edge cases to improve reliability.",
              ),
              _buildReviewCard(
                type: "Good",
                badgeColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFA7F3D0),
                location: "Line 12",
                description: "Clean JSX structure with proper event binding. Form semantics look correct.",
              ),
              const SizedBox(height: 24),
              _buildSkillImpact(),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }

  Widget _buildReviewCard({
    required String type,
    required Color badgeColor,
    required Color bgColor,
    required String location,
    required String description,
    String? codeSnippet,
    Color? codeBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                location,
                style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: Colors.black87, fontSize: 13),
          ),
          if (codeSnippet != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: codeBgColor ?? Colors.black12,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                codeSnippet,
                style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillImpact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Skill Impact from this Review", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Testing (Jest)", style: TextStyle(fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(4)),
                    child: Text("+5 pts", style: TextStyle(color: Colors.blue[700], fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Web Performance", style: TextStyle(fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(4)),
                    child: Text("+3 pts", style: TextStyle(color: Colors.blue[700], fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Applied after you fix & resubmit", style: TextStyle(color: Colors.black54, fontSize: 11, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ],
    );
  }
}
