import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class InitialTestPage extends StatefulWidget {
  const InitialTestPage({super.key});

  @override
  State<InitialTestPage> createState() => _InitialTestPageState();
}

class _InitialTestPageState extends State<InitialTestPage> {
  final Map<int, int?> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "Which data structure uses LIFO (Last In, First Out) order?",
      "options": ["Queue", "Stack", "Linked List", "Tree"],
    },
    {
      "question": "Which HTTP method is idempotent and used to fully update a resource?",
      "options": ["POST", "PATCH", "PUT", "DELETE"],
    },
    {
      "question": "What is tail recursion?",
      "options": [
        "Recursion that never terminates",
        "Recursion where the recursive call is the last operation",
        "A loop disguised as recursion",
        "Recursion with two base cases"
      ],
    },
    {
      "question": "Which testing approach tests a module in isolation with mocked dependencies?",
      "options": ["Integration testing", "End-to-end testing", "Unit testing", "Smoke testing"],
    },
    {
      "question": "What is eventual consistency in distributed systems?",
      "options": [
        "All nodes are always in sync",
        "A transaction rollback mechanism",
        "A replication strategy",
        "Data updates propagate to all nodes over time, not instantly"
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Programming / Software Development",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEC85),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "PROG",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Multiple Choice • 5 questions",
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(_questions.length, (index) {
              return _buildQuestionCard(index);
            }),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Submit logic and navigate to review page
                  context.go('/readiness-center/review-test');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF066EFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${index + 1} of 5",
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question["question"],
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(question["options"].length, (optIndex) {
            bool isSelected = _answers[index] == optIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _answers[index] = optIndex;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF066EFF) : Colors.grey.shade400,
                          width: isSelected ? 6 : 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question["options"][optIndex],
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
