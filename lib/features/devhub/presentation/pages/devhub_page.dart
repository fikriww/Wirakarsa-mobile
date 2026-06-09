import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/models/mini_project_model.dart';
import '../widgets/segment_button.dart';
import '../widgets/project_card.dart';
import '../widgets/radar_chart.dart';
import 'code_review_page.dart';

class DevhubPage extends ConsumerStatefulWidget {
  final bool initialIsCodeReviewActive;

  const DevhubPage({
    super.key,
    this.initialIsCodeReviewActive = false,
  });

  @override
  ConsumerState<DevhubPage> createState() => _DevhubPageState();
}

class _DevhubPageState extends ConsumerState<DevhubPage> {
  late bool _isCodeReviewActive;

  @override
  void initState() {
    super.initState();
    _isCodeReviewActive = widget.initialIsCodeReviewActive;
  }

  @override
  void didUpdateWidget(DevhubPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIsCodeReviewActive != oldWidget.initialIsCodeReviewActive) {
      setState(() {
        _isCodeReviewActive = widget.initialIsCodeReviewActive;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: const [
            Text(
              'Development Hub',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Level up your skills and work readiness',
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
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SegmentButton(
                      label: "Mini Project",
                      isActive: !_isCodeReviewActive,
                      onTap: () => setState(() => _isCodeReviewActive = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SegmentButton(
                      label: "Code Review",
                      isActive: _isCodeReviewActive,
                      onTap: () => setState(() => _isCodeReviewActive = true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _isCodeReviewActive
                  ? CodeReviewSection(
                      onSwitchToMiniProject: () => setState(() => _isCodeReviewActive = false),
                    )
                  : _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final skillGapAsync = ref.watch(skillGapProvider);
    final miniProjectsAsync = ref.watch(miniProjectsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Skill Map',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        // Radar chart from skill gap data
        skillGapAsync.when(
          data: (skills) => AspectRatio(
            aspectRatio: 1.1,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: CustomPaint(
                painter: RadarChartPainter(),
              ),
            ),
          ),
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => AspectRatio(
            aspectRatio: 1.1,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: CustomPaint(painter: RadarChartPainter()),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'Mini Projects for You',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        // Dynamic project list
        miniProjectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyProjects();
            }
            return Column(
              children: projects
                  .map((p) => _buildProjectCard(p))
                  .toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, _) => _buildProjectsFallback(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProjectCard(MiniProject project) {
    // Calculate skill gap percentage to display (use overallScore or default)
    final gapPercent = project.overallScore != null
        ? '${(100 - project.overallScore!).round()}%'
        : '—';
    final gapLabel = project.overallScore != null
        ? 'Skill Gap: $gapPercent'
        : 'Not submitted yet';

    // Progress based on submission status
    double progress = 0.0;
    if (project.submissionStatus == 'reviewed' && project.overallScore != null) {
      progress = project.overallScore! / 100;
    } else if (project.submissionStatus == 'submitted') {
      progress = 0.6;
    } else if (project.submissionStatus == 'in_progress') {
      progress = 0.2;
    }

    final tags = [
      project.level,
      project.duration,
      if (project.tag.isNotEmpty) project.tag,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ProjectCard(
        title: project.title,
        description: project.description,
        gap: gapLabel,
        tags: tags,
        progress: progress,
        onTapStartProject: () {
          context.push('/devhub/project/${project.id}', extra: project);
        },
      ),
    );
  }

  Widget _buildEmptyProjects() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.folder_open_outlined, size: 48, color: Colors.black26),
            SizedBox(height: 12),
            Text(
              'No projects available yet.',
              style: TextStyle(color: Colors.black45, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsFallback() {
    // Fallback to static cards if API is unavailable
    return Column(
      children: [
        ProjectCard(
          title: "React Testing Fundamentals",
          description: "Build a complete checkout form using TDD approach with Jest & React Testing Library.",
          gap: "Skill Gap: 78%",
          tags: const ["Intermediate", "6 hrs", "4 variants"],
          progress: 0.3,
          onTapStartProject: () => context.push('/devhub/project/react-testing-fundamentals'),
        ),
        const SizedBox(height: 15),
        ProjectCard(
          title: "CSS Responsive Mastery",
          description: "Build a fully accessible UI component library following WCAG 2.1 AA.",
          gap: "Skill Gap: 15%",
          tags: const ["Intermediate", "4 hrs", "3 variants"],
          progress: 0.9,
          onTapStartProject: () => context.push('/devhub/project/css-responsive-mastery'),
        ),
      ],
    );
  }
}
