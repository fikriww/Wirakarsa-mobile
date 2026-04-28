import 'package:flutter/material.dart';
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

/// Simulation flow states
enum SimulationState {
  initial, // 3 option cards
  careerScenarios, // company scenario cards
  careerChat, // Figma file message + quick replies
  salaryScenarios, // NEW: company salary level cards
  salaryChat, // HR salary message + quick replies
  jobdeskAnalyzer, // job listing cards
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () {
              if (_currentState != SimulationState.initial) {
                _goToState(SimulationState.initial);
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Career Simulation',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Career Simulation AI Mentor',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.textPrimary, size: 22),
              onPressed: () => _goToState(SimulationState.initial),
            ),
            IconButton(
              icon: const Icon(
                Icons.access_time_outlined,
                color: AppColors.textPrimary,
                size: 22,
              ),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 0.5, color: AppColors.divider),
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat area
          Expanded(child: _buildChatContent()),

          // Quick reply chips (shown in certain states)
          if (_currentState == SimulationState.careerChat)
            QuickReplyChips(
              replies: ["What's the right approach?", "I'm not sure wh..."],
              onTap: (reply) {},
            ),
          if (_currentState == SimulationState.salaryChat)
            QuickReplyChips(
              replies: ['Is the salary negotiable?', 'I am expecting ar...'],
              onTap: (reply) {},
            ),

          // Chat input
          ChatInputField(
            controller: _chatController,
            showTimer: _currentState == SimulationState.careerChat ||
                _currentState == SimulationState.salaryChat,
            timerText: '05:00',
            onSend: () {
              _chatController.clear();
            },
          ),
        ],
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
        const VoiceChatBubble(
          message:
              'The designer sent a Figma file:\n\n"Budi, here is the responsive mockup for the class page. Breakpoints: mobile (375px), tablet (768px), desktop (1440px). Please implement according to the spec, prioritizing mobile-first."',
          time: '12:49 AM',
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
        const VoiceChatBubble(
          message:
              'I am the HR Manager from Startup Fintech. We are offering 4-6m/month for this Junior position. What are your salary expectations?',
          time: '12:49 AM',
        ),
      ],
    );
  }

  /// State 5: Jobdesk Analyzer - Job listing cards
  Widget _buildJobdeskAnalyzer() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const ChatBubble(
          message: 'Choose a specific job listing you want to analyze.',
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
                salary: '8-15 million IDR/month',
                postedTime: '1 day ago',
                experienceLevel: 'Entry-Mid',
                onAnalyze: () {},
              ),
              JobListingCard(
                jobTitle: 'React Developer',
                company: 'Tokopedia',
                location: 'Jakarta',
                source: 'LinkedIn',
                matchPercent: 60,
                skills: const [
                  SkillTag(name: 'ReactJS'),
                  SkillTag(name: 'Redux', isMatched: false),
                  SkillTag(name: 'Unit Testing'),
                  SkillTag(name: 'CSS-in-JS'),
                  SkillTag(name: 'Accessibility'),
                ],
                salary: '8-15 million IDR/month',
                postedTime: '1 day ago',
                experienceLevel: 'Entry-Mid',
                onAnalyze: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
