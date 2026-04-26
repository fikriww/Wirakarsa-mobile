import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'code_review.dart'; 
import 'react_testing_fundamentals.dart'; 
import 'css_responsive_mastery.dart';
import 'react_component_basic.dart';
import 'async_javascript_mastery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const DevelopmentHubScreen(),
    );
  }
}

class DevelopmentHubScreen extends StatefulWidget {
  const DevelopmentHubScreen({super.key});

  @override
  State<DevelopmentHubScreen> createState() => _DevelopmentHubScreenState();
}

class _DevelopmentHubScreenState extends State<DevelopmentHubScreen> {
  int _selectedIndex = 2;
  bool _isCodeReviewActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
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
          physics: const ClampingScrollPhysics(), // Menjaga agar scroll tidak melar
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildSegmentButton("Mini Project", !_isCodeReviewActive, () {
                    setState(() => _isCodeReviewActive = false);
                  }),
                  const SizedBox(width: 12),
                  _buildSegmentButton("Code Review", _isCodeReviewActive, () {
                    setState(() => _isCodeReviewActive = true);
                  }),
                ],
              ),
              const SizedBox(height: 25),
              _isCodeReviewActive 
                  ? const CodeReviewScreen() 
                  : _buildMainContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Readiness"),
            BottomNavigationBarItem(icon: Icon(Icons.code), label: "Dev Hub"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Simulation"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
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
        _buildProjectCard(
          "React Testing Fundamentals",
          "Skill Gap: 78%",
          ["Intermediate", "6 hrs", "2 versions"],
          0.3,
          onTapStartProject: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ReactTestingFundamentalsScreen(),
            ));
          },
        ),
        const SizedBox(height: 15),
        _buildProjectCard(
          "CSS Responsive Mastery",
          "Skill Gap: 15%",
          ["Beginner", "4 hrs", "1 version"],
          0.9,
          onTapStartProject: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const CssResponsiveMasteryScreen(),
            ));
          },
        ),
        const SizedBox(height: 15),
        _buildProjectCard(
          "React Component Basic",
          "Skill Gap: 48%",
          ["Intermediate", "4 hrs", "4 versions"],
          0.5,
          onTapStartProject: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ReactComponentBasicScreen(),
            ));
          },
        ),
        const SizedBox(height: 15),
        _buildProjectCard(
          "Async JavaScript Mastery",
          "Skill Gap: 25%",
          ["Intermediate", "6 hrs", "3 versions"],
          0.74,
          onTapStartProject: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const AsyncJavascriptMasteryScreen(),
            ));
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSegmentButton(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1D4ED8) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFF1D4ED8)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF1D4ED8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String gap, List<String> tags, double progress, {VoidCallback? onTapStartProject}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E3A8A))),
              ),
              Text(gap,
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: tags
                .map((tag) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(tag,
                          style: TextStyle(color: Colors.blue[700], fontSize: 11)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: Colors.orange,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_outlined, size: 18),
                  label: const Text("Ask AI Now"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onTapStartProject ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Start Project"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// --- CUSTOM PAINTER UNTUK SKILL MAP (RADAR CHART) ---
class RadarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.8;

    final List<String> labels = [
      "Testing/Debug",
      "Web Performance",
      "Accessibility",
      "State Management",
      "UI/UX",
      "Unit",
    ];

    final List<Color> dotColors = [
      Colors.red,
      Colors.red,
      Colors.orange,
      const Color(0xFF22C55E),
      const Color(0xFF22C55E),
      const Color(0xFF22C55E),
    ];

    // Persentase skill berdasarkan gambar (dummy values agar mirip visualnya)
    final List<double> values = [0.8, 0.7, 0.65, 0.85, 0.75, 0.6];

    final linePaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Gambar Jaring Heksagon (Web)
    for (var i = 1; i <= 5; i++) {
      final currentRadius = radius * (i / 5);
      final path = Path();
      for (var j = 0; j < 6; j++) {
        final angle = (j * 60) * math.pi / 180 - (math.pi / 2);
        final x = center.dx + currentRadius * math.cos(angle);
        final y = center.dy + currentRadius * math.sin(angle);
        if (j == 0) path.moveTo(x, y); else path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, linePaint);
    }

    // 2. Gambar Garis Penghubung Tengah
    for (var j = 0; j < 6; j++) {
      final angle = (j * 60) * math.pi / 180 - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), linePaint);
    }

    // 3. Gambar Area Skill (Biru Transparan)
    final skillPath = Path();
    final skillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (var j = 0; j < 6; j++) {
      final angle = (j * 60) * math.pi / 180 - (math.pi / 2);
      final valRadius = radius * values[j];
      final x = center.dx + valRadius * math.cos(angle);
      final y = center.dy + valRadius * math.sin(angle);
      if (j == 0) skillPath.moveTo(x, y); else skillPath.lineTo(x, y);
    }
    skillPath.close();
    canvas.drawPath(skillPath, skillPaint);

    // 4. Gambar Label & Dot Berwarna
    for (var j = 0; j < 6; j++) {
      final angle = (j * 60) * math.pi / 180 - (math.pi / 2);
      final labelRadius = radius + 25;
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);

      // Gambar Dot
      final dotPaint = Paint()..color = dotColors[j];
      final dotPos = Offset(
        center.dx + (radius + 10) * math.cos(angle),
        center.dy + (radius + 10) * math.sin(angle),
      );
      canvas.drawCircle(dotPos, 4, dotPaint);

      // Gambar Teks Label
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[j],
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}