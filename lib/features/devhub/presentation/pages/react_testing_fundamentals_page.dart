import 'package:flutter/material.dart';
import '../widgets/project_detail_page.dart';

class ReactTestingFundamentalsPage extends StatelessWidget {
  const ReactTestingFundamentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProjectDetailPage(
      projectTitle: 'React Testing Fundamentals',
      level: 'Intermediate',
      duration: '~6 hrs',
      variants: 4,
      progressPercent: 70,
      submitRoute: '/devhub/react-testing-fundamentals/submit',
      briefText:
          "Build a complete checkout form using TDD — write failing tests first, then implement the component to make them pass. You'll use Jest + React Testing Library throughout.\n\n"
          "What you'll build:\n"
          "A multi-step checkout form with fields for shipping address, payment method, and order summary.\n\n"
          "Deliverables to submit:\n"
          "• Source code (GitHub repo link or .zip) containing your component files and all test files\n"
          "• Tests must cover: form validation (empty fields, invalid card number, invalid email), successful form submission, step navigation (next/back), and error state rendering\n"
          "• Minimum 15 passing test cases\n"
          "• A short README.md explaining your testing strategy and any edge cases you handled\n\n"
          "Acceptance criteria: All tests pass with npm test, code coverage ≥ 80%, no console errors.",
    );
  }
}
