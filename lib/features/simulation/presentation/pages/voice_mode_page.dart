import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Column(
          children: [
            Text(
              'Career Simulation',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Voice Mode',
              style: GoogleFonts.poppins(
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
            icon: const Icon(
              Icons.access_time_outlined,
              color: AppColors.textPrimary,
              size: 22,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(flex: 1),

          // Blue gradient circle with pulse animation
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF90CAF9),
                    AppColors.primaryBlue,
                    const Color(0xFF1565C0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Sound wave bars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(9, (index) {
              final heights = [12.0, 20.0, 28.0, 16.0, 32.0, 16.0, 28.0, 20.0, 12.0];
              return Container(
                width: 4,
                height: heights[index],
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // "Listening." text
          Text(
            'Listening.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),

          const Spacer(flex: 1),

          // Timer
          Text(
            '05:00',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.error,
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
                  icon: Icons.videocam_off_outlined,
                  size: 52,
                  onTap: () {},
                ),
                // Mic button (larger, primary)
                _CircleButton(
                  icon: Icons.mic_outlined,
                  size: 64,
                  isPrimary: true,
                  onTap: () {},
                ),
                // More options button
                _CircleButton(
                  icon: Icons.more_horiz,
                  size: 52,
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
                ? AppColors.primaryBlue.withValues(alpha: 0.3)
                : AppColors.divider,
            width: isPrimary ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: isPrimary ? 28 : 24,
          color: isPrimary
              ? AppColors.primaryBlue
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}
