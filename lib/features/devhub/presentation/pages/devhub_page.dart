import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/project_card.dart';

class DevhubPage extends StatefulWidget {
  final bool initialIsCodeReviewActive;

  const DevhubPage({
    super.key,
    this.initialIsCodeReviewActive = false,
  });

  @override
  State<DevhubPage> createState() => _DevhubPageState();
}

class _DevhubPageState extends State<DevhubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Heading ──
              const Text(
                'Development Hub',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rancang dan kembangkan proyek nyata untuk memperkuat portofolio Anda dengan ulasan instan dari AI.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),

              // ── Project Cards ──
              _buildProjectsList(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.divider),
      ),
    );
  }

  Widget _buildProjectsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1 — Reviewed
        ProjectCard(
          title: 'Responsive Portfolio Landing Page',
          description:
              'Build a modern, mobile-first portfolio landing page demonstrating semantic layout and responsive grid...',
          level: 'BEGINNER',
          status: 'SELESAI DIREVIEW',
          duration: '2 hours',
          techTags: ['HTML/CSS'],
          score: 80,
          onTapViewResult: () =>
              context.push('/devhub/css-responsive-mastery/submit'),
        ),
        const SizedBox(height: 16),

        // Card 2 — Reviewed
        ProjectCard(
          title: 'React Task Tracker Dashboard',
          description:
              'Build a highly interactive React task tracker application showcasing complex state management...',
          level: 'INTERMEDIATE',
          status: 'SELESAI DIREVIEW',
          duration: '4 hours',
          techTags: ['React'],
          score: 80,
          onTapViewResult: () =>
              context.push('/devhub/react-component-basic/submit'),
        ),
        const SizedBox(height: 16),

        // Card 3 — Not started
        ProjectCard(
          title: 'Analytics Dashboard with Charts',
          description:
              'Create a premium data analytics dashboard featuring visual charts, deep filtering, and smooth interactive...',
          level: 'ADVANCED',
          status: 'BELUM MULAI',
          duration: '8 hours',
          techTags: ['React/Next.js'],
          onTapStartProject: () =>
              context.push('/devhub/react-testing-fundamentals'),
        ),
        const SizedBox(height: 16),

        // Card 4 — Not started
        ProjectCard(
          title: 'Async JavaScript Mastery',
          description:
              'Master asynchronous JavaScript to handle tasks like API calls and timers effectively...',
          level: 'INTERMEDIATE',
          status: 'BELUM MULAI',
          duration: '6 hours',
          techTags: ['JavaScript'],
          onTapStartProject: () =>
              context.push('/devhub/async-javascript-mastery'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
