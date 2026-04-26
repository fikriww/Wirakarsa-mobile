import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../widgets/segment_button.dart';
import '../widgets/project_card.dart';
import '../widgets/radar_chart.dart';
import 'code_review_page.dart';

class DevhubPage extends StatefulWidget {
  const DevhubPage({super.key});

  @override
  State<DevhubPage> createState() => _DevhubPageState();
}

class _DevhubPageState extends State<DevhubPage> {
  int _selectedIndex = 2;
  bool _isCodeReviewActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SegmentButton(
                    label: "Mini Project",
                    isActive: !_isCodeReviewActive,
                    onTap: () => setState(() => _isCodeReviewActive = false),
                  ),
                  const SizedBox(width: 12),
                  SegmentButton(
                    label: "Code Review",
                    isActive: _isCodeReviewActive,
                    onTap: () => setState(() => _isCodeReviewActive = true),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _isCodeReviewActive 
                  ? const CodeReviewSection() 
                  : _buildMainContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Skill Map',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        AspectRatio(
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
        const SizedBox(height: 30),
        const Text(
          'Mini Projects for You',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ProjectCard(
          title: "React Testing Fundamentals",
          gap: "Skill Gap: 78%",
          tags: ["Intermediate", "6 hrs", "2 versions"],
          progress: 0.3,
          onTapStartProject: () => context.push('/devhub/react-testing-fundamentals'),
        ),
        const SizedBox(height: 15),
        ProjectCard(
          title: "CSS Responsive Mastery",
          gap: "Skill Gap: 15%",
          tags: ["Beginner", "4 hrs", "1 version"],
          progress: 0.9,
          onTapStartProject: () => context.push('/devhub/css-responsive-mastery'),
        ),
        const SizedBox(height: 15),
        ProjectCard(
          title: "React Component Basic",
          gap: "Skill Gap: 48%",
          tags: ["Intermediate", "4 hrs", "4 versions"],
          progress: 0.5,
          onTapStartProject: () => context.push('/devhub/react-component-basic'),
        ),
        const SizedBox(height: 15),
        ProjectCard(
          title: "Async JavaScript Mastery",
          gap: "Skill Gap: 25%",
          tags: ["Intermediate", "6 hrs", "3 versions"],
          progress: 0.74,
          onTapStartProject: () => context.push('/devhub/async-javascript-mastery'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
