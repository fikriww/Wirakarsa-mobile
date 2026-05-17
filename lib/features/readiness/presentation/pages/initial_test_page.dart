import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../core/services/supabase_service.dart';

class InitialTestPage extends StatefulWidget {
  final String? testId;
  const InitialTestPage({super.key, this.testId});

  @override
  State<InitialTestPage> createState() => _InitialTestPageState();
}

class _InitialTestPageState extends State<InitialTestPage> {
  final Map<int, int?> _answers = {};
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.testId != null) {
      _loadQuestions();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await SupabaseService.getQuestions(widget.testId!);
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.go('/readiness-center', extra: {'initialTabIndex': 1}),
        ),
        title: Text(
          "Skill Assessment",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Multiple Choice • ${_questions.length} questions",
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
                  // TODO: Submit answers to Supabase
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
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    final options = question['test_question_options'] as List;
    
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
            "Question ${index + 1} of ${_questions.length}",
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question["question_text"],
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(options.length, (optIndex) {
            final option = options[optIndex];
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
                        option["option_text"],
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
