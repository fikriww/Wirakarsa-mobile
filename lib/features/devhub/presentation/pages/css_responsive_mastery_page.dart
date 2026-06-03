import 'package:flutter/material.dart';
import '../widgets/project_detail_page.dart';

class CssResponsiveMasteryPage extends StatelessWidget {
  const CssResponsiveMasteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProjectDetailPage(
      projectTitle: 'CSS Responsive Mastery',
      level: 'Intermediate',
      duration: '~4 hrs',
      variants: 3,
      progressPercent: 10,
      submitRoute: '/devhub/css-responsive-mastery/submit',
      briefText:
          "Build a fully accessible UI component library following WCAG 2.1 AA standards. Components must be responsive across mobile, tablet, and desktop breakpoints.\n\n"
          "What you'll build:\n"
          "A component library containing: navigation bar, hero banner, card grid, modal dialog, and form with validation states.\n\n"
          "Deliverables to submit:\n"
          "• A single index.html + styles.css file (no frameworks — vanilla CSS only)\n"
          "• Screenshot or screen recording showing all 3 breakpoints (375px, 768px, 1280px)\n"
          "• Accessibility audit report exported from Lighthouse or axe DevTools (score ≥ 90)\n"
          "• A written note (50-100 words) on how you handled keyboard navigation and color contrast\n\n"
          "Acceptance criteria: No horizontal scroll at any breakpoint, all interactive elements keyboard-accessible, passes Lighthouse accessibility audit.",
    );
  }
}
