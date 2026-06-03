import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

/// Reusable project detail/brief page widget.
/// Used by all 4 detail pages with different data.
class ProjectDetailPage extends StatefulWidget {
  final String projectTitle;
  final String level; // "Beginner", "Intermediate", "Advanced"
  final String duration;
  final int variants;
  final int progressPercent;
  final String briefText;
  final String submitRoute;

  const ProjectDetailPage({
    super.key,
    required this.projectTitle,
    required this.level,
    required this.duration,
    required this.variants,
    required this.progressPercent,
    required this.briefText,
    required this.submitRoute,
  });

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  String? _attachedFileName;

  Color get _levelColor {
    switch (widget.level.toUpperCase()) {
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

  Color get _progressColor {
    if (widget.progressPercent >= 70) return AppColors.success;
    if (widget.progressPercent >= 40) return const Color(0xFFF59E0B);
    return AppColors.primaryBlue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/devhub');
            }
          },
        ),
        title: const Text(
          'Detail Proyek',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Project Header Card ──
              _buildHeaderCard(),
              const SizedBox(height: 24),

              // ── Brief Section ──
              _buildBriefSection(),
              const SizedBox(height: 24),

              // ── My Work Section ──
              _buildMyWorkSection(),
              const SizedBox(height: 28),

              // ── Submit Button ──
              _buildSubmitButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  /// Project header with title, meta info, and progress ring.
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level badge + progress
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _levelColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  widget.level.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const Spacer(),
              // Progress ring
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        value: widget.progressPercent / 100,
                        strokeWidth: 4,
                        backgroundColor: AppColors.inputBackground,
                        color: _progressColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '${widget.progressPercent}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _progressColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Title
          Text(
            widget.projectTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),

          // Meta info chips
          Row(
            children: [
              _buildMetaChip(Icons.schedule_rounded, widget.duration),
              const SizedBox(width: 10),
              _buildMetaChip(Icons.layers_rounded, '${widget.variants} variants'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textHint),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Brief section with the project description card.
  Widget _buildBriefSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.description_outlined,
                size: 20, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            const Text(
              'Project Brief',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.15),
            ),
          ),
          child: Text(
            widget.briefText,
            style: const TextStyle(
              fontSize: 13,
              height: 1.7,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  /// My Work section with file attach and status.
  Widget _buildMyWorkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.folder_open_rounded,
                size: 20, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            const Text(
              'My Work',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // File attachment area
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.divider,
              style: _attachedFileName == null
                  ? BorderStyle.solid
                  : BorderStyle.solid,
            ),
          ),
          child: _attachedFileName == null
              ? _buildEmptyAttachment()
              : _buildAttachedFile(),
        ),
      ],
    );
  }

  Widget _buildEmptyAttachment() {
    return InkWell(
      onTap: () => setState(() => _attachedFileName = 'project_submission.zip'),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              color: AppColors.primaryBlue,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Upload file proyek',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap untuk melampirkan .zip atau link GitHub',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedFile() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.insert_drive_file_rounded,
            color: AppColors.primaryBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _attachedFileName!,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              const Text(
                'File terlampir',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _attachedFileName = null),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.close_rounded,
                color: AppColors.error, size: 16),
          ),
        ),
      ],
    );
  }

  /// Submit button.
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => context.push(widget.submitRoute),
        icon: const Icon(Icons.send_rounded, size: 18),
        label: const Text(
          'Submit Project',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
