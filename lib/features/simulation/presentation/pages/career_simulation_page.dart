import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/voice_chat_bubble.dart';
import '../widgets/simulation_option_card.dart';
import '../widgets/company_scenario_card.dart';
import '../widgets/job_listing_card.dart';
import '../widgets/quick_reply_chips.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/salary_scenario_card.dart';
import '../widgets/skill_breakdown_bar.dart';
import '../widgets/recommendation_card.dart';
import 'voice_mode_page.dart';
import 'job_analysis_page.dart';

enum SimulationState {
  initial, // 3 option cards
  careerScenarios, // company scenario cards
  careerChat, // Figma file message + quick replies
  salaryScenarios, // NEW: company salary level cards
  salaryChat, // HR salary message + quick replies
  jobdeskAnalyzer, // job listing cards
  jobdeskAnalyzerChat, // AI analysis message + quick replies
}

class CareerSimulationPage extends StatefulWidget {
  const CareerSimulationPage({super.key});

  @override
  State<CareerSimulationPage> createState() => _CareerSimulationPageState();
}

class _CareerSimulationPageState extends State<CareerSimulationPage> {
  final _chatController = TextEditingController();
  SimulationState _currentState = SimulationState.initial;

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _goToState(SimulationState state) {
    setState(() => _currentState = state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () {
            switch (_currentState) {
              case SimulationState.careerScenarios:
              case SimulationState.salaryScenarios:
              case SimulationState.jobdeskAnalyzer:
                _goToState(SimulationState.initial);
                break;
              case SimulationState.careerChat:
                _goToState(SimulationState.careerScenarios);
                break;
              case SimulationState.salaryChat:
                _goToState(SimulationState.salaryScenarios);
                break;
              case SimulationState.jobdeskAnalyzerChat:
                _goToState(SimulationState.jobdeskAnalyzer);
                break;
              case SimulationState.initial:
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
                break;
            }
          },
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Career Simulation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Career Simulation AI Mentor',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => _goToState(SimulationState.initial),
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: Column(
        children: [
          // Chat area
          Expanded(child: _buildChatContent()),

          // Quick reply chips (shown in certain states)
          if (_currentState == SimulationState.careerChat)
            QuickReplyChips(
              replies: [
                "What's the right approach?",
                "I'm not sure where to start",
              ],
              onTap: (reply) {},
            ),
          if (_currentState == SimulationState.salaryChat)
            QuickReplyChips(
              replies: [
                'Is the salary negotiable?',
                'I am expecting around 12 million IDR/month',
              ],
              onTap: (reply) {},
            ),
          if (_currentState == SimulationState.jobdeskAnalyzerChat)
            QuickReplyChips(
              replies: ['How to improve TypeScript?', 'Start mock interview'],
              onTap: (reply) {},
            ),

          // Chat input
          ChatInputField(
            controller: _chatController,
            showTimer:
                _currentState == SimulationState.careerChat ||
                _currentState == SimulationState.salaryChat ||
                _currentState == SimulationState.jobdeskAnalyzerChat,
            timerText: '05:00',
            onSend: () {
              _chatController.clear();
            },
            onMicTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const VoiceModePage()),
              );
            },
            onAskTap: () => _showAskOptions(context),
            onRepositoriesTap: () => _showRepositories(context),
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  void _showAskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Interesting Questions',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildOptionTile('How should I negotiate for a higher salary?'),
            _buildOptionTile(
              'What are the red flags to look for in a startup?',
            ),
            _buildOptionTile('Can you explain state management simply?'),
            _buildOptionTile('How to transition from Junior to Mid level?'),
          ],
        ),
      ),
    );
  }

  void _showRepositories(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Conversation History',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildOptionTile(
              'Mock Interview: Tokopedia (Frontend) - Yesterday',
            ),
            _buildOptionTile(
              'Salary Negotiation: Startup Fintech - 3 days ago',
            ),
            _buildOptionTile('Career Advice: EdTech - Last week'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(String text) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildChatContent() {
    switch (_currentState) {
      case SimulationState.initial:
        return _buildInitialState();
      case SimulationState.careerScenarios:
        return _buildCareerScenarios();
      case SimulationState.careerChat:
        return _buildCareerChat();
      case SimulationState.salaryScenarios:
        return _buildSalaryScenarios();
      case SimulationState.salaryChat:
        return _buildSalaryChat();
      case SimulationState.jobdeskAnalyzer:
        return _buildJobdeskAnalyzer();
      case SimulationState.jobdeskAnalyzerChat:
        return _buildJobdeskAnalyzerChat();
    }
  }

  /// State 1: Initial - 3 simulation options
  Widget _buildInitialState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const ChatBubble(
          message:
              'Hello! I\'m your AI Mentor. Choose the simulation you\'d like to practice today',
          time: '12:49 AM',
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 46),
          child: Column(
            children: [
              SimulationOptionCard(
                icon: Icons.work_outline_rounded,
                label: 'Career Simulation',
                onTap: () => _goToState(SimulationState.careerScenarios),
              ),
              SimulationOptionCard(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Salary Negotiation',
                onTap: () => _goToState(SimulationState.salaryScenarios),
              ),
              SimulationOptionCard(
                icon: Icons.search_rounded,
                label: 'Jobdesk Analyzer',
                onTap: () => _goToState(SimulationState.jobdeskAnalyzer),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// State 2: Career Simulation - Company scenario selection
  Widget _buildCareerScenarios() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const ChatBubble(
          message: 'Select a company scenario for Career Simulation.',
          time: '12:49 AM',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 46),
          child: Column(
            children: [
              CompanyScenarioCard(
                companyName: 'EduNext (EdTech)',
                role: 'Junior Frontend Developer',
                focus: 'CSS/Tailwind',
                level: 'Junior',
                onTap: () => _goToState(SimulationState.careerChat),
              ),
              CompanyScenarioCard(
                companyName: 'TokoBuild (E-commerce)',
                role: 'Frontend Developer',
                focus: 'Web Performance',
                level: 'Mid',
                onTap: () => _goToState(SimulationState.careerChat),
              ),
              CompanyScenarioCard(
                companyName: 'HealthConnect (HealthTech)',
                role: 'Junior Frontend Developer',
                focus: 'Accessibility',
                level: 'Junior',
                onTap: () => _goToState(SimulationState.careerChat),
              ),
              CompanyScenarioCard(
                companyName: 'DataFlow (SaaS Analytics)',
                role: 'Frontend Developer',
                focus: 'State Management',
                level: 'Mid',
                onTap: () => _goToState(SimulationState.careerChat),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// State 3: Career Chat - Figma file message with voice
  Widget _buildCareerChat() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        VoiceChatBubble(
          message:
              'The designer sent a Figma file:\n\n"Budi, here is the responsive mockup for the class page. Breakpoints: mobile (375px), tablet (768px), desktop (1440px). Please implement according to the spec, prioritizing mobile-first."',
          time: '12:49 AM',
          onVoiceTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const VoiceModePage()));
          },
        ),
      ],
    );
  }

  /// State 3.5: Salary Scenarios - Company level selection
  Widget _buildSalaryScenarios() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const ChatBubble(
          message: 'Choose the company level for Salary Negotiation:',
          time: '12:49 AM',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 46),
          child: Column(
            children: [
              SalaryScenarioCard(
                companyName: 'Startup Fintech',
                salaryRange: '4-6M/month',
                level: 'Junior',
                onTap: () => _goToState(SimulationState.salaryChat),
              ),
              SalaryScenarioCard(
                companyName: 'Unicorn E-commerce',
                salaryRange: '8-12M/month',
                level: 'Mid',
                onTap: () => _goToState(SimulationState.salaryChat),
              ),
              SalaryScenarioCard(
                companyName: 'Enterprise Bank',
                salaryRange: '12-18M/month',
                level: 'Mid - Senior',
                onTap: () => _goToState(SimulationState.salaryChat),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// State 4: Salary Negotiation - HR message
  Widget _buildSalaryChat() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        VoiceChatBubble(
          message:
              'I am the HR Manager from Startup Fintech. We are offering 4-6m/month for this Junior position. What are your salary expectations?',
          time: '12:49 AM',
          onVoiceTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const VoiceModePage()));
          },
        ),
      ],
    );
  }

  /// Navigate to the full Job Analysis page
  void _openJobAnalysis(JobAnalysisData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JobAnalysisPage(jobData: data),
      ),
    );
  }

  /// State 5: Jobdesk Analyzer - Job listing cards
  Widget _buildJobdeskAnalyzer() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const ChatBubble(
          message:
              'I found several job listings matching your profile from LinkedIn, Jobstreet, and Glints. Tap "Analyze Job" to see a detailed skill match analysis.',
          time: '12:49 AM',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 46),
          child: Column(
            children: [
              JobListingCard(
                jobTitle: 'Frontend Developer',
                company: 'Gojek',
                location: 'Jakarta',
                source: 'LinkedIn',
                matchPercent: 80,
                skills: const [
                  SkillTag(name: 'ReactJS'),
                  SkillTag(name: 'TypeScript', isMatched: false),
                  SkillTag(name: 'Tailwind CSS'),
                  SkillTag(name: 'Web Performance'),
                ],
                salary: '8-15 M/month',
                postedTime: '1 day ago',
                experienceLevel: 'Entry-Mid',
                onAnalyze: () => _openJobAnalysis(
                  JobAnalysisData(
                    jobTitle: 'Frontend Developer',
                    company: 'Gojek',
                    location: 'Jakarta, Indonesia',
                    source: 'LinkedIn',
                    matchPercent: 80,
                    salary: '8-15 M/month',
                    postedTime: '1 day ago',
                    experienceLevel: 'Entry-Mid Level',
                    jobDescription:
                        'We are looking for a Frontend Developer to join our product team. '
                        'You will be responsible for building responsive, high-performance web '
                        'applications using React and TypeScript. Collaborate with designers '
                        'and backend engineers to deliver world-class user experiences for '
                        'millions of users across Southeast Asia.',
                    requiredSkills: const [
                      SkillTag(name: 'ReactJS'),
                      SkillTag(name: 'TypeScript', isMatched: false),
                      SkillTag(name: 'Tailwind CSS'),
                      SkillTag(name: 'Web Performance'),
                    ],
                    skillBreakdown: const [
                      SkillProficiency(name: 'ReactJS', percentage: 85),
                      SkillProficiency(name: 'Tailwind CSS', percentage: 80),
                      SkillProficiency(name: 'Web Performance', percentage: 65),
                      SkillProficiency(name: 'TypeScript', percentage: 30, isMatched: false),
                    ],
                    recommendations: const [
                      LearningRecommendation(
                        skillName: 'TypeScript',
                        description: 'Master type safety, generics, and advanced patterns used in production React codebases.',
                        estimatedTime: '3-4 weeks',
                        difficulty: 'Intermediate',
                        icon: Icons.code,
                      ),
                      LearningRecommendation(
                        skillName: 'Web Performance',
                        description: 'Learn Core Web Vitals, lazy loading, code splitting, and performance profiling.',
                        estimatedTime: '2-3 weeks',
                        difficulty: 'Intermediate',
                        icon: Icons.speed,
                      ),
                    ],
                  ),
                ),
              ),
              JobListingCard(
                jobTitle: 'React Developer',
                company: 'Tokopedia',
                location: 'Jakarta',
                source: 'Jobstreet',
                matchPercent: 60,
                skills: const [
                  SkillTag(name: 'ReactJS'),
                  SkillTag(name: 'Redux', isMatched: false),
                  SkillTag(name: 'Unit Testing', isMatched: false),
                  SkillTag(name: 'CSS-in-JS'),
                  SkillTag(name: 'Accessibility'),
                ],
                salary: '10-18 M/month',
                postedTime: '2 days ago',
                experienceLevel: 'Mid',
                onAnalyze: () => _openJobAnalysis(
                  JobAnalysisData(
                    jobTitle: 'React Developer',
                    company: 'Tokopedia',
                    location: 'Jakarta, Indonesia',
                    source: 'Jobstreet',
                    matchPercent: 60,
                    salary: '10-18 M/month',
                    postedTime: '2 days ago',
                    experienceLevel: 'Mid Level',
                    jobDescription:
                        'Join our core commerce team to build scalable e-commerce '
                        'interfaces. Strong knowledge of Redux for state management '
                        'and unit testing with Jest is required. You will work on '
                        'accessible, high-traffic product pages serving millions of daily users.',
                    requiredSkills: const [
                      SkillTag(name: 'ReactJS'),
                      SkillTag(name: 'Redux', isMatched: false),
                      SkillTag(name: 'Unit Testing', isMatched: false),
                      SkillTag(name: 'CSS-in-JS'),
                      SkillTag(name: 'Accessibility'),
                    ],
                    skillBreakdown: const [
                      SkillProficiency(name: 'ReactJS', percentage: 85),
                      SkillProficiency(name: 'CSS-in-JS', percentage: 70),
                      SkillProficiency(name: 'Accessibility', percentage: 55),
                      SkillProficiency(name: 'Redux', percentage: 20, isMatched: false),
                      SkillProficiency(name: 'Unit Testing', percentage: 15, isMatched: false),
                    ],
                    recommendations: const [
                      LearningRecommendation(
                        skillName: 'Redux & State Management',
                        description: 'Learn Redux Toolkit, middleware patterns, and async state management with thunks.',
                        estimatedTime: '2-3 weeks',
                        difficulty: 'Intermediate',
                        icon: Icons.account_tree,
                      ),
                      LearningRecommendation(
                        skillName: 'Unit Testing (Jest)',
                        description: 'Master Jest, React Testing Library, mocking, and test-driven development practices.',
                        estimatedTime: '2 weeks',
                        difficulty: 'Beginner',
                        icon: Icons.bug_report_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              JobListingCard(
                jobTitle: 'UI Engineer',
                company: 'Traveloka',
                location: 'Jakarta',
                source: 'Glints',
                matchPercent: 72,
                skills: const [
                  SkillTag(name: 'ReactJS'),
                  SkillTag(name: 'CSS/SCSS'),
                  SkillTag(name: 'Design System'),
                  SkillTag(name: 'Figma', isMatched: false),
                ],
                salary: '12-20 M/month',
                postedTime: '3 days ago',
                experienceLevel: 'Mid-Senior',
                onAnalyze: () => _openJobAnalysis(
                  JobAnalysisData(
                    jobTitle: 'UI Engineer',
                    company: 'Traveloka',
                    location: 'Jakarta, Indonesia',
                    source: 'Glints',
                    matchPercent: 72,
                    salary: '12-20 M/month',
                    postedTime: '3 days ago',
                    experienceLevel: 'Mid-Senior Level',
                    jobDescription:
                        'As a UI Engineer you will own the design system and component '
                        'library for our travel platform. Deep expertise in CSS architecture, '
                        'responsive design, and Figma-to-code workflows is essential. '
                        'Collaborate with product designers to ship pixel-perfect interfaces.',
                    requiredSkills: const [
                      SkillTag(name: 'ReactJS'),
                      SkillTag(name: 'CSS/SCSS'),
                      SkillTag(name: 'Design System'),
                      SkillTag(name: 'Figma', isMatched: false),
                    ],
                    skillBreakdown: const [
                      SkillProficiency(name: 'ReactJS', percentage: 85),
                      SkillProficiency(name: 'CSS/SCSS', percentage: 80),
                      SkillProficiency(name: 'Design System', percentage: 60),
                      SkillProficiency(name: 'Figma', percentage: 35, isMatched: false),
                    ],
                    recommendations: const [
                      LearningRecommendation(
                        skillName: 'Figma for Developers',
                        description: 'Learn design tokens, auto layout, component variants, and Dev Mode for efficient handoff.',
                        estimatedTime: '1-2 weeks',
                        difficulty: 'Beginner',
                        icon: Icons.design_services,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// State 6: Jobdesk Analyzer Chat - now unused, kept for back-nav compatibility
  Widget _buildJobdeskAnalyzerChat() {
    return _buildJobdeskAnalyzer();
  }
}
