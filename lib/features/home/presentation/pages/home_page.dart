import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 32),
                _buildReadinessCard(),
                const SizedBox(height: 16),
                _buildStatsRow(),
                const SizedBox(height: 32),
                _buildSectionHeader(
                  "Skills That Need Attention",
                  onViewAll: () => context.go('/readiness-center', extra: {'initialTabIndex': 3}),
                ),
                const SizedBox(height: 16),
                _buildSkillAttentionCard("Web Performance", "Weak", "15%", const Color(0xFFF9C8C8), const Color(0xFFD32F2F), Icons.warning_amber_rounded),
                const SizedBox(height: 12),
                _buildSkillAttentionCard("Testing (Jest)", "Weak", "30%", const Color(0xFFF9C8C8), const Color(0xFFD32F2F), Icons.warning_amber_rounded),
                const SizedBox(height: 12),
                _buildSkillAttentionCard("Accessibility", "Enough", "50%", const Color(0xFFFFE0A0), const Color(0xFFF57F17), Icons.remove_circle_outline),
                const SizedBox(height: 32),
                _buildSectionHeader(
                  "Your Achievement Progress",
                  onViewAll: () => context.go('/profile'),
                ),
                const SizedBox(height: 16),
                _buildAchievementList(),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    "Data from 2,847+ active job listings • Updated every 6 hours",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFFE5E7EB),
              child: Icon(Icons.person, color: Colors.grey, size: 32),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome back!", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                Text("John", style: AppTextStyles.heading1.copyWith(fontSize: 24)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, size: 28),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.menu, size: 28),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TextField(
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.grey, size: 28),
          hintText: "Search",
          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildReadinessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1046A0), // Deep blue from design
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Readiness Index today", style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text("63%", style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 48)),
              const SizedBox(height: 4),
              Text("Growing", style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Predicted role: Frontend Developer",
                  style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF1046A0), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Positioned(
            right: -20,
            top: -10,
            child: Icon(Icons.folder_copy, size: 120, color: Colors.white.withOpacity(0.2)), // Placeholder for illustration
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text("4%", style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1046A0), fontSize: 24)),
                const SizedBox(height: 4),
                Text("↑ Up form last week", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF1046A0))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text("+7", style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1046A0), fontSize: 24)),
                const SizedBox(height: 4),
                Text("↑ Poins today", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF1046A0))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading1.copyWith(fontSize: 18)),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text("View All", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          )
        else
          Text("View All", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSkillAttentionCard(String title, String subtitle, String percent, Color bgColor, Color iconColor, IconData icon) {
    double progress = double.tryParse(percent.replaceAll('%', '')) ?? 0.0;
    progress /= 100.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    color: iconColor,
                    strokeWidth: 4,
                  ),
                ),
                Center(
                  child: Text(percent, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementList() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _buildAchievementCard("Mar 8, 2026", "React Testing\nFundamentals", "Meta Front-End\nDeveloper (Module 5)", "30%", 0.3),
          const SizedBox(width: 16),
          _buildAchievementCard("Mar 2, 2026", "CSS Responsive\nMastery", "W3C FWD Certificate\n(Module 3)", "90%", 0.9),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String date, String title, String subtitle, String progressText, double progress) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE1F0FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.code, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Progress", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
              Text(progressText, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            color: const Color(0xFFFFA600),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
}
