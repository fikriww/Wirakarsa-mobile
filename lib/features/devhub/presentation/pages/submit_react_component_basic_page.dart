import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class SubmitReactComponentBasicPage extends StatefulWidget {
  const SubmitReactComponentBasicPage({super.key});

  @override
  State<SubmitReactComponentBasicPage> createState() => _SubmitReactComponentBasicPageState();
}

class _SubmitReactComponentBasicPageState extends State<SubmitReactComponentBasicPage> {
  int _selectedIndex = 2;

  Widget _buildMetric(String title, Widget valueWidget, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        valueWidget,
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.go('/devhub'),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('React Component\nBasic', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22, height: 1.2)),
            SizedBox(height: 4),
            Text('Intermediate • ~4hrs • 4 variants', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.yellow[300], borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Text('40%', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
          )
        ],
        toolbarHeight: 80,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGradeHeader('68', 'Submitted March 2, 2026', 'Resubmit Required', Colors.red),
              const SizedBox(height: 30),
              _buildSectionTitle(Icons.star_border, 'AI Review Summary'),
              const SizedBox(height: 15),
              const Text(
                'Component structure is mostly good, but 2 critical requirements are missing: live demo link was not provided, and one component has prop drilling beyond 2 levels. Also 4 inline styles found — must be removed.',
                style: TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildMetric('Component', const Text('7', style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)), 'Requirement mets')),
                  Expanded(child: _buildMetric('Breakpoints', const Icon(Icons.close, color: Colors.red, size: 28), 'All Passing')),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildMetric('State Management', const Icon(Icons.check, color: Colors.green, size: 28), 'Menu Toggle Works')),
                  Expanded(child: _buildMetric('Props Used', const Text('5', style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)), 'Target >3')),
                ],
              ),
              const SizedBox(height: 30),
              _buildSectionTitle(Icons.build, 'Issue to Fix'),
              const SizedBox(height: 15),
              _buildIssueCard('Live demo link missing', 'Deploy to Vercel, Netlify, or CodeSandbox and include the URL. This is a hard requirement — submission cannot pass without it.', Colors.red),
              const SizedBox(height: 20),
              _buildCloseButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,

      ),
    );
  }

  Widget _buildGradeHeader(String score, String date, String status, MaterialColor statusColor) {
    return Row(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(children: [
              TextSpan(text: score, style: TextStyle(color: Colors.blue[900], fontSize: 32, fontWeight: FontWeight.bold)),
              TextSpan(text: '/100', style: TextStyle(color: Colors.blue[900], fontSize: 14, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Project Graded', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: statusColor[50], borderRadius: BorderRadius.circular(20)),
              child: Text(status, style: TextStyle(color: statusColor[400], fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.blue[800], borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildIssueCard(String title, String desc, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color[50],
        border: Border.all(color: color[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color[800], fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 50,
      child: ElevatedButton(
        onPressed: () => context.go('/devhub'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
