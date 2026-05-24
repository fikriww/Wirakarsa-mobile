import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/api_service.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final ApiService _apiService = ApiService();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;
  bool _isSaving = false;

  // Form states
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _gradYearController = TextEditingController();

  // Selections for Screen 2
  final List<String> _selectedFeelings = [];
  final List<String> _selectedNeeds = [];
  final List<String> _selectedInterests = [];

  final List<String> _feelings = [
    "😞 Not confident in my skills",
    "🤯 Don't know where to start",
    "😓 Comparing myself to others",
    "⏳ Job hunting for a while",
    "🔄 No progress despite trying",
    "📉 Not getting job responses"
  ];

  final List<String> _needs = [
    "🧭 Know what skills I'm missing",
    "📄 Improve CV / portfolio",
    "🪄 Practice real projects",
    "🎯 Clear learning direction",
    "💬 Get feedback"
  ];

  final List<String> _interests = [
    "💻 Frontend",
    "🧠 Backend",
    "🎨 UI/UX",
    "📊 Data / AI",
    "🌱 Exploring",
    "🚀 Freelance"
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _majorController.dispose();
    _universityController.dispose();
    _gradYearController.dispose();
    super.dispose();
  }

  Future<void> _saveAssessmentData() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final session = await _apiService.getCurrentUser();
      final userId = session['result']['user']['id'];

      await _apiService.updateOnboardingProfile(
        userId: userId,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        university: _universityController.text.trim(),
        fieldOfStudy: _majorController.text.trim(),
        graduationYear: _gradYearController.text.trim(),
      );

      debugPrint('Assessment data saved successfully to Express backend!');
    } catch (e) {
      debugPrint('Error saving assessment data: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _nextStep() async {
    // Save data periodically or at specific steps
    if (_currentStep == 0 || _currentStep == 2 || _currentStep == _totalSteps - 1) {
      await _saveAssessmentData();
    }

    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Final step: Navigate to Dashboard (Home)
      context.go('/home');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe to force button usage
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [
                  _buildScreen1(),
                  _buildScreen2(),
                  _buildScreen3(),
                  _buildScreen4(),
                  _buildScreen5(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep ? const Color(0xFFFFA600) : AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // SCREEN 1
  Widget _buildScreen1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          Text(
            "Tell us about yourself",
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "We'll personalize your experience based on this",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("First Name", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: "e.g. Alex",
                        hintStyle: TextStyle(color: AppColors.textHint),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Last Name", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: "e.g. Rahman",
                        hintStyle: TextStyle(color: AppColors.textHint),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  // SCREEN 2
  Widget _buildScreen2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text("Hi, ${_firstNameController.text.isEmpty ? 'There' : _firstNameController.text}", style: AppTextStyles.heading1),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Tell us a bit about your situation.",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text("As an IT graduate, you might feel...", style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _feelings.map((e) => _buildChip(e, _selectedFeelings.contains(e), () {
                      setState(() {
                        if (_selectedFeelings.contains(e)) {
                          _selectedFeelings.remove(e);
                        } else {
                          _selectedFeelings.add(e);
                        }
                      });
                    })).toList(),
                  ),
                  const SizedBox(height: 32),
                  Text("What do you need right now?", style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _needs.map((e) => _buildChip(e, _selectedNeeds.contains(e), () {
                      setState(() {
                        if (_selectedNeeds.contains(e)) {
                          _selectedNeeds.remove(e);
                        } else {
                          _selectedNeeds.add(e);
                        }
                      });
                    })).toList(),
                  ),
                  const SizedBox(height: 32),
                  Text("Your Interest", style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interests.map((e) => _buildChip(e, _selectedInterests.contains(e), () {
                      setState(() {
                        if (_selectedInterests.contains(e)) {
                          _selectedInterests.remove(e);
                        } else {
                          _selectedInterests.add(e);
                        }
                      });
                    })).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Next'),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _previousStep,
              child: Text('Back', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : AppColors.white,
          border: Border.all(color: AppColors.primaryBlue, width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // SCREEN 3
  Widget _buildScreen3() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          Text(
            "Tell us about yourself",
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "So Wirapath can build a path that actually fits you.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Text("Your Major", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _majorController,
            decoration: InputDecoration(
              hintText: "Enter Your Major",
              hintStyle: TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          Text("University", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _universityController,
            decoration: InputDecoration(
              hintText: "e.g. Universitas Indonesia",
              hintStyle: TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          Text("Graduation Year", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _gradYearController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "e.g. 2025",
              hintStyle: TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Next'),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _previousStep,
              child: Text('Back', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // SCREEN 4
  Widget _buildScreen4() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Text(
            "Show us what you\nalready have.",
            style: AppTextStyles.heading1.copyWith(height: 1.3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Upload your CV and transcript so we can see your potential.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          _buildUploadField("Upload CV"),
          const SizedBox(height: 24),
          _buildUploadField("Upload Transcript"),
          const Spacer(),
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Next'),
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _nextStep,
              child: RichText(
                text: TextSpan(
                  text: "Don't have CV or transcript? No worries, ",
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: "Skip for now",
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _previousStep,
              child: Text('Back', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                ),
                child: Text(".pdf or .docx", style: TextStyle(color: AppColors.textHint)),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
              ),
              child: Text("Browse", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  // SCREEN 5
  Widget _buildScreen5() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          // Placeholder for GitHub Logo
          Center(
            child: SvgPicture.asset(
              'assets/icons/github.svg',
              height: 100,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "Got a GitHub?\nLet's see what you've built.",
            style: AppTextStyles.heading1.copyWith(height: 1.3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Connecting your GitHub gives Wirapath a real picture of your coding experience.\n\nNot just what you say you know, but what you've actually shipped.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              await _saveAssessmentData();
              if (mounted) context.go('/connect-github');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Connect GitHub Account'),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () async {
                await _saveAssessmentData();
                if (mounted) context.go('/home');
              },
              child: Text("Skip for now", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _previousStep,
              child: Text('Back', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
