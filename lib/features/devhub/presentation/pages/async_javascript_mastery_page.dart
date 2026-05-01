import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class AsyncJavascriptMasteryPage extends StatefulWidget {
  const AsyncJavascriptMasteryPage({super.key});

  @override
  State<AsyncJavascriptMasteryPage> createState() => _AsyncJavascriptMasteryPageState();
}

class _AsyncJavascriptMasteryPageState extends State<AsyncJavascriptMasteryPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () { if (context.canPop()) { context.pop(); } else { context.go('/devhub'); } },
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Async JavaScript\nMastery',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Intermediate • ~5hrs • 3 variants',
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
              '25%',
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
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Brief', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF1FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                  ),
                  child: const Text(
                    "Master asynchronous JavaScript by handling real-world tasks involving API calls, timers, parallel requests, and error recovery — without using any external libraries.\n\n"
                    "What you'll build:\n"
                    "A dashboard that fetches and displays live data from a public API (your choice: weather, GitHub users, news, etc.), with loading states, error handling, and a refresh timer.\n\n"
                    "Deliverables to submit:\n"
                    "• Source files (.html + .js) — vanilla JS only, no frameworks or axios\n"
                    "• Must demonstrate all three async patterns: callbacks (at least 1 use), Promises (at least 2 .then() chains), and async/await (at least 2 functions)\n"
                    "• Implement Promise.all() to fetch at least 2 endpoints in parallel\n"
                    "• Error handling: show a user-friendly error message when the API fails (you can simulate this)\n"
                    "• A timer.js file showing a countdown or polling mechanism using setInterval and clearInterval\n"
                    "• Short write-up (50-100 words) comparing when you'd use Promises vs async/await in a real project\n\n"
                    "Acceptance criteria: No unhandled promise rejections, loading spinner visible during fetch, works on Chrome without any build step.",
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
                      context.push('/devhub/async-javascript-mastery/submit');
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
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
