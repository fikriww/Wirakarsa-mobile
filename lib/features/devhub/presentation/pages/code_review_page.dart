import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The Code Review tab content, shown when "Code Review" segment is active.
/// This is used as a section within DevhubPage, not a standalone page.
class CodeReviewSection extends StatelessWidget {
  final VoidCallback? onSwitchToMiniProject;

  const CodeReviewSection({super.key, this.onSwitchToMiniProject});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(color: Color(0xFFE0E7FF), shape: BoxShape.circle),
            child: const Icon(Icons.code, size: 50, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 24),
        const Text('AI Code Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          child: Text(
            'Submit code from your mini project and get specific feedback just like a senior developer\'s code review.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        const SizedBox(height: 20),
        _buildCheckItem("Clean Code & Best Practices"),
        _buildCheckItem("Error Handling"),
        _buildCheckItem("Performance Optimization"),
        _buildCheckItem("Specific Improvement Suggestions "),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final result = await context.push<bool>('/devhub/submit-code');
              if (result == true) {
                onSwitchToMiniProject?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Submit Code for Review", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  static Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.black54),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ),
    );
  }
}
