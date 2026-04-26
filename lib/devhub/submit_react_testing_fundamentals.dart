import 'package:flutter/material.dart';

class SubmitReactTestingFundamentalsScreen extends StatefulWidget {
  const SubmitReactTestingFundamentalsScreen({super.key});

  @override
  State<SubmitReactTestingFundamentalsScreen> createState() => _SubmitReactTestingFundamentalsScreenState();
}

class _SubmitReactTestingFundamentalsScreenState extends State<SubmitReactTestingFundamentalsScreen> {
  int _selectedIndex = 2;

  Widget _buildMetric(String title, String value, String subtitle, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.bold)),
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
            Text('React Testing\nFundamentals', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22, height: 1.2)),
            SizedBox(height: 4),
            Text('Intermediate • ~6hrs • 4 variants', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.yellow[300], borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Text('70%', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
          )
        ],
        toolbarHeight: 80,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false), // Mencegah melar
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(), // Scroll kaku (anti pantul)
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
                          TextSpan(text: '78', style: TextStyle(color: Colors.blue[900], fontSize: 32, fontWeight: FontWeight.bold)),
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
                      const Text('Submitted March 4, 2026', style: TextStyle(color: Colors.grey, fontSize: 13)),
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
                'Solid TDD approach — red-green-refactor applied correctly in most files. Main issue: coverage at 74% (below 80%) and 3 failing tests due to waitFor async timing. README needs full rewrite.',
                style: TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildMetric('Test Passing', '3', 'Failed of 20', Colors.red)),
                  Expanded(child: _buildMetric('Coverage', '74%', 'Target 80%', Colors.orange)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildMetric('Code Quality', 'B+', 'Clean Structure', Colors.green)),
                  Expanded(child: _buildMetric('TDD Adherence', '9/10', 'Components', Colors.green)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.blue[800], borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.build, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text('Issue to Fix', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 15),
              _buildIssueCard('3 async test failures', 'Resolves before state update in lines 84, 112, 139. Wrap assertion inside await waitFor(() => expect(...)).', Colors.red),
              const SizedBox(height: 10),
              _buildIssueCard('Coverage below 80%', 'Add tests for PaymentStep conditional, AddressForm zip error, and stepper back handler.', Colors.orange),
              const SizedBox(height: 10),
              _buildIssueCard('README incomplete', 'Only 3 sentences. Needs: testing strategy, edge cases, setup. Min. 150 words. Required deliverable.', Colors.orange),
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
}