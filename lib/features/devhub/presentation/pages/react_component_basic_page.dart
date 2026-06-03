import 'package:flutter/material.dart';
import '../widgets/project_detail_page.dart';

class ReactComponentBasicPage extends StatelessWidget {
  const ReactComponentBasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProjectDetailPage(
      projectTitle: 'React Component Basic',
      level: 'Intermediate',
      duration: '~4 hrs',
      variants: 4,
      progressPercent: 40,
      submitRoute: '/devhub/react-component-basic/submit',
      briefText:
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
    );
  }
}
