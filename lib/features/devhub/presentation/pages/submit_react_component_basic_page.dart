import 'package:flutter/material.dart';
import '../widgets/evaluation_result_page.dart';

class SubmitReactComponentBasicPage extends StatelessWidget {
  const SubmitReactComponentBasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EvaluationResultPage(
      projectTitle: 'React Component Basic',
      projectDescription:
          'Proyek React Component Basic telah diulas. Beberapa aspek penting masih perlu diperbaiki, termasuk live demo link yang belum tersedia dan penggunaan prop drilling yang berlebihan. Perbaikan diperlukan sebelum diterima.',
      score: 68,
      passed: false,
      criteriaMetCount: 1,
      criteriaTotalCount: 3,
      estimatedDuration: '4 hours',
      evaluationCriteria: [
        EvaluationCriteriaItem(label: 'Kesesuaian dengan brief proyek', passed: true),
        EvaluationCriteriaItem(label: 'Pengorganisasian kode & file', passed: false),
        EvaluationCriteriaItem(label: 'Optimasi dan Best Practices', passed: false),
      ],
      strengths: [
        'Jumlah komponen sudah memenuhi target minimal (7 komponen).',
        'Penggunaan props cukup baik dengan lebih dari 3 dynamic props.',
        'State management lokal sudah diimplementasikan.',
      ],
      recommendations: [
        'Live demo link harus disertakan (hard requirement) — gunakan Vercel, Netlify, atau CodeSandbox.',
        'Hindari prop drilling lebih dari 2 level, pertimbangkan Context API.',
        'Ganti inline styles (ditemukan 4 instance) dengan CSS modules atau styled-components.',
      ],
      skillTags: ['React', 'JavaScript', 'Component Design', 'State Management'],
    );
  }
}
