import 'package:flutter/material.dart';
import '../widgets/project_detail_page.dart';

class AsyncJavascriptMasteryPage extends StatelessWidget {
  const AsyncJavascriptMasteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProjectDetailPage(
      projectTitle: 'Async JavaScript Mastery',
      level: 'Intermediate',
      duration: '~5 hrs',
      variants: 3,
      progressPercent: 25,
      submitRoute: '/devhub/async-javascript-mastery/submit',
      briefText:
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
    );
  }
}
