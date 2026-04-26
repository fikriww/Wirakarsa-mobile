import 'package:flutter/material.dart';
import 'submit_css_responsive_mastery.dart'; // Menghubungkan ke file baru

class CssResponsiveMasteryScreen extends StatefulWidget {
  const CssResponsiveMasteryScreen({super.key});

  @override
  State<CssResponsiveMasteryScreen> createState() => _CssResponsiveMasteryScreenState();
}

class _CssResponsiveMasteryScreenState extends State<CssResponsiveMasteryScreen> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

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
            Text(
              'CSS Responsive\nMastery',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Intermediate • ~4hrs • 3 variants',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.yellow[300],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              '10%',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          )
        ],
        toolbarHeight: 80,
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Brief', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF1FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: const Text(
                    "Build a fully accessible UI component library following WCAG 2.1 AA standards. Components must be responsive across mobile, tablet, and desktop breakpoints.\n\n"
                    "What you'll build:\n"
                    "A component library containing: navigation bar, hero banner, card grid, modal dialog, and form with validation states.\n\n"
                    "Deliverables to submit:\n"
                    "• A single index.html + styles.css file (no frameworks — vanilla CSS only)\n"
                    "• Screenshot or screen recording showing all 3 breakpoints (375px, 768px, 1280px)\n"
                    "• Accessibility audit report exported from Lighthouse or axe DevTools (score ≥ 90)\n"
                    "• A written note (50-100 words) on how you handled keyboard navigation and color contrast\n\n"
                    "Acceptance criteria: No horizontal scroll at any breakpoint, all interactive elements keyboard-accessible, passes Lighthouse accessibility audit.",
                    style: TextStyle(fontSize: 13, height: 1.6, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 25),
                const Text('My Work', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.blue[600]!)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file, color: Colors.blue, size: 20),
                  label: const Text('Attach', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubmitCssResponsiveMasteryScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D6EFD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Submit Project', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
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