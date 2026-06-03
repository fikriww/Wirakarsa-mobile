import 'package:flutter/material.dart';
import '../widgets/evaluation_result_page.dart';

class SubmitAsyncJavascriptMasteryPage extends StatelessWidget {
  const SubmitAsyncJavascriptMasteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EvaluationResultPage(
      projectTitle: 'Async JavaScript Mastery',
      projectDescription:
          'Proyek Async JavaScript Mastery telah diulas dan dinilai baik. Penggunaan async patterns sudah cukup baik, namun implementasi timer.js masih menggunakan setTimeout alih-alih setInterval, dan write-up terlalu pendek.',
      score: 82,
      passed: true,
      criteriaMetCount: 2,
      criteriaTotalCount: 3,
      estimatedDuration: '6 hours',
      evaluationCriteria: [
        EvaluationCriteriaItem(label: 'Kesesuaian dengan brief proyek', passed: true),
        EvaluationCriteriaItem(label: 'Pengorganisasian kode & file', passed: true),
        EvaluationCriteriaItem(label: 'Optimasi dan Best Practices', passed: false),
      ],
      strengths: [
        'Penggunaan async patterns (callbacks, Promises, async/await) sudah lengkap.',
        'Promise.all() diimplementasikan dengan benar untuk 2 endpoint.',
        'Error handling sudah diterapkan dengan baik di sebagian besar kode.',
      ],
      recommendations: [
        'Timer.js harus menggunakan setInterval, bukan setTimeout — ini adalah kebutuhan utama dari brief.',
        'Write-up terlalu pendek (38 kata), minimal 50-100 kata sesuai brief.',
        'Tambahkan loading states yang lebih informatif untuk pengalaman pengguna yang lebih baik.',
      ],
      skillTags: ['JavaScript', 'Async/Await', 'Promises', 'API Integration'],
    );
  }
}
