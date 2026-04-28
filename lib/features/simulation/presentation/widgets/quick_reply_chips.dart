import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class QuickReplyChips extends StatelessWidget {
  final List<String> replies;
  final ValueChanged<String>? onTap;

  const QuickReplyChips({
    super.key,
    required this.replies,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: replies.map((reply) {
          return GestureDetector(
            onTap: () => onTap?.call(reply),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Text(
                reply,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
