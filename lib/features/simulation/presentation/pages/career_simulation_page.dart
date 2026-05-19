import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final ScrollController _scrollController = ScrollController();
  SimulationState _currentState = SimulationState.initial;
  String _currentSessionId = "";
  bool _isResponding = false;

  @override
  void dispose() {
    _chatController.dispose();
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
                style: GoogleFonts.poppins(
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
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "Status: ${s.status} · Level: ${s.level}",
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textHint),
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
              replies: const ['How to improve TypeScript?', 'Start mock interview'],
              onTap: _sendMessage,
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
                style: GoogleFonts.poppins(
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
                onAnalyze: () => _startNewSession(
                  type: 'jobdesk',
                  companyName: 'Gojek',
                  role: 'Frontend Developer',
                  level: 'Entry-Mid',
                  initialBotMessage: 'I am analyzing the Frontend Developer role at Gojek. Based on your profile, you match 80%. Let\'s focus on improving your TypeScript and Web Performance skills. Are you ready for a mock technical interview?',
                  targetState: SimulationState.jobdeskAnalyzerChat,
                ),
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
                onAnalyze: () => _startNewSession(
                  type: 'jobdesk',
                  companyName: 'Tokopedia',
                  role: 'React Developer',
                  level: 'Entry-Mid',
                  initialBotMessage: 'I am analyzing the React Developer role at Tokopedia. Let\'s evaluate your competency in Redux state slice structures and Unit Testing. What state manager do you have the most hours of experience with?',
                  targetState: SimulationState.jobdeskAnalyzerChat,
                ),
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
        if (messages.isEmpty) {
          return const Center(child: Text("Initializing chat mentorship session..."));
        }

        _scrollToBottom();

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: messages.length + (_isResponding ? 1 : 0),
          itemBuilder: (context, idx) {
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
}
