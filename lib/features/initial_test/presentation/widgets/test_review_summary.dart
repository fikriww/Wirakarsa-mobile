import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// AI Review Summary section with star icon
class TestReviewSummary extends StatelessWidget {
  final String summary;

  const TestReviewSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1D4ED8),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.star_outline,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AI Review Summary',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          summary,
          style: GoogleFonts.poppins(
            fontSize: 13,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
