import 'dart:math' as math;
import 'package:flutter/material.dart';

/// --- CUSTOM PAINTER UNTUK SKILL MAP (RADAR CHART) ---
class RadarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.8;

    final List<String> labels = [
      "Testing\n(Jest)",
      "Web\nPerformance",
      "Accessibility",
      "State\nManagement",
      "React.js",
      "CSS",
    ];

    final List<Color> dotColors = [
      const Color(0xFFD32F2F), // Testing
      const Color(0xFFD32F2F), // Web Performance
      const Color(0xFFF57F17), // Accessibility
      const Color(0xFF388E3C), // State Management
      const Color(0xFF388E3C), // React.js
      const Color(0xFF388E3C), // CSS
    ];

    // Persentase skill berdasarkan gambar (dummy values agar mirip visualnya)
    final List<double> values = [0.3, 0.15, 0.5, 0.85, 0.8, 0.83];

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
        textAlign: TextAlign.center,
      )..layout();
      
      double textX = dotPos.dx;
      double textY = dotPos.dy;

      // Horizontal alignment
      if (math.cos(angle) > 0.1) {
        textX += 10; // push to the right
      } else if (math.cos(angle) < -0.1) {
        textX -= textPainter.width + 10; // push to the left
      } else {
        textX -= textPainter.width / 2; // center horizontally
      }

      // Vertical alignment
      if (math.sin(angle) > 0.1) {
        if (math.cos(angle).abs() < 0.1) {
          textY += 10; // push down for bottom dot
        } else {
          textY = dotPos.dy - textPainter.height / 2 + 4; // center vertically with slight offset
        }
      } else if (math.sin(angle) < -0.1) {
        if (math.cos(angle).abs() < 0.1) {
          textY -= textPainter.height + 10; // push up for top dot
        } else {
          textY = dotPos.dy - textPainter.height / 2 - 4; // center vertically with slight offset
        }
      } else {
        textY -= textPainter.height / 2; // center vertically
      }

      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
