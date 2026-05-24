import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Voice Mode page - full screen listening interface
class VoiceModePage extends StatefulWidget {
  const VoiceModePage({super.key});

  @override
  State<VoiceModePage> createState() => _VoiceModePageState();
}

class _VoiceModePageState extends State<VoiceModePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          children: [
            Text(
              'Career Simulation',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Voice Mode',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: Column(
        children: [
          const Spacer(flex: 1),

          // Blue gradient circle with pulse animation
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  center: Alignment(-0.2, -0.2),
                  colors: [
                    Color(0xFFA6C8FF),
                    Color(0xFF066EFF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF066EFF).withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Sound wave bars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              final heights = [24.0, 32.0, 22.0, 36.0, 28.0, 34.0, 26.0];
              return Container(
                width: 8,
                height: heights[index],
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF066EFF),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // "Listening." text
          const Text(
            'Listening.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const Spacer(flex: 1),

          // Timer
          const Text(
            '05:00',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEE443F),
            ),
          ),

          const SizedBox(height: 24),

          // Bottom action buttons: Camera, Mic, More
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Camera button
                _CircleButton(
                  icon: Icons.videocam_outlined,
                  size: 60,
                  onTap: () {},
                ),
                // Mic button (larger, primary)
                _CircleButton(
                  icon: Icons.mic_none_rounded,
                  size: 72,
                  isPrimary: true,
                  onTap: () {},
                ),
                // More options button
                _CircleButton(
                  icon: Icons.more_horiz,
                  size: 60,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _CircleButton({
    required this.icon,
    required this.size,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(
            color: isPrimary
                ? AppColors.primaryBlue.withOpacity(0.3)
                : AppColors.divider,
            width: isPrimary ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: isPrimary ? 32 : 24,
          color: Colors.black,
        ),
      ),
    );
  }
}
