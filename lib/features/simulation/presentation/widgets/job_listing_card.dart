import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Represents a skill with match status
class SkillTag {
  final String name;
  final bool isMatched; // true = green check, false = red check

  const SkillTag({required this.name, this.isMatched = true});
}

class JobListingCard extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String location;
  final String source;
  final int matchPercent;
  final List<SkillTag> skills;
  final String salary;
  final String postedTime;
  final String experienceLevel;
  final VoidCallback? onAnalyze;

  const JobListingCard({
    super.key,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.source,
    required this.matchPercent,
    required this.skills,
    required this.salary,
    required this.postedTime,
    required this.experienceLevel,
    this.onAnalyze,
  });

  Color get _matchColor {
    if (matchPercent >= 80) return const Color(0xFF10B981);
    if (matchPercent >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  Color get _matchBgColor {
    if (matchPercent >= 80) return const Color(0xFFD1FAE5);
    if (matchPercent >= 60) return const Color(0xFFFEF3C7);
    return const Color(0xFFFEE2E2);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row + match badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$company · $location · $source',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Match percentage badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _matchBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$matchPercent% match',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _matchColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Required Skills label
            Text(
              'Required Skills:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),

            // Skills tags with individual colors
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: skills.map((skill) {
                final checkColor =
                    skill.isMatched ? AppColors.success : AppColors.error;
                final bgColor = skill.isMatched
                    ? AppColors.success.withValues(alpha: 0.08)
                    : AppColors.error.withValues(alpha: 0.08);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 12, color: checkColor),
                      const SizedBox(width: 4),
                      Text(
                        skill.name,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Salary
            Text(
              'Salary: $salary',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            // Bottom row: posted time + analyze button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$postedTime · $experienceLevel',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
                GestureDetector(
                  onTap: onAnalyze,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Analyze Job',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
