import 'package:flutter/material.dart';

/// Shared bottom navigation bar used across multiple pages.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Figma Design Specifications
    const Color activeColor = Color(0xFF066EFF);
    const Color inactiveColor = Colors.black;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, bottom: 20),
        child: Container(
          height: 63,
          constraints: const BoxConstraints(maxWidth: 364),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14131927), // #13192714
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: -2,
              ),
              BoxShadow(
                color: Color(0x1F131927), // #1319271F
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: 'Readiness',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.terminal_outlined,
                activeIcon: Icons.terminal,
                label: 'Dev Hub',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.sms_outlined,
                activeIcon: Icons.sms,
                label: 'Simulation',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.account_circle_outlined,
                activeIcon: Icons.account_circle,
                label: 'Profile',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final bool isSelected = currentIndex == index;
    final Color color = isSelected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 50,
        height: 36,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 24,
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 8,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
