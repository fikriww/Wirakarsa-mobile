import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final skillGapsAsync = ref.watch(skillGapProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardSummaryProvider);
            ref.invalidate(skillGapProvider);
            await ref.read(userProfileProvider.notifier).refreshProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userProfileAsync.when(
                    data: (user) => _buildHeader(user?.displayName ?? "User"),
                    loading: () => _buildHeader("Loading..."),
                    error: (_, __) => _buildHeader("User"),
                  ),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 32),
                  
                  summaryAsync.when(
                    data: (summary) => _buildReadinessCard(
                      score: summary['readinessScore']?.toString() ?? "0",
                      role: summary['role'] ?? "Career Seeker",
                    ),
                    loading: () => _buildReadinessCard(score: "...", role: "Loading...", isLoading: true),
                    error: (e, __) => _buildReadinessCard(score: "0", role: "Error loading profile"),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  summaryAsync.when(
                    data: (summary) => _buildStatsRow(
                      trend: summary['readinessTrend']?.toString() ?? "0%",
                      streak: summary['streak']?.toString() ?? "0",
                    ),
                    loading: () => _buildStatsRow(trend: "...", streak: "..."),
                    error: (e, __) => _buildStatsRow(trend: "0%", streak: "0"),
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    "Skills That Need Attention",
                    onViewAll: () => context.go('/readiness-center', extra: {'initialTabIndex': 3}),
                  ),
                  const SizedBox(height: 16),
                  
                  skillGapsAsync.when(
                    data: (gaps) {
                      // Filter for skills with current < 70 (Weak or Enough)
                      final attentionSkills = gaps.where((item) {
                        final current = (item['current'] as num?)?.toDouble() ?? 0.0;
                        return current < 70;
                      }).toList();

                      if (attentionSkills.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: Color(0xFF388E3C), size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Great job!", style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                                    Text("All your skills are strong and meet the required role threshold.", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF388E3C))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: attentionSkills.length.clamp(0, 3), // show top 3 maximum
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = attentionSkills[index];
                          final skillName = item['skill'] ?? "Unknown Skill";
                          final currentScore = (item['current'] as num?)?.toDouble() ?? 0.0;
                          
                          String statusStr = "Weak";
                          Color cardBg = const Color(0xFFFFF1F1);
                          Color textIconColor = const Color(0xFFD32F2F);
                          IconData attentionIcon = Icons.warning_amber_rounded;

                          if (currentScore >= 40) {
                            statusStr = "Enough";
                            cardBg = const Color(0xFFFFF9E6);
                            textIconColor = const Color(0xFFF57F17);
                            attentionIcon = Icons.remove_circle_outline;
                          }

                          return _buildSkillAttentionCard(
                            skillName,
                            statusStr,
                            "${currentScore.toStringAsFixed(0)}%",
                            cardBg,
                            textIconColor,
                            attentionIcon,
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, __) => Text("Failed to load skills: $e", style: const TextStyle(color: AppColors.error)),
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    "Your Achievement Progress",
                    onViewAll: () => context.go('/profile'),
                  ),
                  const SizedBox(height: 16),
                  _buildAchievementList(),
                  const SizedBox(height: 32),

                  // Quick Actions — mirrors web QuickActionsCard
                  _buildQuickActions(context),
                  const SizedBox(height: 24),

                  // Growth Progress — mirrors web GrowthProgressCard
                  _buildGrowthProgress(),
                  const SizedBox(height: 24),

                  // Continue Working — mirrors web ContinueWorkingCard
                  _buildContinueWorking(context),
                  const SizedBox(height: 32),

                  // Upcoming Tasks — mirrors web UpcomingTasks
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Upcoming Tasks",
                      style: AppTextStyles.heading1.copyWith(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildUpcomingTasks(context),
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
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _quickActionTile(
            context,
            Icons.shield_outlined,
            "Readiness Center",
            "/readiness-center",
            const Color(0xFF066EFF),
            const Color(0xFFEFF6FF),
          ),
          const SizedBox(height: 8),
          _quickActionTile(
            context,
            Icons.code_rounded,
            "Development Hub",
            "/devhub",
            const Color(0xFF10B981),
            const Color(0xFFECFDF5),
          ),
          const SizedBox(height: 8),
          _quickActionTile(
            context,
            Icons.work_outline_rounded,
            "Career Simulation",
            "/simulation",
            const Color(0xFFF59E0B),
            const Color(0xFFFFF7ED),
          ),
        ],
      ),
    );
  }

  Widget _quickActionTile(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    Color color,
    Color bg,
  ) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTasks(BuildContext context) {
    return Column(
      children: [
        _taskTile(
          icon: Icons.code_rounded,
          iconColor: const Color(0xFF10B981),
          iconBg: const Color(0xFFECFDF5),
          title: "REST API with Express",
          status: "In Progress — 65%",
          statusColor: const Color(0xFFF59E0B),
          progress: 0.65,
        ),
        const SizedBox(height: 12),
        _taskTile(
          icon: Icons.work_outline_rounded,
          iconColor: const Color(0xFFF97316),
          iconBg: const Color(0xFFFFF7ED),
          title: "Practice Interview",
          status: "Gojek · Software Engineer",
          statusColor: AppColors.textSecondary,
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => context.go('/readiness-center/initial-test'),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF5D6AF2), Color(0xFF066EFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.star_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Take Initial Assessment",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Boost your readiness accuracy",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String status,
    required Color statusColor,
    double? progress,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGrowthProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Growth Progress",
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "THIS MONTH",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _growthRing(12, 20, const Color(0xFF3B82F6), Icons.track_changes_rounded, "Skills Mapped"),
              _growthRing(3, 8, const Color(0xFF10B981), Icons.code_rounded, "Projects Done"),
              _growthRing(2, 5, const Color(0xFFF59E0B), Icons.work_outline_rounded, "Simulations"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _growthRing(int value, int total, Color color, IconData icon, String label) {
    final pct = total > 0 ? value / total : 0.0;
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: pct,
                    strokeWidth: 7,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Icon(icon, color: color, size: 22),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$value",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: "/$total",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueWorking(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF10B981), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Continue Working",
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _continueItem(context, Icons.code_rounded, const Color(0xFF10B981), const Color(0xFFECFDF5), "REST API with Express", "In Progress — Step 3 of 4", 0.75),
          const SizedBox(height: 12),
          _continueItem(context, Icons.work_outline_rounded, const Color(0xFFF59E0B), const Color(0xFFFFFBEB), "Interview at Gojek", "Recruiter Simulation", null),
          const SizedBox(height: 12),
          _continueItem(context, Icons.description_outlined, const Color(0xFF066EFF), const Color(0xFFEFF6FF), "AI Code Review", "Last review: 57/100", null),
        ],
      ),
    );
  }

  Widget _continueItem(BuildContext context, IconData icon, Color iconColor, Color iconBg, String title, String status, double? progress) {
    return InkWell(
      onTap: () => context.go('/devhub'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        status,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 16),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String displayName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFE5E7EB),
                child: Icon(Icons.person, color: Colors.grey, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome back!", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    Text(displayName, style: AppTextStyles.heading1.copyWith(fontSize: 22), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _buildReadinessCard({
    required String score,
    required String role,
    bool isLoading = false,
  }) {
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
              Text(isLoading ? score : "$score%", style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 48)),
              const SizedBox(height: 4),
              Text(isLoading ? "Analyzing..." : "Growing", style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Predicted role: $role",
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

  Widget _buildStatsRow({required String trend, required String streak}) {
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
                Text(trend, style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1046A0), fontSize: 24)),
                const SizedBox(height: 4),
                Text("↑ Up from last week", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF1046A0))),
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
                Text(streak, style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1046A0), fontSize: 24)),
                const SizedBox(height: 4),
                Text("Day streak today", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF1046A0))),
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
