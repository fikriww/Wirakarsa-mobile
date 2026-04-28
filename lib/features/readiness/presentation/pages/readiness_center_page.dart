import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ReadinessCenterPage extends StatefulWidget {
  final int initialTabIndex;
  const ReadinessCenterPage({super.key, this.initialTabIndex = 0});

  @override
  State<ReadinessCenterPage> createState() => _ReadinessCenterPageState();
}

class _ReadinessCenterPageState extends State<ReadinessCenterPage> {
  late int _selectedTabIndex;
  final List<String> _tabs = ["Overview", "Initial Test", "Skill Map", "Skill Gap"];

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'Readiness Center',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Analyze & measure your work readiness',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _buildTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildInitialTestTab();
      case 2:
        return _buildSkillMapTab();
      case 3:
        return _buildSkillGapTab();
      default:
        return _buildOverviewTab();
    }
  }

  // --- TAB 0: OVERVIEW ---
  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsGrid(),
        const SizedBox(height: 32),
        Text("CV Analysis", style: AppTextStyles.heading1.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        _buildDocumentAnalysisCard(
          "JohnDoeCV.pdf",
          "12 skills extracted, 3 experience entries detected. Your CV shows strong frontend focus but lacks backend and DevOps keywords.",
          "Re-Upload CV",
        ),
        const SizedBox(height: 32),
        Text("Academic Transcript Analysis", style: AppTextStyles.heading1.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        _buildDocumentAnalysisCard(
          "JohnDoeTranscript.pdf",
          "GPA 3.45/4.00 detected. Strong academic performance in Data Structures and Algorithms. Software Engineering coursework identified.",
          "Re-Upload Academic Transcript",
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () => context.push('/cv-screening'),
          child: _buildBlueBanner(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- TAB 1: INITIAL TEST ---
  Widget _buildInitialTestTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE1F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info, color: AppColors.primaryBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Initial competency test using static questions + standardized scoring rubric. Test results are used to measure your starting level and recommend the right learning path.",
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryBlue, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildTestTimelineItem(
          "PROG", "L3", "Programming / Software Development", "Designs, codes, verifies, tests, documents, amends and refactors programs/scripts...", true, "Restart Test",
          isFirst: true,
          onPressed: () => context.push('/readiness-center/initial-test'),
        ),
        _buildTestTimelineItem(
          "DTAN", "L2", "Data Analysis", "Applies data analysis, visualization and data modelling techniques...", true, "Restart Test",
          onPressed: () => context.push('/readiness-center/data-analysis-test'),
        ),
        _buildTestTimelineItem(
          "HCEV", "L3", "User Experience Design", "Produces design concepts and prototypes for user interactions and experiences...", false, "Start Test",
          onPressed: () => context.push('/readiness-center/ux-design-test'),
        ),
        _buildTestTimelineItem(
          "TEST", "L3", "Testing", "Plans, designs, manages, executes and reports tests using testing tools and...", false, "Start Test",
          isLast: true,
          onPressed: () => context.push('/readiness-center/testing-test'),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTestTimelineItem(String code, String level, String title, String desc, bool isCompleted, String buttonText, {bool isFirst = false, bool isLast = false, VoidCallback? onPressed}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  color: isFirst ? Colors.transparent : AppColors.divider,
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF1046A0) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF1046A0), width: 2),
                  ),
                  child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppColors.divider,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFE0A0), borderRadius: BorderRadius.circular(4)),
                        child: Text(code, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                      Text(level, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF1046A0), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(desc, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10, height: 1.5)),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onPressed ?? () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: SKILL MAP ---
  Widget _buildSkillMapTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Skill Map", style: AppTextStyles.heading1.copyWith(fontSize: 18)),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _SkillMapPainter(
                      values: [0.3, 0.15, 0.5, 0.85, 0.8, 0.83], // Matches the progress values below
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Skill Details", style: AppTextStyles.heading1.copyWith(fontSize: 18)),
              const SizedBox(height: 24),
              _buildSkillDetailRow("Testing (Jest)", "30%", "TEST L3 • Mar 9, 2026", 0.3, const Color(0xFFD32F2F)),
              _buildSkillDetailRow("Web Performance", "15%", "SINT L3 • Mar 5, 2026", 0.15, const Color(0xFFD32F2F)),
              _buildSkillDetailRow("Accessibility", "50%", "USEV L2 • Mar 4, 2026", 0.5, const Color(0xFFF57F17)),
              _buildSkillDetailRow("State Management", "85%", "PROG-SM L3 • Mar 6, 2026", 0.85, const Color(0xFF388E3C)),
              _buildSkillDetailRow("React.js", "80%", "PROG-SM L3 • Mar 6, 2026", 0.8, const Color(0xFF388E3C)),
              _buildSkillDetailRow("CSS/Tailwind", "83%", "PROG-SM L3 • Mar 6, 2026", 0.83, const Color(0xFF388E3C)),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSkillDetailRow(String title, String percentText, String subtitle, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              Text(percentText, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint, fontSize: 10)),
        ],
      ),
    );
  }

  // --- TAB 3: SKILL GAP ---
  Widget _buildSkillGapTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGapSectionHeader("Needs to Be Learned", const Color(0xFFD32F2F)),
        _buildGapCard("Testing (Jest)", "85% of job listings require this skill • Trend: Growing", "30%", const Color(0xFFF9C8C8), const Color(0xFFD32F2F)),
        _buildGapCard("Web Performance", "72% of job listings require this skill • Trend: Growing", "15%", const Color(0xFFF9C8C8), const Color(0xFFD32F2F)),
        
        const SizedBox(height: 24),
        _buildGapSectionHeader("Needs Improvement", const Color(0xFFF57F17)),
        _buildGapCard("Accessibility", "61% of job listings require this skill • Trend: Stable", "50%", const Color(0xFFFFE0A0), const Color(0xFFF57F17)),
        
        const SizedBox(height: 24),
        _buildGapSectionHeader("Already Strong", const Color(0xFF388E3C)),
        _buildGapCard("State Management", "68% of job listings require this skill • Trend: Stable", "85%", const Color(0xFFC8E6C9), const Color(0xFF388E3C)),
        _buildGapCard("React.js", "94% of job listings require this skill • Trend: Growing", "80%", const Color(0xFFC8E6C9), const Color(0xFF388E3C)),
        _buildGapCard("CSS/Tailwind", "78% of job listings require this skill • Trend: Growing", "83%", const Color(0xFFC8E6C9), const Color(0xFF388E3C)),
        
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Market Demand", style: AppTextStyles.heading1.copyWith(fontSize: 18)),
              const SizedBox(height: 24),
              _buildMarketDemandRow("React.js", 0.94, "94%"),
              const SizedBox(height: 16),
              _buildMarketDemandRow("TypeScript", 0.82, "82%"),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildGapSectionHeader(String title, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.heading1.copyWith(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildGapCard(String title, String subtitle, String percent, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
              ],
            ),
          ),
          Text(percent, style: AppTextStyles.heading1.copyWith(color: textColor, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildMarketDemandRow(String title, double progress, String percent) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 5,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            color: AppColors.primaryBlue,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 16),
        Text(percent, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // --- SHARED WIDGETS ---

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          bool isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBlue : AppColors.white,
                border: Border.all(color: AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _tabs[index],
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? AppColors.white : AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 24,
      crossAxisSpacing: 16,
      childAspectRatio: 2.5,
      children: [
        _buildStatItem(Icons.cloud_upload_outlined, const Color(0xFFE8EAF6), "63%", "Overall Readiness"),
        _buildStatItem(Icons.bar_chart, const Color(0xFFE8F5E9), "12", "Skills Mapped"),
        _buildStatItem(Icons.warning_amber_rounded, const Color(0xFFFFEBEE), "3", "Critical Gaps", iconColor: const Color(0xFFD32F2F)),
        _buildStatItem(Icons.check_circle_outline, const Color(0xFFE8F5E9), "3", "Strengths", iconColor: const Color(0xFF388E3C)),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, Color iconBgColor, String value, String label, {Color? iconColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primaryBlue, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 24)),
              Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentAnalysisCard(String filename, String description, String actionText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFE1F0FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.description, color: AppColors.primaryBlue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(filename, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Uploaded & Analyzed", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: AppColors.primaryBlue, size: 20),
                  const SizedBox(width: 8),
                  Text(actionText, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlueBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Check Your CV Now", style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF1046A0), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  "Curious how your CV performs in front of recruiters? Upload it and let AI give you instant insights and improvement tips.",
                  style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF1046A0)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.plagiarism_outlined, size: 64, color: Color(0xFF90CAF9)),
        ],
      ),
    );
  }
}

class _SkillMapPainter extends CustomPainter {
  final List<double> values;

  _SkillMapPainter({required this.values});

  final List<String> labels = [
    "Testing (Jest)",
    "Web Performance",
    "Accessibility",
    "State Management",
    "React.js",
    "CSS",
  ];

  final List<Color> dotColors = [
    const Color(0xFFD32F2F), // Testing
    const Color(0xFFD32F2F), // Web Performance
    const Color(0xFFF57F17), // Accessibility
    const Color(0xFF388E3C), // State Management
    const Color(0xFF388E3C), // React.js
    const Color(0xFF388E3C), // CSS
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.height / 2) - 40; // leave room for labels

    final outlinePaint = Paint()
      ..color = const Color(0xFFE1F0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillPaint = Paint()
      ..color = const Color(0xFF90CAF9).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF90CAF9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw concentric hexagons
    for (int i = 1; i <= 4; i++) {
      final path = Path();
      final r = radius * (i / 4);
      for (int j = 0; j < 6; j++) {
        final angle = j * (pi / 3) - (pi / 2);
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, outlinePaint);
    }

    // Draw axes
    for (int j = 0; j < 6; j++) {
      final angle = j * (pi / 3) - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), outlinePaint);
    }

    // Draw values polygon
    final valuePath = Path();
    for (int j = 0; j < 6; j++) {
      final angle = j * (pi / 3) - (pi / 2);
      final val = values[j];
      final r = radius * val;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (j == 0) {
        valuePath.moveTo(x, y);
      } else {
        valuePath.lineTo(x, y);
      }
    }
    valuePath.close();

    canvas.drawPath(valuePath, fillPaint);
    canvas.drawPath(valuePath, strokePaint);

    // Draw labels
    for (int j = 0; j < 6; j++) {
      final angle = j * (pi / 3) - (pi / 2);
      final labelRadius = radius + 15; // padding for label
      final labelX = center.dx + labelRadius * cos(angle);
      final labelY = center.dy + labelRadius * sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[j],
          style: const TextStyle(color: Color(0xFF757575), fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final dotPaint = Paint()
        ..color = dotColors[j]
        ..style = PaintingStyle.fill;

      double totalWidth = 12 + 8 + textPainter.width;
      double startX = labelX;
      double startY = labelY - textPainter.height / 2;

      if (cos(angle) > 0.1) {
        // Right side
        startX = labelX;
      } else if (cos(angle) < -0.1) {
        // Left side
        startX = labelX - totalWidth;
      } else {
        // Top/Bottom
        startX = labelX - totalWidth / 2;
        if (sin(angle) < 0) {
          startY = labelY - textPainter.height - 10;
        } else {
          startY = labelY + 10;
        }
      }

      canvas.drawCircle(
          Offset(startX + 6, startY + textPainter.height / 2), 6, dotPaint);
      textPainter.paint(canvas, Offset(startX + 12 + 8, startY));
    }
  }
  
  @override
  bool shouldRepaint(covariant _SkillMapPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

