import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Donut chart widget for displaying evaluation scores.
/// Uses the app's original theme colors (AppColors).
class ScoreDonutChart extends StatelessWidget {
  final int score;
  final int maxScore;
  final double size;

  const ScoreDonutChart({
    super.key,
    required this.score,
    this.maxScore = 100,
    this.size = 170,
  });

  String get _label {
    if (score >= 90) return 'EXCELLENT';
    if (score >= 70) return 'GOOD';
    if (score >= 50) return 'FAIR';
    return 'POOR';
  }

  Color get _scoreColor {
    if (score >= 90) return AppColors.primaryBlue;
    if (score >= 70) return AppColors.success;
    if (score >= 50) return const Color(0xFFF59E0B);
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DonutPainter(
              score: score,
              maxScore: maxScore,
              activeColor: _scoreColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    '/$maxScore',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: _scoreColor,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final int score;
  final int maxScore;
  final Color activeColor;

  _DonutPainter({
    required this.score,
    required this.maxScore,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 14;
    const strokeWidth = 14.0;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.inputBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Score arc
    final sweepAngle = (score / maxScore) * 2 * math.pi;
    final scorePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      scorePaint,
    );

    // Small circle at start point
    final startX = center.dx + radius * math.cos(-math.pi / 2);
    final startY = center.dy + radius * math.sin(-math.pi / 2);
    canvas.drawCircle(
      Offset(startX, startY),
      3,
      Paint()..color = activeColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
