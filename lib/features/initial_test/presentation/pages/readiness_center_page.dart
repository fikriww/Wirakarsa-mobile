import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/mock_initial_tests.dart';
import '../../domain/entities/initial_test_data.dart';
import '../../domain/entities/mock_test_results.dart';
import '../../domain/entities/test_result_data.dart';
import 'initial_test_page.dart';
import 'test_graded_page.dart';

class ReadinessCenterPage extends StatefulWidget {
  const ReadinessCenterPage({super.key});

  @override
  State<ReadinessCenterPage> createState() => _ReadinessCenterPageState();
}

class _ReadinessCenterPageState extends State<ReadinessCenterPage> {
  int _selectedTab = 1; // Default: Initial Test tab

  final List<String> _tabs = ['Overview', 'Initial Test', 'Skill Map', 'Skill Gap'];

  // Mock: which tests are "done" (Restart) vs not (Start)
  final List<bool> _testCompleted = [true, true, false, false];

  /// Maps index → corresponding TestResultData for completed tests
  final List<TestResultData?> _testResults = [
    programmingResult,
    dataAnalysisResult,
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Readiness Center',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Analyze & measure your work readiness',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 0.5, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          // Tab pills row
          _buildTabBar(),

          Expanded(
            child: _selectedTab == 1
                ? _buildInitialTestContent()
                : _buildPlaceholderTab(_tabs[_selectedTab]),
          ),
        ],
      ),
    );
  }

  /// Scrollable tab pills
  Widget _buildTabBar() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.asMap().entries.map((entry) {
            final isActive = entry.key == _selectedTab;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? AppColors.primaryBlue : AppColors.divider,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  entry.value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Initial Test tab content
  Widget _buildInitialTestContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Info banner
          _buildInfoBanner(),
          const SizedBox(height: 20),

          // Test cards with vertical timeline
          _buildTestTimeline(),
        ],
      ),
    );
  }

  /// Blue info banner at top of Initial Test
  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Initial competency test using static questions + standardized scoring rubric. Test results are used to measure your starting level and recommend the right learning path.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                height: 1.5,
                color: const Color(0xFF1E40AF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Test list with vertical timeline on the left
  Widget _buildTestTimeline() {
    final tests = allInitialTests;

    return Column(
      children: tests.asMap().entries.map((entry) {
        final index = entry.key;
        final test = entry.value;
        final isLast = index == tests.length - 1;
        final isDone = _testCompleted[index];

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Vertical connecting line
            if (!isLast)
              Positioned(
                top: 36, // Below the dot
                bottom: 0, // Stretch to the bottom of the card area
                left: 17, // Centered in the 36px wide left column (28 dot width)
                child: Container(
                  width: 2,
                  color: AppColors.divider,
                ),
              ),

            // Content row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: dot
                SizedBox(
                  width: 36,
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone ? AppColors.primaryBlue : Colors.transparent,
                          border: Border.all(
                            color: isDone ? AppColors.primaryBlue : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: isDone
                            ? const Icon(Icons.check, size: 15, color: AppColors.white)
                            : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Right: test card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildTestCard(index, test, isDone),
                  ),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }


  /// Individual test card
  Widget _buildTestCard(int index, InitialTestData test, bool isDone) {
    final result = _testResults[index];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge row + bookmark icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: test.badgeColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  test.badgeText,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: test.badgeTextColor,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.bookmark_border_rounded,
                size: 18,
                color: AppColors.textHint,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Test title
          Text(
            test.testTitle.replaceAll('\n', ' '),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          // Subtitle/description
          Text(
            test.testSubtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 14),

          // Action buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // View Results button (only if done)
              if (isDone && result != null) ...
                [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TestGradedPage(data: result),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(0, 34),
                    ),
                    child: Text(
                      'View Results',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

              // Start / Restart Test button
              SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => InitialTestPage(
                          data: test,
                          onSubmit: () {
                            Navigator.of(context).pop(); // Go back from test
                            final testResult = allTestResults[index];
                            
                            // Optional: Update state to mark as done
                            setState(() {
                              _testCompleted[index] = true;
                              _testResults[index] = testResult;
                            });

                            // Go to result page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TestGradedPage(data: testResult),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isDone ? 'Restart Test' : 'Start Test',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Placeholder for non-implemented tabs
  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_rounded, size: 48, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coming Soon',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
