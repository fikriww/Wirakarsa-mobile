import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class ReactTestingFundamentalsPage extends StatefulWidget {
  const ReactTestingFundamentalsPage({super.key});

  @override
  State<ReactTestingFundamentalsPage> createState() => _ReactTestingFundamentalsPageState();
}

class _ReactTestingFundamentalsPageState extends State<ReactTestingFundamentalsPage> {
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
              'React Testing\nFundamentals',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Intermediate • ~6hrs • 4 variants',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
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
              '70%',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
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
              const Text(
                'Brief',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1FF), 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.1)),
                ),
                child: const Text(
                  "Build a complete checkout form using TDD — write failing tests first, then implement the component to make them pass. You'll use Jest + React Testing Library throughout.\n\n"
                  "What you'll build:\n"
                  "A multi-step checkout form with fields for shipping address, payment method, and order summary.\n\n"
                  "Deliverables to submit:\n"
                  "• Source code (GitHub repo link or .zip) containing your component files and all test files\n"
                  "• Tests must cover: form validation (empty fields, invalid card number, invalid email), successful form submission, step navigation (next/back), and error state rendering\n"
                  "• Minimum 15 passing test cases\n"
                  "• A short README.md explaining your testing strategy and any edge cases you handled\n\n"
                  "Acceptance criteria: All tests pass with npm test, code coverage ≥ 80%, no console errors.",
                  style: TextStyle(fontSize: 13, height: 1.6, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'My Work',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue[600]!),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.attach_file, color: Colors.blue, size: 20),
                label: const Text(
                  'Attach',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/devhub/react-testing-fundamentals/submit');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD), 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit Project',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 80), 
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
}
