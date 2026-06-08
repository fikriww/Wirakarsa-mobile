import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/models/career_simulation_model.dart';
import '../../../../core/models/chat_message_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/voice_chat_bubble.dart';
import '../widgets/simulation_option_card.dart';
import '../widgets/company_scenario_card.dart';
import '../widgets/job_listing_card.dart';
import '../widgets/quick_reply_chips.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/salary_scenario_card.dart';
import 'voice_mode_page.dart';
import '../../data/models/job_analysis_response.dart';
import '../../data/services/job_analysis_api_service.dart';

enum SimulationState {
  initial, // 3 option cards
  careerScenarios, // company scenario cards
  careerChat, // Responsive brief chat
  salaryScenarios, // company salary level cards
  salaryChat, // Salary negotiation chat
  jobdeskAnalyzer, // job listing cards
  jobdeskAnalyzerChat, // TypeScript interview chat
}

class CareerSimulationPage extends ConsumerStatefulWidget {
  const CareerSimulationPage({super.key});

  @override
  ConsumerState<CareerSimulationPage> createState() => _CareerSimulationPageState();
}

class _CareerSimulationPageState extends ConsumerState<CareerSimulationPage> {
  final _chatController = TextEditingController();
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  SimulationState _currentState = SimulationState.initial;
  String _currentSessionId = "";
  bool _isResponding = false;

  final _apiService = JobAnalysisApiService();
  bool _isAnalyzing = false;
  String? _errorMessage;
  JobAnalysisResponse? _analysisResult;

  final Map<String, double> _userSkills = {
    'testing (jest)': 0.30,
    'testing': 0.30,
    'jest': 0.30,
    'web performance': 0.55,
    'performance': 0.55,
    'accessibility': 0.50,
    'a11y': 0.50,
    'state management': 0.85,
    'redux': 0.85,
    'react.js': 0.80,
    'reactjs': 0.80,
    'react': 0.80,
    'css/tailwind': 0.83,
    'css': 0.83,
    'tailwind': 0.83,
    'javascript': 0.75,
    'typescript': 0.40,
    'html5': 0.90,
    'html': 0.90,
  };

  bool _doesUserMeetSkill(String skillName) {
    final normalized = skillName.toLowerCase().trim();
    final userProfile = ref.read(userProfileProvider).value;
    final skills = (userProfile != null && userProfile.skills.isNotEmpty) ? userProfile.skills : _userSkills;
    for (final entry in skills.entries) {
      final entryKey = entry.key.toLowerCase().trim();
      if (normalized.contains(entryKey) || entryKey.contains(normalized)) {
        return entry.value >= 0.70;
      }
    }
    return false;
  }

  Future<void> _analyzeJob(String jobTitle, {String? company, String? location, String? level}) async {
    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      _analysisResult = null;
    });

    try {
      final result = await _apiService.predictRequiredSkills(jobTitle);
      setState(() {
        _analysisResult = result;
      });

      final gaps = result.skills.where((s) => !_doesUserMeetSkill(s.skill)).map((s) => s.skill).toList();
      String botMsg = 'I am analyzing the $jobTitle role';
      if (company != null) botMsg += ' at $company';
      botMsg += '. Based on your profile, we found a **${result.matchedJobSimilarityPct.toStringAsFixed(0)}%** match. ';
      if (gaps.isNotEmpty) {
        botMsg += 'Let\'s focus on improving your ${gaps.take(2).join(" and ")} skills. Are you ready for a mock technical interview?';
      } else {
        botMsg += 'You meet all major requirements! Are you ready for a mock technical interview?';
      }

      await _startNewSession(
        type: 'jobdesk',
        companyName: company ?? 'Custom Search',
        role: jobTitle,
        level: level ?? 'Entry-Mid',
        initialBotMessage: botMsg,
        targetState: SimulationState.jobdeskAnalyzerChat,
      );

      setState(() {
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isAnalyzing = false;
      });
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _goToState(SimulationState state) {
    setState(() => _currentState = state);
  }

  // Helper to scroll the list to the bottom when new messages arrive
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Helper to start a new simulation session
  Future<void> _startNewSession({
    required String type,
    required String companyName,
    required String role,
    required String level,
    required String initialBotMessage,
    required SimulationState targetState,
  }) async {
    final userProfile = ref.read(userProfileProvider).value;
    final uid = userProfile?.uid ?? 'guest';
    final dbService = ref.read(dbServiceProvider);

    final session = CareerSimulationSession(
      id: '',
      userId: uid,
      type: type,
      companyName: companyName,
      role: role,
      level: level,
      status: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      // 1. Create session document in Firestore
      final sessionId = await dbService.createSimulationSession(session);
      
      // 2. Insert initial introductory message
      await dbService.addChatMessage(
        sessionId,
        ChatMessage(
          id: '',
          sender: 'ai',
          text: initialBotMessage,
          timestamp: DateTime.now(),
        ),
      );

      setState(() {
        _currentSessionId = sessionId;
        _currentState = targetState;
      });
    } catch (e) {
      debugPrint("Error starting simulation session: $e");
    }
  }

  // Handle message send
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _currentSessionId.isEmpty || _isResponding) return;

    final dbService = ref.read(dbServiceProvider);

    try {
      // 1. Save user message to Firestore
      await dbService.addChatMessage(
        _currentSessionId,
        ChatMessage(
          id: '',
          sender: 'user',
          text: text,
          timestamp: DateTime.now(),
        ),
      );

      _chatController.clear();
      _scrollToBottom();

      setState(() {
        _isResponding = true;
      });

      // 2. Simulate smart bot response after 1.2s delay
      Timer(const Duration(milliseconds: 1200), () async {
        String botReply = "That's an interesting approach. Let's dig deeper. How would you justify this choice to the project team?";
        
        // Custom smart replies based on session state and query content
        final normalizedText = text.toLowerCase();
        if (_currentState == SimulationState.careerChat) {
          if (normalizedText.contains("approach") || normalizedText.contains("right")) {
            botReply = "Budi, when implementing mobile-first mockups, it is best to use CSS Grid for layout structure and media queries based on min-width. Would you structure this using CSS Flexbox or CSS Grid, and what would your first selector look like?";
          } else if (normalizedText.contains("grid")) {
            botReply = "Excellent! CSS Grid is perfect for multi-dimensional layouts. Let's write the media queries. How would you define the breakpoint boundaries for mobile (375px) vs tablet (768px)?";
          } else {
            botReply = "Got it. Let's focus on the responsive breakpoints. Budi, what viewport units or media query strategies will keep this class page fully accessible on a 375px display?";
          }
        } else if (_currentState == SimulationState.salaryChat) {
          if (normalizedText.contains("negotiable") || normalizedText.contains("range")) {
            botReply = "Indeed, the salary range is slightly negotiable for highly skilled candidates. What specific technical skills or portfolio items make you feel you stand out for this junior position?";
          } else if (normalizedText.contains("12 million") || normalizedText.contains("12m") || normalizedText.contains("12jt")) {
            botReply = "I understand. 12 million IDR is significantly higher than our initial junior range. However, we're extremely impressed by your UI design skills and Git history. Can you walk me through your key achievements that justify this premium rate?";
          } else {
            botReply = "Thank you for sharing your expectation. We can review this rate if you are able to demonstrate competency in Jest testing and CSS Responsive layout. Are you open to a small technical case study to secure this package?";
          }
        } else if (_currentState == SimulationState.jobdeskAnalyzerChat) {
          if (normalizedText.contains("typescript") || normalizedText.contains("improve")) {
            botReply = "TypeScript is key! To start our technical mock interview: what is the primary difference between a 'type' alias and an 'interface' in TypeScript, and which should you prefer for defining React component props?";
          } else if (normalizedText.contains("interface")) {
            botReply = "Brilliant! Interfaces are ideal for declaring object shapes and support declaration merging. What about unions? Can an interface extend a union type, or is that restricted to type aliases?";
          } else {
            botReply = "Awesome! Let's talk about Web Performance. What is your go-to optimization strategy for reducing React bundle size and improving the lighthouse score of a landing page?";
          }
        }

        await dbService.addChatMessage(
          _currentSessionId,
          ChatMessage(
            id: '',
            sender: 'ai',
            text: botReply,
            timestamp: DateTime.now(),
          ),
        );

        if (mounted) {
          setState(() {
            _isResponding = false;
          });
          _scrollToBottom();
        }
      });
    } catch (e) {
      debugPrint("Error sending message: $e");
      if (mounted) {
        setState(() {
          _isResponding = false;
        });
      }
    }
  }

  // Show past sessions in bottom sheet
  void _showSessionHistory() {
    final sessionsAsync = ref.read(userSimulationSessionsProvider);

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
                'Conversation History',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: sessionsAsync.when(
                data: (sessions) {
                  if (sessions.isEmpty) {
                    return const Center(
                      child: Text("No simulation history found. Start a new session above!"),
                    );
                  }
                  return ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, idx) {
                      final s = sessions[idx];
                      IconData icon = Icons.work_outline;
                      if (s.type == 'salary') icon = Icons.account_balance_wallet_outlined;
                      if (s.type == 'jobdesk') icon = Icons.search_rounded;

                      return ListTile(
                        leading: Icon(icon, color: AppColors.primaryBlue),
                        title: Text(
                          "${s.role} - ${s.companyName}",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "Status: ${s.status} · Level: ${s.level}",
                          style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _currentSessionId = s.id;
                            if (s.type == 'career') {
                              _currentState = SimulationState.careerChat;
                            } else if (s.type == 'salary') {
                              _currentState = SimulationState.salaryChat;
                            } else {
                              _currentState = SimulationState.jobdeskAnalyzerChat;
                            }
                          });
                          _scrollToBottom();
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
    ref.watch(userProfileProvider);
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
            onPressed: _showSessionHistory,
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

          // Quick reply chips (shown in active chat states)
          if (_currentState == SimulationState.careerChat)
            QuickReplyChips(
              replies: const [
                "What's the right approach?",
                "I'm not sure where to start",
              ],
              onTap: _sendMessage,
            ),
          if (_currentState == SimulationState.salaryChat)
            QuickReplyChips(
              replies: const [
                'Is the salary negotiable?',
                'I am expecting around 12 million IDR/month',
              ],
              onTap: _sendMessage,
            ),
          if (_currentState == SimulationState.jobdeskAnalyzerChat)
            QuickReplyChips(
              replies: [
                if (_analysisResult != null && _analysisResult!.skills.any((s) => !_doesUserMeetSkill(s.skill)))
                  'How to improve ${_analysisResult!.skills.firstWhere((s) => !_doesUserMeetSkill(s.skill)).skill}?'
                else
                  'How to improve TypeScript?',
                'Start mock interview',
              ],
              onTap: (reply) {
                if (reply.startsWith('How to improve')) {
                  final skill = reply.replaceAll('How to improve ', '').replaceAll('?', '');
                  _sendMessage('I want to focus on learning and improving my $skill skill. What resources or steps do you suggest?');
                } else if (reply == 'Start mock interview') {
                  _sendMessage('I am ready to start the mock technical interview for the ${_analysisResult?.jobTitle ?? "Frontend Developer"} position.');
                } else {
                  _sendMessage(reply);
                }
              },
            ),

          // Chat input field
          ChatInputField(
            controller: _chatController,
            showTimer:
                _currentState == SimulationState.careerChat ||
                _currentState == SimulationState.salaryChat ||
                _currentState == SimulationState.jobdeskAnalyzerChat,
            timerText: '05:00',
            onSend: () => _sendMessage(_chatController.text),
            onMicTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const VoiceModePage()),
              );
            },
            onAskTap: () => _showAskOptions(context),
            onRepositoriesTap: _showSessionHistory,
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildOptionTile('How should I negotiate for a higher salary?'),
            _buildOptionTile('What are the red flags to look for in a startup?'),
            _buildOptionTile('Can you explain state management simply?'),
            _buildOptionTile('How to transition from Junior to Mid level?'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(String text) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _sendMessage(text);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Text(
          text,
          style: const TextStyle(
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
        return _buildActiveChatStream();
      case SimulationState.salaryScenarios:
        return _buildSalaryScenarios();
      case SimulationState.salaryChat:
        return _buildActiveChatStream();
      case SimulationState.jobdeskAnalyzer:
        return _buildJobdeskAnalyzer();
      case SimulationState.jobdeskAnalyzerChat:
        return _buildActiveChatStream();
    }
  }

  /// State 1: Initial - 3 simulation options
  Widget _buildInitialState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const ChatBubble(
          message: 'Hello! I\'m your AI Mentor. Choose the simulation you\'d like to practice today',
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
                onTap: () => _startNewSession(
                  type: 'career',
                  companyName: 'EduNext (EdTech)',
                  role: 'Junior Frontend Developer',
                  level: 'Junior',
                  initialBotMessage: 'The designer sent a Figma file:\n\n"Budi, here is the responsive mockup for the class page. Breakpoints: mobile (375px), tablet (768px), desktop (1440px). Please implement according to the spec, prioritizing mobile-first."',
                  targetState: SimulationState.careerChat,
                ),
              ),
              CompanyScenarioCard(
                companyName: 'TokoBuild (E-commerce)',
                role: 'Frontend Developer',
                focus: 'Web Performance',
                level: 'Mid',
                onTap: () => _startNewSession(
                  type: 'career',
                  companyName: 'TokoBuild (E-commerce)',
                  role: 'Frontend Developer',
                  level: 'Mid',
                  initialBotMessage: 'Budi, our e-commerce checkout page load time has spiked. Review the code split settings and recommend a performance solution.',
                  targetState: SimulationState.careerChat,
                ),
              ),
              CompanyScenarioCard(
                companyName: 'HealthConnect (HealthTech)',
                role: 'Junior Frontend Developer',
                focus: 'Accessibility',
                level: 'Junior',
                onTap: () => _startNewSession(
                  type: 'career',
                  companyName: 'HealthConnect (HealthTech)',
                  role: 'Junior Frontend Developer',
                  level: 'Junior',
                  initialBotMessage: 'Hello Budi, we need to secure WCAG 2.1 AA accessibility compliance for our health portal. Start audit on the onboarding forms.',
                  targetState: SimulationState.careerChat,
                ),
              ),
              CompanyScenarioCard(
                companyName: 'DataFlow (SaaS Analytics)',
                role: 'Frontend Developer',
                focus: 'State Management',
                level: 'Mid',
                onTap: () => _startNewSession(
                  type: 'career',
                  companyName: 'DataFlow (SaaS Analytics)',
                  role: 'Frontend Developer',
                  level: 'Mid',
                  initialBotMessage: 'Budi, the dashboard states are causing infinite re-renders. Check the Redux/Zustand slice updates.',
                  targetState: SimulationState.careerChat,
                ),
              ),
            ],
          ),
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
                onTap: () => _startNewSession(
                  type: 'salary',
                  companyName: 'Startup Fintech',
                  role: 'Junior Frontend Developer',
                  level: 'Junior',
                  initialBotMessage: 'I am the HR Manager from Startup Fintech. We are offering 4-6m/month for this Junior position. What are your salary expectations?',
                  targetState: SimulationState.salaryChat,
                ),
              ),
              SalaryScenarioCard(
                companyName: 'Unicorn E-commerce',
                salaryRange: '8-12M/month',
                level: 'Mid',
                onTap: () => _startNewSession(
                  type: 'salary',
                  companyName: 'Unicorn E-commerce',
                  role: 'Frontend Developer',
                  level: 'Mid',
                  initialBotMessage: 'Welcome! I represent Unicorn E-commerce. Our budget range is 8-12m/month for a mid-level frontend hire. What package matches your criteria?',
                  targetState: SimulationState.salaryChat,
                ),
              ),
              SalaryScenarioCard(
                companyName: 'Enterprise Bank',
                salaryRange: '12-18M/month',
                level: 'Mid - Senior',
                onTap: () => _startNewSession(
                  type: 'salary',
                  companyName: 'Enterprise Bank',
                  role: 'Senior Developer',
                  level: 'Mid - Senior',
                  initialBotMessage: 'Hello Budi. Enterprise Bank hires seniors between 12-18m/month. Describe the value you secure to command this package.',
                  targetState: SimulationState.salaryChat,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// State 5: Jobdesk Analyzer - Job listing cards
  Widget _buildJobdeskAnalyzer() {
    if (_isAnalyzing) {
      return _buildLoadingState();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const ChatBubble(
          message: 'Choose a specific job listing or type a custom job title below to analyze required skills.',
          time: '12:49 AM',
        ),
        const SizedBox(height: 16),
        
        // Error banner if any
        _buildErrorBanner(),

        // Search Bar for custom jobs
        Container(
          margin: const EdgeInsets.only(left: 46, bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Enter custom job (e.g. Flutter Developer)',
                    hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  onChanged: (val) => setState(() {}),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _analyzeJob(value.trim());
                    }
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                ),
              ElevatedButton(
                onPressed: _searchController.text.trim().isEmpty
                    ? null
                    : () {
                        final query = _searchController.text.trim();
                        _analyzeJob(query);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Analyze',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

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
                onAnalyze: () => _analyzeJob('Frontend Developer', company: 'Gojek', location: 'Jakarta', level: 'Entry-Mid'),
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
                onAnalyze: () => _analyzeJob('React Developer', company: 'Tokopedia', location: 'Jakarta', level: 'Entry-Mid'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Real-time chat message stream builder from Firestore
  Widget _buildActiveChatStream() {
    if (_currentSessionId.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final dbService = ref.watch(dbServiceProvider);

    return StreamBuilder<List<ChatMessage>>(
      stream: dbService.getChatMessages(_currentSessionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data ?? [];
        if (messages.isEmpty && _currentState != SimulationState.jobdeskAnalyzerChat) {
          return const Center(child: Text("Initializing chat mentorship session..."));
        }

        _scrollToBottom();

        final showAnalysisCard = _currentState == SimulationState.jobdeskAnalyzerChat && _analysisResult != null;

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: messages.length + (_isResponding ? 1 : 0) + (showAnalysisCard ? 1 : 0),
          itemBuilder: (context, idx) {
            if (showAnalysisCard) {
              if (idx == 0) {
                return _buildAnalysisResultsCard();
              }
              idx -= 1; // Shift message index by 1
            }

            if (idx == messages.length) {
              // Show typing indicator or skeleton
              return const Padding(
                padding: EdgeInsets.only(left: 12, top: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text("AI Mentor is responding...", style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
              );
            }

            final msg = messages[idx];
            final timeStr = "${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}";

            if (msg.sender == 'ai') {
              return VoiceChatBubble(
                message: msg.text,
                time: timeStr,
                onVoiceTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VoiceModePage()),
                  );
                },
              );
            } else {
              return ChatBubble(
                message: msg.text,
                time: timeStr,
                isUser: true,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildAnalysisResultsCard() {
    final result = _analysisResult;
    if (result == null) return const SizedBox.shrink();

    final skills = result.skills;

    return Padding(
      padding: const EdgeInsets.only(left: 46, bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE1F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Market Skill Demand',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Confidence threshold: ${result.thresholdApplied}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            
            ...skills.map((skill) {
              final isMatched = _doesUserMeetSkill(skill.skill);
              final matchColor = isMatched ? AppColors.success : const Color(0xFFF59E0B);
              final progressVal = skill.confidence;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isMatched ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                              color: matchColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              skill.skill,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isMatched 
                                ? AppColors.success.withOpacity(0.08)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isMatched ? 'Matched' : 'Gap',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isMatched ? AppColors.success : const Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progressVal,
                              backgroundColor: AppColors.divider,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isMatched ? AppColors.success : AppColors.primaryBlue,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${skill.confidencePct.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Analyzing Job Requirements...',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fetching market skills database for job predictions...',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    if (_errorMessage == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(left: 46, bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF991B1B),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF991B1B), size: 16),
            onPressed: () {
              setState(() {
                _errorMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }
}
