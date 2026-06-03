import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../widgets/score_donut_chart.dart';

/// Data class for evaluation criteria items.
class EvaluationCriteriaItem {
  final String label;
  final bool passed;

  const EvaluationCriteriaItem({required this.label, required this.passed});
}

/// Reusable evaluation result page using the app's original theme (AppColors).
/// Layout matches Wirapath website reference.
class EvaluationResultPage extends StatelessWidget {
  final String projectTitle;
  final String projectDescription;
  final int score;
  final bool passed;
  final int criteriaMetCount;
  final int criteriaTotalCount;
  final String estimatedDuration;
  final List<EvaluationCriteriaItem> evaluationCriteria;
  final List<String> strengths;
  final List<String> recommendations;
  final List<String> skillTags;

  const EvaluationResultPage({
    super.key,
    required this.projectTitle,
    required this.projectDescription,
    required this.score,
    required this.passed,
    required this.criteriaMetCount,
    required this.criteriaTotalCount,
    required this.estimatedDuration,
    required this.evaluationCriteria,
    required this.strengths,
    required this.recommendations,
    required this.skillTags,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/devhub');
            }
          },
        ),
        title: const Text(
          'Kembali ke Detail Proyek',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
              _buildHeader(),
              const SizedBox(height: 28),
              _buildScoreSection(),
              const SizedBox(height: 24),
              _buildStatusSection(),
              const SizedBox(height: 16),
              _buildSasaranSection(),
              const SizedBox(height: 16),
              _buildDurationSection(),
              const SizedBox(height: 28),
              _buildCriteriaSection(),
              const SizedBox(height: 28),
              _buildStrengthsSection(),
              const SizedBox(height: 28),
              _buildRecommendationsSection(),
              const SizedBox(height: 28),
              _buildSkillTagsSection(),
              const SizedBox(height: 28),
              _buildMotivationBanner(),
              const SizedBox(height: 20),
              _buildBottomButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  // ── Header: Icon + Title + Description ──
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.cloud_outlined,
            color: AppColors.primaryBlue,
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'ULASAN HASIL PROYEK',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textHint,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          projectTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          projectDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSection() {
    return Center(
      child: ScoreDonutChart(score: score),
    );
  }

  // ── Status Kelulusan ──
  Widget _buildStatusSection() {
    return _SectionCard(
      icon: Icons.bar_chart_rounded,
      title: 'Status Kelulusan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: passed ? 1.0 : (score / 100.0),
              backgroundColor: AppColors.divider,
              color: passed ? AppColors.primaryBlue : const Color(0xFFF59E0B),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            passed ? 'LULUS' : 'BELUM LULUS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: passed ? AppColors.primaryDark : const Color(0xFFF59E0B),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSasaranSection() {
    return _SectionCard(
      icon: Icons.gps_fixed_rounded,
      title: 'Sasaran Terpenuhi',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            '$criteriaMetCount/$criteriaTotalCount',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'kriteria terpenuhi tercapai',
            style: TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSection() {
    return _SectionCard(
      icon: Icons.schedule_rounded,
      title: 'Estimasi Durasi',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            estimatedDuration,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'waktu kerja terpakai',
            style: TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaSection() {
    return _SectionCard(
      icon: Icons.checklist_rounded,
      title: 'Cakupan Evaluasi Kriteria',
      child: Column(
        children: evaluationCriteria
            .map((item) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: item.passed
                              ? AppColors.success.withValues(alpha: 0.12)
                              : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          item.passed
                              ? Icons.check_rounded
                              : Icons.warning_amber_rounded,
                          size: 16,
                          color: item.passed
                              ? AppColors.success
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: item.passed
                                ? AppColors.textPrimary
                                : const Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildStrengthsSection() {
    return _SectionCard(
      icon: Icons.emoji_events_rounded,
      title: 'Kekuatan & Kelebihan',
      child: Column(
        children: strengths
            .map((s) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return _SectionCard(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Rekomendasi Perbaikan',
      child: Column(
        children: recommendations
            .asMap()
            .entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSkillTagsSection() {
    return _SectionCard(
      icon: Icons.local_offer_outlined,
      title: 'Keahlian yang Dipraktikkan',
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skillTags
              .map((tag) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildMotivationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'LANJUTKAN REKOMENDASI BERIKUTNYA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Terus Latih Keterampilan Anda',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak perlu sempurna—cukup konsisten. Setiap baris kode membawa Anda selangkah lebih dekat menjadi developer yang lebih tangguh.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () => context.go('/devhub'),
        icon: const Icon(Icons.grid_view_rounded, size: 18),
        label: const Text(
          'Lihat Proyek Lainnya',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

/// Reusable section card with icon and title header.
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryBlue),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
