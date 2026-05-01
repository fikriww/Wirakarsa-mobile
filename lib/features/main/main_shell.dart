import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../simulation/presentation/pages/career_simulation_page.dart';
import '../home/presentation/pages/home_page.dart';
import '../readiness/presentation/pages/readiness_center_page.dart';
import '../devhub/presentation/pages/devhub_page.dart';
import '../profile/presentation/pages/profile_page.dart';

class MainShell extends StatefulWidget {
  final int currentIndex;
  final int? initialReadinessTabIndex;
  final bool? initialDevhubCodeReviewActive;
  final Widget? child;

  const MainShell({
    super.key,
    this.currentIndex = 0,
    this.initialReadinessTabIndex,
    this.initialDevhubCodeReviewActive,
    this.child,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(MainShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      setState(() {
        _currentIndex = widget.currentIndex;
      });
    }
  }

  Widget _buildCurrentPage() {
    if (widget.child != null) return widget.child!;
    switch (_currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return ReadinessCenterPage(
          initialTabIndex: widget.initialReadinessTabIndex ?? 0,
        );
      case 2:
        return DevhubPage(
          initialIsCodeReviewActive: widget.initialDevhubCodeReviewActive ?? false,
        );
      case 3:
        return const CareerSimulationPage();
      case 4:
        return const ProfilePage();
      default:
        return const _PlaceholderPage(
          title: 'Home',
          icon: Icons.home_outlined,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          key: ValueKey<int>(_currentIndex),
          child: _buildCurrentPage(),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

/// Placeholder page for tabs not yet implemented
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
