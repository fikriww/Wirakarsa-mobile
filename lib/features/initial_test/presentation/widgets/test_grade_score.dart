import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Circular score indicator with progress ring
class TestGradeScore extends StatelessWidget {
  final String scoreValue;
  final double numericScore;
  final double maxScore;
  final String submittedDate;
  final String statusText;
  final Color statusColor;
  final Color statusTextColor;

  const TestGradeScore({
    super.key,
    required this.scoreValue,
    required this.numericScore,
    required this.maxScore,
    required this.submittedDate,
    required this.statusText,
    required this.statusColor,
    required this.statusTextColor,
  });

  Color _getProgressColor() {
    final ratio = numericScore / maxScore;
    if (ratio >= 0.8) return const Color(0xFF10B981);
    if (ratio >= 0.6) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final progressColor = _getProgressColor();
    final ratio = numericScore / maxScore;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circular score
        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: Color(0xFFDDEBFF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: scoreValue.contains('/') ? scoreValue.split('/')[0] : scoreValue,
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D47A1),
                  ),
                ),
                if (scoreValue.contains('/'))
                  TextSpan(
                    text: '/${scoreValue.split('/')[1]}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D47A1).withValues(alpha: 0.6),
                    ),
                  )
                else
                  TextSpan(
                    text: '/$maxScore',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D47A1).withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test Graded',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                submittedDate,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
