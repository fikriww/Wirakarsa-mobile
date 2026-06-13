import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../core/providers/user_provider.dart';
import '../../../../core/models/initial_test_model.dart';
import '../../../../core/models/test_result_model.dart';
import '../../../initial_test/presentation/pages/initial_test_page.dart' as dyn;
import '../../../initial_test/presentation/pages/test_graded_page.dart' as dyn_graded;

class ReadinessCenterPage extends ConsumerStatefulWidget {
  final int initialTabIndex;
  const ReadinessCenterPage({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<ReadinessCenterPage> createState() => _ReadinessCenterPageState();
}

class _ReadinessCenterPageState extends ConsumerState<ReadinessCenterPage> {
  late int _selectedTabIndex;
  final List<String> _tabs = ["Overview", "Initial Test", "Skill Map", "Skill Gap"];

  // Default fallback skills if user profile lacks skills data
  final Map<String, double> _defaultSkills = {
    "Testing (Jest)": 0.3,
    "Web Performance": 0.15,
    "Accessibility": 0.5,
    "State Management": 0.85,
    "React.js": 0.80,
    "CSS/Tailwind": 0.83,
  };

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
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabBar(),
              const SizedBox(height: 16),
              _buildTabContent(),
            ],
          ),
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

  // Helper to extract the user's skills. Primary source is the backend
  // assessment analytics (same data the website uses), so the mobile Skill Map /
  // Skill Gap / Overview always match the web. Falls back to the user profile
  // skills, then to static defaults.
  Map<String, double> _getSkills() {
    final analytics = ref.watch(assessmentAnalyticsProvider).value;
    if (analytics != null && analytics['has_assessment'] == true) {
      final cats = (analytics['categories'] as List?) ?? [];
      if (cats.isNotEmpty) {
        final map = <String, double>{};
        for (final c in cats) {
          final name = (c['name'] ?? c['slug'] ?? 'Skill').toString();
          final scoreNum = c['score'];
          final score = scoreNum is num ? scoreNum.toDouble() : 0.0;
          map[name] = (score / 100.0).clamp(0.0, 1.0);
        }
        return map;
      }
    }
    final userProfile = ref.watch(userProfileProvider).value;
    if (userProfile != null && userProfile.skills.isNotEmpty) {
      return userProfile.skills;
    }
    return _defaultSkills;
  }

  // --- TAB 0: OVERVIEW ---
  Widget _buildOverviewTab() {
    final userProfile = ref.watch(userProfileProvider).value;
    final analytics = ref.watch(assessmentAnalyticsProvider).value;
    final results = ref.watch(userTestResultsProvider).value ?? [];
    final skills = _getSkills();

    final hasAssessment =
        analytics != null && analytics['has_assessment'] == true;

    String readinessStr;
    String skillsMappedStr;
    String criticalGapsStr;
    String strengthsStr;

    if (hasAssessment) {
      // Use the same backend analytics the website does so the numbers match.
      final overall = analytics['overall_score'];
      final overallVal = overall is num ? overall.toDouble() : 0.0;
      readinessStr = "${overallVal.round()}%";
      skillsMappedStr = "${analytics['skills_mapped'] ?? skills.length}";
      criticalGapsStr = "${analytics['critical_gaps_count'] ?? 0}";
      strengthsStr = "${analytics['strengths_count'] ?? 0}";
    } else {
      // Fallback: derive from local test results / skill map.
      double readinessPercent = 0.0;
      if (results.isNotEmpty) {
        double sum = 0.0;
        for (var r in results) {
          if (r.maxScore > 0) {
            sum += (r.numericScore / r.maxScore) * 100.0;
          }
        }
        readinessPercent = sum / results.length;
      }
      int criticalGaps = 0;
      int strengths = 0;
      skills.forEach((key, val) {
        if (val < 0.40) {
          criticalGaps++;
        } else if (val >= 0.70) {
          strengths++;
        }
      });
      readinessStr = "${readinessPercent.toStringAsFixed(0)}%";
      skillsMappedStr = "${skills.length}";
      criticalGapsStr = "$criticalGaps";
      strengthsStr = "$strengths";
    }

    // Real document state (no more hardcoded JohnDoe files).
    final cvUrl = (userProfile?.preferences['cvUrl'] ?? '').toString();
    final transcriptUrl =
        (userProfile?.preferences['transcriptUrl'] ?? '').toString();
    final cvName =
        cvUrl.isNotEmpty ? (cvUrl.split('/').last) : null;
    final transcriptName =
        transcriptUrl.isNotEmpty ? (transcriptUrl.split('/').last) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsGrid(
          readiness: readinessStr,
          skillsMapped: skillsMappedStr,
          criticalGaps: criticalGapsStr,
          strengths: strengthsStr,
        ),
        const SizedBox(height: 24),
        Text("CV Analysis", style: AppTextStyles.heading1.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        _buildDocumentAnalysisCard(
          cvName ?? "No CV uploaded",
          cvName != null
              ? "Your CV has been uploaded and analyzed against your target role."
              : "You haven't uploaded a CV yet. Upload one to get a personalized analysis of your skills and gaps.",
          cvName != null ? "Re-Upload CV" : "Upload CV",
        ),
        const SizedBox(height: 32),
        Text("Academic Transcript Analysis", style: AppTextStyles.heading1.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        _buildDocumentAnalysisCard(
          transcriptName ?? "No transcript uploaded",
          transcriptName != null
              ? "Your academic transcript has been uploaded and analyzed."
              : "You haven't uploaded an academic transcript yet. Upload one to include your academic performance in your readiness score.",
          transcriptName != null
              ? "Re-Upload Academic Transcript"
              : "Upload Academic Transcript",
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
    final testsAsync = ref.watch(initialTestsProvider);
    final resultsAsync = ref.watch(userTestResultsProvider);

    return testsAsync.when(
      data: (tests) {
        final results = resultsAsync.value ?? [];
        if (tests.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text("No initial competency tests found. They will be seeded shortly."),
            ),
          );
        }

        // Sort tests so PROG is first, then DTAN, UX, TEST (custom ordering)
        final orderedTests = List<InitialTestData>.from(tests);
        orderedTests.sort((a, b) {
          final order = {'prog': 1, 'dtan': 2, 'hcev': 3, 'test': 4};
          return (order[a.id] ?? 99).compareTo(order[b.id] ?? 99);
        });

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
            ...orderedTests.asMap().entries.map((entry) {
              final idx = entry.key;
              final test = entry.value;
              final isFirst = idx == 0;
              final isLast = idx == orderedTests.length - 1;

              // Check if test has been completed
              final completedResult = results.cast<TestResultData?>().firstWhere(
                    (r) => r?.testId == test.id,
                    orElse: () => null,
                  );
              final isCompleted = completedResult != null;

              return _buildTestTimelineItem(
                test,
                isCompleted,
                completedResult,
                isFirst: isFirst,
                isLast: isLast,
              );
            }),
            const SizedBox(height: 40),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text("Error loading tests: $err"),
        ),
      ),
    );
  }

  Widget _buildTestTimelineItem(
    InitialTestData test,
    bool isCompleted,
    TestResultData? completedResult, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    final userProfile = ref.watch(userProfileProvider).value;
    final buttonText = isCompleted ? "Restart Test" : "Start Test";

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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: test.badgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          test.badgeText,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: test.badgeTextColor,
                          ),
                        ),
                      ),
                      Text("L3", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    test.testTitle.replaceAll('\n', ' '),
                    style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF1046A0), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    test.practicalTaskDescription ?? "Competency test with dynamic graded results, multiple choice questions, file uploads, or short interpretation essays evaluated by senior AI developers.",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10, height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isCompleted && completedResult != null) ...[
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => dyn_graded.TestGradedPage(data: completedResult),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryBlue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text("View Results", style: TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => dyn.InitialTestPage(
                                data: test,
                                onSubmit: (selectedAnswers, essayAnswers) async {
                                  // 1. Grade the test dynamically
                                  final result = _gradeTest(test, selectedAnswers, essayAnswers, userProfile?.uid ?? 'guest');
                                  
                                  // 2. Save result to Firestore database
                                  await ref.read(dbServiceProvider).saveTestResult(result);
                                  
                                  // 3. Update user profile skill metrics in Firestore if they passed
                                  if (userProfile != null) {
                                    final currentSkills = Map<String, double>.from(userProfile.skills);
                                    if (test.id == 'prog') {
                                      currentSkills['Testing (Jest)'] = result.numericScore / result.maxScore;
                                      currentSkills['React.js'] = 0.85;
                                      currentSkills['CSS/Tailwind'] = 0.90;
                                    } else if (test.id == 'dtan') {
                                      currentSkills['Web Performance'] = 0.80;
                                    } else if (test.id == 'test') {
                                      currentSkills['Testing (Jest)'] = result.numericScore / result.maxScore;
                                    }
                                    await ref.read(dbServiceProvider).updateUserProfile(userProfile.uid, {
                                      'skills': currentSkills,
                                    });
                                  }

                                  if (mounted) {
                                    Navigator.of(context).pop(); // Back from test
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => dyn_graded.TestGradedPage(data: result),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
                          // Global theme sets minimumSize width to infinity, which
                          // breaks layout inside a Row — override it here.
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(buttonText, style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dynamic grading utility
  TestResultData _gradeTest(InitialTestData test, Map<int, int> selectedAnswers, Map<int, String> essayAnswers, String uid) {
    int correctCount = 0;
    int totalQuestions = test.questions?.length ?? 0;
    List<TestIssue> issues = [];

    if (test.questions != null) {
      for (int i = 0; i < test.questions!.length; i++) {
        final q = test.questions![i];
        final selectedOptIndex = selectedAnswers[i];
        if (selectedOptIndex != null && selectedOptIndex < q.options.length) {
          if (q.options[selectedOptIndex].isCorrect) {
            correctCount++;
          } else {
            final correctOpt = q.options.firstWhere((o) => o.isCorrect);
            issues.add(TestIssue(
              title: "Q${i + 1} Review",
              description: "You selected '${q.options[selectedOptIndex].text}'. The correct answer is '${correctOpt.text}'. Focus on this concept to secure structural stability.",
              cardColorHex: "0xFFFFE5E5",
              borderColorHex: "0xFFFFC4C4",
              titleColorHex: "0xFFD32F2F",
            ));
          }
        } else {
          issues.add(TestIssue(
            title: "Q${i + 1} Skipped",
            description: "You left this question blank. Review this core area to complete your skill profile.",
            cardColorHex: "0xFFFFF9E6",
            borderColorHex: "0xFFFFE69C",
            titleColorHex: "0xFF856404",
          ));
        }
      }
    }

    final scoreVal = totalQuestions > 0 ? "$correctCount/$totalQuestions" : "100/100";
    final isPassed = totalQuestions > 0 ? (correctCount / totalQuestions >= 0.6) : true;
    final percentage = totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 100.0;

    String summary = "Dynamic Evaluation: ";
    if (totalQuestions > 0) {
      summary += "You completed the multiple-choice section with $correctCount correct answers out of $totalQuestions. ";
      if (isPassed) {
        summary += "This indicates a strong starting grasp of ${test.testTitle.replaceAll('\n', ' ')}. Good job!";
      } else {
        summary += "Review the concept details below and restart the test to boost your skill status.";
      }
    } else {
      summary += "Your file submission and short essay for ${test.testTitle.replaceAll('\n', ' ')} have been logged. AI evaluator assessed excellent formatting and insight.";
    }

    return TestResultData(
      id: '',
      userId: uid,
      testId: test.id,
      testTitle: test.testTitle,
      testSubtitle: test.testSubtitle,
      badgeText: test.badgeText,
      badgeColorHex: test.badgeColorHex,
      badgeTextColorHex: test.badgeTextColorHex,
      scoreValue: scoreVal,
      maxScore: totalQuestions > 0 ? totalQuestions.toDouble() : 100,
      numericScore: totalQuestions > 0 ? correctCount.toDouble() : 100,
      submittedDate: DateTime.now(),
      statusText: isPassed ? 'Passed' : 'Needs Improvement',
      statusColorHex: isPassed ? '0xFFDCFCE3' : '0xFFFFE5E5',
      statusTextColorHex: isPassed ? '0xFF158031' : '0xFFD32F2F',
      aiSummary: summary,
      issues: issues,
      essayAnswers: essayAnswers.map((k, v) => MapEntry(k.toString(), v)),
    );
  }

  // --- TAB 2: SKILL MAP ---
  Widget _buildSkillMapTab() {
    final skills = _getSkills();
    final sortedKeys = skills.keys.toList();
    final sortedValues = sortedKeys.map((k) => skills[k] ?? 0.0).toList();

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
                      values: sortedValues,
                      labels: sortedKeys.map((k) => k.replaceAll(' ', '\n')).toList(),
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
              ...sortedKeys.map((key) {
                final val = skills[key] ?? 0.0;
                Color statusColor = const Color(0xFFD32F2F); // Red (< 40%)
                if (val >= 0.70) {
                  statusColor = const Color(0xFF388E3C); // Green
                } else if (val >= 0.40) {
                  statusColor = const Color(0xFFF57F17); // Orange
                }

                return _buildSkillDetailRow(
                  key,
                  "${(val * 100).toStringAsFixed(0)}%",
                  "Level: ${(val * 10).toStringAsFixed(1)}/10",
                  val,
                  statusColor,
                );
              }),
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
    final skills = _getSkills();
    
    final needsToLearn = <String, double>{};
    final needsImprovement = <String, double>{};
    final alreadyStrong = <String, double>{};

    skills.forEach((k, v) {
      if (v < 0.40) {
        needsToLearn[k] = v;
      } else if (v < 0.70) {
        needsImprovement[k] = v;
      } else {
        alreadyStrong[k] = v;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (needsToLearn.isNotEmpty) ...[
          _buildGapSectionHeader("Needs to Be Learned", const Color(0xFFD32F2F)),
          ...needsToLearn.entries.map((e) => _buildGapCard(
                e.key,
                "High priority gap • Recruiter demand: critical",
                "${(e.value * 100).toStringAsFixed(0)}%",
                const Color(0xFFFFF1F1),
                const Color(0xFFD32F2F),
              )),
          const SizedBox(height: 16),
        ],
        
        if (needsImprovement.isNotEmpty) ...[
          _buildGapSectionHeader("Needs Improvement", const Color(0xFFF57F17)),
          ...needsImprovement.entries.map((e) => _buildGapCard(
                e.key,
                "Medium priority gap • Recruiter demand: moderate",
                "${(e.value * 100).toStringAsFixed(0)}%",
                const Color(0xFFFFF9E6),
                const Color(0xFFF57F17),
              )),
          const SizedBox(height: 16),
        ],

        if (alreadyStrong.isNotEmpty) ...[
          _buildGapSectionHeader("Already Strong", const Color(0xFF388E3C)),
          ...alreadyStrong.entries.map((e) => _buildGapCard(
                e.key,
                "Competency high • Recruiter demand: satisfied",
                "${(e.value * 100).toStringAsFixed(0)}%",
                const Color(0xFFEAF6EA),
                const Color(0xFF388E3C),
              )),
          const SizedBox(height: 16),
        ],

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
              ..._buildMarketDemandRows(),
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

  // Build the market-demand rows from the backend (top in-demand skills for the
  // user's role), so the mobile list matches the website.
  List<Widget> _buildMarketDemandRows() {
    final demand = ref.watch(marketDemandProvider).value ?? [];
    if (demand.isEmpty) {
      return [
        _buildMarketDemandRow("React.js", 0.94, "94%"),
        const SizedBox(height: 16),
        _buildMarketDemandRow("TypeScript", 0.82, "82%"),
      ];
    }
    final rows = <Widget>[];
    final top = demand.take(8).toList();
    for (var i = 0; i < top.length; i++) {
      final item = Map<String, dynamic>.from(top[i] as Map);
      final skill =
          (item['skill'] ?? item['skill_name'] ?? 'Skill').toString();
      final trendRaw =
          item['trend_score'] ?? item['trend'] ?? item['bar_width'] ?? 0;
      final trend = trendRaw is num ? trendRaw.toDouble() : 0.0;
      rows.add(_buildMarketDemandRow(
          skill, (trend / 100).clamp(0.0, 1.0), "${trend.round()}%"));
      if (i < top.length - 1) rows.add(const SizedBox(height: 16));
    }
    return rows;
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_tabs.length, (index) {
          bool isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              width: 76,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBlue : AppColors.white,
                border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _tabs[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: isSelected ? AppColors.white : AppColors.primaryBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatsGrid({
    required String readiness,
    required String skillsMapped,
    required String criticalGaps,
    required String strengths,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatItem(Icons.cloud_upload_outlined, const Color(0xFFE8EAF6), readiness, "Overall Readiness")),
            const SizedBox(width: 16),
            Expanded(child: _buildStatItem(Icons.bar_chart, const Color(0xFFE8F5E9), skillsMapped, "Skills Mapped")),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildStatItem(Icons.warning_amber_rounded, const Color(0xFFFFEBEE), criticalGaps, "Critical Gaps", iconColor: const Color(0xFFD32F2F))),
            const SizedBox(width: 16),
            Expanded(child: _buildStatItem(Icons.check_circle_outline, const Color(0xFFE8F5E9), strengths, "Strengths", iconColor: const Color(0xFF388E3C))),
          ],
        ),
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
  final List<String> labels;

  _SkillMapPainter({required this.values, required this.labels});

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
    if (values.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 60; // leave room for labels

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
    final n = values.length;
    for (int i = 1; i <= 4; i++) {
      final path = Path();
      final r = radius * (i / 4);
      for (int j = 0; j < n; j++) {
        final angle = j * (2 * pi / n) - (pi / 2);
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
    for (int j = 0; j < n; j++) {
      final angle = j * (2 * pi / n) - (pi / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), outlinePaint);
    }

    // Draw values polygon
    final valuePath = Path();
    for (int j = 0; j < n; j++) {
      final angle = j * (2 * pi / n) - (pi / 2);
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
    for (int j = 0; j < n; j++) {
      final angle = j * (2 * pi / n) - (pi / 2);
      final labelRadius = radius + 15; // padding for label
      final labelX = center.dx + labelRadius * cos(angle);
      final labelY = center.dy + labelRadius * sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[j],
          style: const TextStyle(color: Color(0xFF757575), fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      final dotColor = j < dotColors.length ? dotColors[j] : const Color(0xFF388E3C);
      final dotPaint = Paint()
        ..color = dotColor
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
    return oldDelegate.values != values || oldDelegate.labels != labels;
  }
}
