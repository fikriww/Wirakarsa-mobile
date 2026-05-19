import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/models/code_review_model.dart';
import '../widgets/segment_button.dart';

class SubmitCodePage extends ConsumerStatefulWidget {
  const SubmitCodePage({super.key});

  @override
  ConsumerState<SubmitCodePage> createState() => _SubmitCodePageState();
}

class _SubmitCodePageState extends ConsumerState<SubmitCodePage> {
  final int _selectedIndex = 2;
  bool _isReviewed = false;
  bool _isLoading = false;
  final TextEditingController _codeController = TextEditingController();

  // Current active review results shown on the UI
  String _feedbackSummary = "";
  List<ReviewImprovement> _improvements = [];

  @override
  void initState() {
    super.initState();
    // Default initial template
    _codeController.text = 
      "import React from 'react';\n\n"
      "function CheckoutForm() {\n"
      "  var userData = fetchUser();\n"
      "  \n"
      "  function handleSubmit() {\n"
      "    console.log('Form submitted');\n"
      "    // Too many things done here...\n"
      "  }\n\n"
      "  return (\n"
      "    <form onSubmit={handleSubmit}>\n"
      "      <button type=\"submit\">Checkout</button>\n"
      "    </form>\n"
      "  );\n"
      "}\n\n"
      "export default CheckoutForm;";
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // Submit code for review and save in Firestore
  Future<void> _submitCodeReview() async {
    final text = _codeController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final userProfile = ref.read(userProfileProvider).value;
    final uid = userProfile?.uid ?? 'guest';
    final dbService = ref.read(dbServiceProvider);

    // 1. Generate smart dynamic feedback based on code content
    final lowerCode = text.toLowerCase();
    final improvements = <ReviewImprovement>[];

    if (lowerCode.contains("var ")) {
      improvements.add(ReviewImprovement(
        category: "Critical",
        text: "Avoid using 'var'. Use 'const' or 'let' instead to prevent hoisting issues and keep scope clean.",
      ));
    }
    if (lowerCode.contains("console.log")) {
      improvements.add(ReviewImprovement(
        category: "Warning",
        text: "Remove debug logs (console.log) in production JSX files to avoid data leak and performance penalties.",
      ));
    }
    if (!lowerCode.contains("describe(") && !lowerCode.contains("test(")) {
      improvements.add(ReviewImprovement(
        category: "Insight",
        text: "No unit tests found. Add a Jest & React Testing Library test suite (CheckoutForm.test.js) to assert submit handlers.",
      ));
    }
    
    improvements.add(ReviewImprovement(
      category: "Good",
      text: "Form markup matches semantically correct pattern and properly binds onSubmit event handler.",
    ));

    final summary = "Your checkout form implementation looks standard but can benefit from modern ES6 block-scoped variables and isolating logging side-effects.";

    final codeReview = CodeReview(
      id: '',
      userId: uid,
      projectId: 'react_testing_fundamentals',
      submittedCode: text,
      status: 'reviewed',
      createdAt: DateTime.now(),
      feedbackSummary: summary,
      improvements: improvements,
    );

    try {
      // 2. Save code review doc in Firestore database
      await dbService.submitCodeReview(codeReview);

      // 3. Update user profile skill metrics dynamically
      if (userProfile != null) {
        final currentSkills = Map<String, double>.from(userProfile.skills);
        // Award points towards Jest testing and performance
        currentSkills['Testing (Jest)'] = ((currentSkills['Testing (Jest)'] ?? 0.3) + 0.05).clamp(0.0, 1.0);
        currentSkills['Web Performance'] = ((currentSkills['Web Performance'] ?? 0.15) + 0.03).clamp(0.0, 1.0);
        await dbService.updateUserProfile(userProfile.uid, {
          'skills': currentSkills,
        });
      }

      setState(() {
        _isReviewed = true;
        _isLoading = false;
        _feedbackSummary = summary;
        _improvements = improvements;
      });
    } catch (e) {
      debugPrint("Error saving code review: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show previous code review submissions list from Firestore
  void _showReviewHistory() {
    final reviewsAsync = ref.read(userCodeReviewsProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Review History',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: reviewsAsync.when(
                data: (reviews) {
                  if (reviews.isEmpty) {
                    return const Center(
                      child: Text("No code review history found. Submit your first snippet!"),
                    );
                  }
                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, idx) {
                      final r = reviews[idx];
                      return ListTile(
                        leading: const Icon(Icons.code_rounded, color: AppColors.primaryBlue),
                        title: Text(
                          "Submission for React Testing Fundamentals",
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "Submitted: ${r.createdAt.hour}:${r.createdAt.minute} · Improvements: ${r.improvements.length}",
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textHint),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _codeController.text = r.submittedCode;
                            _isReviewed = true;
                            _feedbackSummary = r.feedbackSummary ?? "";
                            _improvements = r.improvements;
                          });
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, __) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/devhub');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: _showReviewHistory,
          ),
        ],
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'Development Hub',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Level up your skills and work readiness',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 100.0),
        child: Column(
          children: [
            Row(
              children: [
                SegmentButton(
                  label: "Mini Project",
                  isActive: false,
                  onTap: () {
                    if (context.canPop()) {
                      context.pop(true);
                    } else {
                      context.go('/devhub', extra: {'isCodeReviewActive': false});
                    }
                  },
                ),
                const SizedBox(width: 12),
                SegmentButton(
                  label: "Code Review",
                  isActive: true,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 25),
            // Header File
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFE2E8F0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attachment, size: 20, color: Colors.black54),
                  const SizedBox(width: 10),
                  const Text("CheckoutForm.jsx", style: TextStyle(fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF64748B), borderRadius: BorderRadius.circular(4)),
                    child: const Text("JSX", style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
              ),
            ),
            
            // Editor
            Container(
              height: 350,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: TextField(
                controller: _codeController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: Colors.white, 
                  fontFamily: 'monospace', 
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: "// Write your JSX checkout form code here...",
                  hintStyle: TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitCodeReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Review My Code", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            
            if (_isReviewed) ...[
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Review Results", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              if (_feedbackSummary.isNotEmpty) ...[
                Text(
                  _feedbackSummary,
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 16),
              ],
              ..._improvements.map((imp) {
                Color badgeColor = const Color(0xFF3B82F6);
                Color bgColor = const Color(0xFFBFDBFE);
                String location = "CheckoutForm.jsx";

                if (imp.category == "Critical") {
                  badgeColor = const Color(0xFFEF4444);
                  bgColor = const Color(0xFFFECACA);
                  location = "Line 4";
                } else if (imp.category == "Warning") {
                  badgeColor = const Color(0xFFF59E0B);
                  bgColor = const Color(0xFFFDE68A);
                  location = "Line 6";
                } else if (imp.category == "Good") {
                  badgeColor = const Color(0xFF10B981);
                  bgColor = const Color(0xFFA7F3D0);
                  location = "Line 10-12";
                }

                return _buildReviewCard(
                  type: imp.category,
                  badgeColor: badgeColor,
                  bgColor: bgColor,
                  location: location,
                  description: imp.text,
                );
              }),
              const SizedBox(height: 24),
              _buildSkillImpact(),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
      ),
    );
  }

  Widget _buildReviewCard({
    required String type,
    required Color badgeColor,
    required Color bgColor,
    required String location,
    required String description,
    String? codeSnippet,
    Color? codeBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                location,
                style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
          ),
          if (codeSnippet != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: codeBgColor ?? Colors.black12,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                codeSnippet,
                style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillImpact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Skill Impact from this Review", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Testing (Jest)", style: TextStyle(fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(4)),
                    child: Text("+5 pts", style: TextStyle(color: Colors.blue[700], fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Web Performance", style: TextStyle(fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(4)),
                    child: Text("+3 pts", style: TextStyle(color: Colors.blue[700], fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Applied after you fix & resubmit", style: TextStyle(color: Colors.black54, fontSize: 11, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ],
    );
  }
}
