import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SkillProgress extends StatelessWidget {
  final String title;
  final int percentage;
  final String code;
  final String date;
  final Color progressColor;

  const SkillProgress({
    super.key,
    required this.title,
    required this.percentage,
    required this.code,
    required this.date,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: AppColors.inputBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percentage%',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              code,
              style: const TextStyle(color: AppColors.textHint, fontSize: 10),
            ),
            const Text(
              ' • ',
              style: TextStyle(color: AppColors.textHint, fontSize: 10),
            ),
            Text(
              date,
              style: const TextStyle(color: AppColors.textHint, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}
