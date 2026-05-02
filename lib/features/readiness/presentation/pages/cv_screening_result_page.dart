import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CvScreeningResultPage extends StatelessWidget {
  const CvScreeningResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your CV has been reviewed", style: AppTextStyles.heading1.copyWith(fontSize: 18)),
                    const SizedBox(height: 16),
                    _buildCvPreviewMock(),
                    const SizedBox(height: 32),
                    _buildSectionTitle(Icons.star, "AI Review Summary"),
                    const SizedBox(height: 12),
                    Text(
                      "Your CV already has a solid foundation. It includes work experience, listed skills, and a fairly clean format. However, there are 3 critical areas that need improvement to pass ATS screening and capture a recruiter's attention within the first 6 seconds.",
                      style: AppTextStyles.bodySmall.copyWith(height: 1.5, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle(Icons.menu, "Score by Category"),
                    const SizedBox(height: 16),
                    _buildScoreRow("Structure & Completeness", 0.55, "55%", "Mostly complete, some details missing."),
                    _buildScoreRow("Content Quality", 0.48, "48%", "Needs stronger, more impactful content."),
                    _buildScoreRow("Skills & Keywords", 0.60, "60%", "Not fully optimized yet."),
                    _buildScoreRow("Format & ATS Compatibility", 0.78, "78%", "Clean and ATS-friendly."),
                    _buildScoreRow("First Impression", 0.58, "58%", "Good, but not standout."),
                    const SizedBox(height: 32),
                    _buildSectionTitle(Icons.check_circle, "What's Already Good"),
                    const SizedBox(height: 16),
                    _buildGoodItem("Photo and contact details are complete"),
                    _buildGoodItem("Work experience is well-structured"),
                    _buildGoodItem("CV length is ideal (1 page)"),
                    _buildGoodItem("No significant typos found"),
                    const SizedBox(height: 32),
                    _buildSectionTitle(Icons.build, "Issue to Fix"),
                    const SizedBox(height: 16),
                    _buildIssueCard(
                      "No Professional Summary",
                      "Your CV jumps straight into work experience without a summary. Recruiters take 6 seconds to decide. Without it, you lose that opportunity.",
                      "Add 3-4 sentences at the top: who you are, your specialization, and the value you bring."
                    ),
                    _buildIssueCard(
                      "No Measurable Achievements",
                      "You wrote \"improved application performance\" but provided no metrics. Recruiters can't measure your impact.",
                      "Rewrite as: \"Improved load time from 4.2s to 1.8s using code splitting & lazy loading, reducing bounce rate by 23%.\""
                    ),
                    _buildIssueCard(
                      "No Certifications or Training",
                      "In fast-moving tech, certifications show continuous learning and can be a tiebreaker.",
                      "Add relevant certifications: AWS, Google Cloud, Meta React Certificate, or completed Udemy/Coursera courses."
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go('/readiness-center'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => context.pop(),
          ),
          Column(
            children: [
              Text("CV Screening", style: AppTextStyles.heading1.copyWith(fontSize: 20)),
              Text("Get instant AI-powered analysis", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.menu, size: 28),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCvPreviewMock() {
    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("John Doe", style: AppTextStyles.heading1.copyWith(fontSize: 24, color: const Color(0xFF1E293B))),
          Text("Front End Developer", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF64748B))),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.email, size: 10, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text("john.doe@email.com", style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: const Color(0xFF64748B))),
              const SizedBox(width: 12),
              const Icon(Icons.phone, size: 10, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text("+65 8123 4567", style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: const Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 16),
          Text("Professional Summary", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            "Recent Computer Science graduate with a passion for front end development. Proficient in React, Next.js, and modern JavaScript libraries. Eager to leverage academic background and internship experience to build responsive and user-friendly web applications.",
            style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: const Color(0xFF475569)),
          ),
          const SizedBox(height: 16),
          Text("Skills", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(4)), child: Text("Core", style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: const Color(0xFF1E293B)))),
              const SizedBox(width: 4),
              Text("React 18, TypeScript, Next.js", style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: const Color(0xFF475569))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(4)), child: Text("Styling", style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: const Color(0xFF1E293B)))),
              const SizedBox(width: 4),
              Text("Tailwind CSS, CSS Modules", style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: const Color(0xFF475569))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.heading1.copyWith(fontSize: 16)),
      ],
    );
  }

  Widget _buildScoreRow(String title, double progress, String percent, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 3, child: Text(title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold))),
              Expanded(
                flex: 4,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.divider,
                  color: AppColors.primaryBlue,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Text(percent, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildGoodItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xFF388E3C), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildIssueCard(String title, String desc1, String desc2) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(desc1, style: AppTextStyles.bodySmall.copyWith(height: 1.5, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Text(desc2, style: AppTextStyles.bodySmall.copyWith(height: 1.5, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

}
