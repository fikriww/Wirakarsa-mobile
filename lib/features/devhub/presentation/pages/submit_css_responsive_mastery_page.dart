import 'package:flutter/material.dart';
import '../widgets/evaluation_result_page.dart';

class SubmitCssResponsiveMasteryPage extends StatelessWidget {
  const SubmitCssResponsiveMasteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EvaluationResultPage(
      projectTitle: 'CSS Responsive Mastery',
      projectDescription:
          'Proyek CSS Responsive Mastery telah diulas dengan hasil sangat baik. Implementasi aksesibilitas dan responsivitas menunjukkan pemahaman mendalam terhadap standar WCAG 2.1 AA. Lighthouse score 97 menunjukkan performa yang luar biasa.',
      score: 93,
      passed: true,
      criteriaMetCount: 3,
      criteriaTotalCount: 3,
      estimatedDuration: '4 hours',
      evaluationCriteria: [
        EvaluationCriteriaItem(label: 'Kesesuaian dengan brief proyek', passed: true),
        EvaluationCriteriaItem(label: 'Pengorganisasian kode & file', passed: true),
        EvaluationCriteriaItem(label: 'Optimasi dan Best Practices', passed: true),
      ],
      strengths: [
        'Aksesibilitas WCAG 2.1 AA terpenuhi dengan sangat baik.',
        'Lighthouse score mencapai 97, menunjukkan performa halaman yang optimal.',
        'Responsive design di semua breakpoint berjalan sempurna.',
      ],
      recommendations: [
        'Minor: Focus ring pada modal perlu diperbaiki untuk browser Firefox.',
        'Pertimbangkan penambahan dark mode untuk meningkatkan pengalaman pengguna.',
        'Dokumentasi CSS custom properties bisa lebih detail untuk maintainability.',
      ],
      skillTags: ['HTML', 'CSS', 'Accessibility', 'Responsive Design'],
    );
  }
}
