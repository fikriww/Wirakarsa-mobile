import 'dart:math' as math;
import 'package:flutter/material.dart';

/// --- CUSTOM PAINTER UNTUK SKILL MAP (RADAR CHART) ---
class RadarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.8;

    final List<String> labels = [
      "Testing/Debug",
      "Web Performance",
      "Accessibility",
      "State Management",
      "UI/UX",
      "Unit",
    ];

    final List<Color> dotColors = [
      Colors.red,
      Colors.red,
      Colors.orange,
      const Color(0xFF22C55E),
      const Color(0xFF22C55E),
      const Color(0xFF22C55E),
    ];

    // Persentase skill berdasarkan gambar (dummy values agar mirip visualnya)
    final List<double> values = [0.8, 0.7, 0.65, 0.85, 0.75, 0.6];

    final linePaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Gambar Jaring Heksagon (Web)
    for (var i = 1; i <= 5; i++) {
      final currentRadius = radius * (i / 5);
      final path = Path();
      for (var j = 0; j < 6; j++) {
        final angle = (j * 60) * math.pi / 180 - (math.pi / 2);
        final x = center.dx + currentRadius * math.cos(angle);
        final y = center.dy + currentRadius * math.sin(angle);
        if (j == 0) path.moveTo(x, y); else path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, linePaint);
    }

    // 2. Gambar Garis Penghubung Tengah
    for (var j = 0; j < 6; j++) {
      final angle = (j * 60) * math.pi / 180 - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), linePaint);
    }

    // 3. Gambar Area Skill (Biru Transparan)
    final skillPath = Path();
    final skillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (var j = 0; j < 6; j++) {
      final angle = (j * 60) * math.pi / 180 - (math.pi / 2);
      final valRadius = radius * values[j];
      final x = center.dx + valRadius * math.cos(angle);
      final y = center.dy + valRadius * math.sin(angle);
      if (j == 0) skillPath.moveTo(x, y); else skillPath.lineTo(x, y);
    }
    skillPath.close();
    canvas.drawPath(skillPath, skillPaint);

    // 4. Gambar Label & Dot Berwarna
    for (var j = 0; j < 6; j++) {
      final angle = (j * 60) * math.pi / 180 - (math.pi / 2);
      final labelRadius = radius + 25;
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);

      // Gambar Dot
      final dotPaint = Paint()..color = dotColors[j];
      final dotPos = Offset(
        center.dx + (radius + 10) * math.cos(angle),
        center.dy + (radius + 10) * math.sin(angle),
      );
      canvas.drawCircle(dotPos, 4, dotPaint);

      // Gambar Teks Label
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[j],
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
