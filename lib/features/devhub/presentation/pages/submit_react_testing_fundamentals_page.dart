import 'package:flutter/material.dart';
import '../widgets/evaluation_result_page.dart';

class SubmitReactTestingFundamentalsPage extends StatelessWidget {
  const SubmitReactTestingFundamentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EvaluationResultPage(
      projectTitle: 'React Testing Fundamentals',
      projectDescription:
          'Proyek React Testing Fundamentals telah diulas dan dinilai baik. Penggunaan file menunjukkan kekuatan dalam aspek yang sesuai untuk peran Developer. Kode atas, terkembang ke dalam praktek terbaik, best practices, optimasi komponen/performa, dan dokumentasi yang lebih mendalam.',
      score: 78,
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
        'Menunjukkan pemahaman dasar yang baik tentang scenario proyek.',
        'Struktur file dan pengorganisasian kode/dokumen tampil terstruktur dengan rapi.',
        'Implementasi memenuhi aspek-aspek dasar yang diminta dalam brief proyek.',
      ],
      recommendations: [
        'Dengan menguatkan validasi input/output dan error handling, aplikasi akan lebih lengkap.',
        'Pertimbangan performa atau penulisan kode bersama yang lebih modular.',
        'Pertimbangan untuk membuat modular dengan membangun pola modular/extensible agar kode lebih mudah di-maintain dan di-scale.',
      ],
      skillTags: ['React', 'Jest', 'Testing Library', 'TDD'],
    );
  }
}
