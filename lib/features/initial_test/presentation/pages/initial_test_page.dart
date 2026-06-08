import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/initial_test_model.dart';

class InitialTestPage extends StatefulWidget {
  final InitialTestData data;
  final Function(Map<int, int> selectedAnswers, Map<int, String> essayAnswers)? onSubmit;

  const InitialTestPage({
    super.key,
    required this.data,
    this.onSubmit,
  });

  @override
  State<InitialTestPage> createState() => _InitialTestPageState();
}

class _InitialTestPageState extends State<InitialTestPage> {
  /// Tracks selected option index per question
  final Map<int, int> _selectedAnswers = {};

  /// Tracks text input for essay fields
  final Map<int, TextEditingController> _essayControllers = {};

  @override
  void initState() {
    super.initState();
    if (widget.data.essayFields != null) {
      for (int i = 0; i < widget.data.essayFields!.length; i++) {
        _essayControllers[i] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _essayControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.data.testTitle.replaceAll('\n', ' '),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              widget.data.testSubtitle,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.data.badgeColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.data.badgeText,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: widget.data.badgeTextColor,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 0.5, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Multiple choice questions
                  if (widget.data.questions != null)
                    ...widget.data.questions!.asMap().entries.map(
                          (entry) => _buildQuestionCard(
                            entry.key,
                            entry.value,
                            widget.data.questions!.length,
                          ),
                        ),

                  // Practical task description
                  if (widget.data.practicalTaskDescription != null) ...[
                    _buildPracticalTask(),
                    const SizedBox(height: 20),
                  ],

                  // Upload fields
                  if (widget.data.uploadFields != null)
                    ...widget.data.uploadFields!.map(
                      (field) => _buildUploadField(field),
                    ),

                  // Essay fields
                  if (widget.data.essayFields != null)
                    ...widget.data.essayFields!.asMap().entries.map(
                          (entry) => _buildEssayField(entry.key, entry.value),
                        ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Submit button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final essayAnswers = _essayControllers.map(
                    (key, controller) => MapEntry(key, controller.text),
                  );

                  debugPrint('--- TEST SUBMITTED ---');
                  debugPrint('Test: ${widget.data.testTitle}');
                  debugPrint('Selected Answers: $_selectedAnswers');
                  debugPrint('Essay Answers: $essayAnswers');
                  debugPrint('----------------------');

                  if (widget.onSubmit != null) {
                    widget.onSubmit!(_selectedAnswers, essayAnswers);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Test submitted!',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a multiple choice question card
  Widget _buildQuestionCard(int index, TestQuestion question, int total) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number
          Text(
            'Question ${index + 1} of $total',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 6),
          // Question text
          Text(
            question.questionText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Options
          ...question.options.asMap().entries.map(
                (entry) => _buildOptionTile(index, entry.key, entry.value),
              ),
        ],
      ),
    );
  }

  /// Builds a single radio option tile
  Widget _buildOptionTile(int questionIndex, int optionIndex, QuestionOption option) {
    final isSelected = _selectedAnswers[questionIndex] == optionIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAnswers[questionIndex] = optionIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.04)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryBlue : AppColors.border,
                  width: isSelected ? 5 : 1.5,
                ),
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.text,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the practical task section
  Widget _buildPracticalTask() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE69C), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practical Task',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.data.practicalTaskDescription!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 1.7,
              color: AppColors.textPrimary.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an upload field
  Widget _buildUploadField(UploadField field) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              // Fake upload simulation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Simulating file upload...',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: AppColors.primaryBlue,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload File',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    field.supportedFormats,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textHint,
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

  /// Builds an essay text field
  Widget _buildEssayField(int index, EssayField field) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (field.placeholder.isNotEmpty) ...[
                  Text(
                    field.placeholder,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      height: 1.6,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(height: 0.5, color: AppColors.divider),
                  const SizedBox(height: 10),
                ],
                TextField(
                  controller: _essayControllers[index],
                  maxLines: 5,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write the main insights from your analysis.',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
