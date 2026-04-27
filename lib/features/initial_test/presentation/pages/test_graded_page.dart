import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/test_result_data.dart';
import '../widgets/test_grade_score.dart';
import '../widgets/test_review_summary.dart';
import '../widgets/test_metrics_grid.dart';
import '../widgets/issue_to_fix_card.dart';

class TestGradedPage extends StatelessWidget {
  final TestResultData data;

  const TestGradedPage({super.key, required this.data});

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
              data.testTitle.replaceAll('\n', ' '),
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
              data.testSubtitle,
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
                color: data.badgeColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                data.badgeText,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: data.badgeTextColor,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Score circle
                  TestGradeScore(
                    scoreValue: data.scoreValue,
                    numericScore: data.numericScore,
                    maxScore: data.maxScore,
                    submittedDate: data.submittedDate,
                    statusText: data.statusText,
                    statusColor: data.statusColor,
                    statusTextColor: data.statusTextColor,
                  ),

                  const SizedBox(height: 40),

                  // AI Review Summary
                  TestReviewSummary(summary: data.aiSummary),

                  // Metrics grid (if present)
                  if (data.metrics != null && data.metrics!.isNotEmpty)
                    TestMetricsGrid(metrics: data.metrics!),

                  const SizedBox(height: 24),

                  // Quoted text (for Programming test)
                  if (data.quotedText != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          left: BorderSide(
                            color: AppColors.primaryBlue,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        data.quotedText!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // "Issue to Fix" Header
                  if (data.issues.isNotEmpty) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D4ED8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.build, // hammer-like
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Issue to Fix',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Issues to fix cards
                  ...data.issues.map(
                    (issue) => IssueToFixCard(issue: issue),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Close button at bottom
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
                onPressed: () => Navigator.of(context).maybePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Close',
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
}
