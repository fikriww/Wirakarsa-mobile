import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class ReactComponentBasicPage extends StatefulWidget {
  const ReactComponentBasicPage({super.key});

  @override
  State<ReactComponentBasicPage> createState() => _ReactComponentBasicPageState();
}

class _ReactComponentBasicPageState extends State<ReactComponentBasicPage> {
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
              'React Component\nBasic',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Intermediate • ~4hrs • 4 variants',
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
              '40%',
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
                    "Build a responsive landing page that includes a navbar, hero section, and call-to-action. Focus on clean component architecture and proper props/state management.\n\n"
                    "What you'll build:\n"
                    "A marketing landing page for a fictional SaaS product of your choice — be creative with the theme.\n\n"
                    "Deliverables to submit:\n"
                    "• GitHub repo link or .zip with all source files\n"
                    "• The page must be broken into at least 6 separate components (Navbar, Hero, FeatureCard, CTAButton, Footer, etc.)\n"
                    "• Props must be used to pass at least 3 dynamic values (e.g. headline text, feature list, CTA label)\n"
                    "• One component must manage local state (e.g. mobile menu toggle, tab switcher)\n"
                    "• Live demo link (Vercel, Netlify, or CodeSandbox) — required\n\n"
                    "Acceptance criteria: No prop drilling beyond 2 levels, no inline styles, mobile-responsive, deploys without errors.",
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
                      context.push('/devhub/react-component-basic/submit');
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

      ),
    );
  }
}
