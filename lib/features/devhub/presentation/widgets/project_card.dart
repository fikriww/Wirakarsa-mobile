import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable project card widget for the DevHub mini projects list.
/// Uses the app's original theme colors (AppColors) with website-style layout.
class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String level; // BEGINNER, INTERMEDIATE, ADVANCED
  final String status; // SELESAI DIREVIEW, BELUM MULAI
  final String duration; // "2 hours", "4 hours", etc.
  final List<String> techTags; // ["HTML/CSS", "React"]
  final int? score; // nullable — only shown if reviewed
  final VoidCallback? onTapStartProject;
  final VoidCallback? onTapViewResult;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.level,
    required this.status,
    required this.duration,
    required this.techTags,
    this.score,
    this.onTapStartProject,
    this.onTapViewResult,
  });

  bool get _isReviewed => status == 'SELESAI DIREVIEW';

  Color get _levelColor {
    switch (level.toUpperCase()) {
      case 'BEGINNER':
        return AppColors.primaryBlue;
      case 'INTERMEDIATE':
        return AppColors.primaryDark;
      case 'ADVANCED':
        return const Color(0xFFE04E2B);
      default:
        return AppColors.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isReviewed
              ? AppColors.primaryBlue.withValues(alpha: 0.25)
              : AppColors.divider,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Badge Row: Level + Status + Duration ──
            _buildBadgeRow(),
            const SizedBox(height: 18),

            // ── Title ──
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppColors.primaryDark,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),

            // ── Description ──
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // ── Tech Tags + Score ──
            _buildTagsAndScore(),
            const SizedBox(height: 20),

            // ── Action Button ──
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeRow() {
    return Row(
      children: [
        // Level badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _levelColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            level,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _isReviewed
                ? AppColors.success.withValues(alpha: 0.12)
                : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: _isReviewed
                  ? AppColors.success
                  : AppColors.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const Spacer(),
        // Duration
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule_rounded, size: 15, color: AppColors.textHint),
            const SizedBox(width: 4),
            Text(
              duration,
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsAndScore() {
    return Row(
      children: [
        // Tech tags — using old app's light blue style
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: techTags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        // Score (only if reviewed)
        if (score != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryBlue),
              const SizedBox(width: 4),
              Text(
                'Skor: $score/100',
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: _isReviewed
          ? OutlinedButton.icon(
              onPressed: onTapViewResult,
              icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
              label: const Text(
                'Lihat Hasil Evaluasi',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onTapStartProject,
              icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
              label: const Text(
                'Mulai Proyek',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
    );
  }
}
