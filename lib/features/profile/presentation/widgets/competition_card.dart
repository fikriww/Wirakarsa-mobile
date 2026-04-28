import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CompetitionCard extends StatelessWidget {
  final String title;
  final String equivalent;
  final String code;
  final String date;

  const CompetitionCard({
    super.key,
    required this.title,
    required this.equivalent,
    required this.code,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9D2), // Light yellow background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE066), // Darker yellow for icon background
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Equivalent: $equivalent',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      code,
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      ' • ',
                      style: TextStyle(color: AppColors.textHint, fontSize: 10),
                    ),
                    Text(
                      date,
                      style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                    ),
                    const Text(
                      ' • ',
                      style: TextStyle(color: AppColors.textHint, fontSize: 10),
                    ),
                    const Text(
                      'Verified',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
