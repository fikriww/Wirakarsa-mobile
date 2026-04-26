import 'package:flutter/material.dart';

class SubmitAsyncJavascriptMasteryScreen extends StatefulWidget {
  const SubmitAsyncJavascriptMasteryScreen({super.key});

  @override
  State<SubmitAsyncJavascriptMasteryScreen> createState() => _SubmitAsyncJavascriptMasteryScreenState();
}

class _SubmitAsyncJavascriptMasteryScreenState extends State<SubmitAsyncJavascriptMasteryScreen> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Async JavaScript\nMastery', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22, height: 1.2)),
            SizedBox(height: 4),
            Text('Intermediate • ~5hrs • 3 variants', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.yellow[300], borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Text('25%', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
          )
        ],
        toolbarHeight: 80,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '82', style: TextStyle(color: Colors.blue[900], fontSize: 32, fontWeight: FontWeight.bold)),
                          TextSpan(text: '/100', style: TextStyle(color: Colors.blue[900], fontSize: 14, fontWeight: FontWeight.bold)),
                        ]
                      )
                    )
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Project Graded', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('Submitted March 5, 2026', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(20)),
                        child: Text('Needs Revision', style: TextStyle(color: Colors.orange[800], fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.blue[800], borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.star_border, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text('AI Review Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Good async pattern coverage — callbacks, Promises, and async/await all demonstrated correctly. Promise.all() implemented well. Two gaps: timer.js uses setTimeout instead of setInterval, and write-up is 38 words (below 50).',
                style: TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildMetric('Async Patterns', const Text('3', style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)), 'All Present')),
                  Expanded(child: _buildMetric('Promise.all()', const Icon(Icons.check, color: Colors.green, size: 28), '2 endpoints')),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildMetric('State Management', const Icon(Icons.check, color: Colors.green, size: 28), 'Menu Toggle Works')),
                  Expanded(child: _buildMetric('Timer.js', const Icon(Icons.close, color: Colors.red, size: 28), 'Wrong interval Type')),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.blue[800], borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.star_border, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text('Issue to Fix', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('timer.js uses setTimeout, not setInterval', style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Brief requires a polling/countdown using setInterval + clearInterval. Current setTimeout only fires once — refactor to a proper interval loop.', style: TextStyle(fontSize: 13, height: 1.5, color: Colors.black87)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12, width: 0.5))),
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
}