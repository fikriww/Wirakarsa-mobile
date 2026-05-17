import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/competition_card.dart';
import '../widgets/skill_progress.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0; // 0 for My Profile, 1 for Settings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tabs
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: _selectedTab == 0
                        ? AppColors.primaryBlue
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(
                        color: AppColors.primaryBlue,
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTab = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'My Profile',
                            style: TextStyle(
                              color: _selectedTab == 0
                                  ? Colors.white
                                  : AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: _selectedTab == 1
                        ? AppColors.primaryBlue
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(
                        color: AppColors.primaryBlue,
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTab = 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              color: _selectedTab == 1
                                  ? Colors.white
                                  : AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            if (_selectedTab == 0)
              _buildProfileContent()
            else
              _buildSettingsContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: SupabaseService.getProfile(),
      builder: (context, snapshot) {
        String displayName = 'John Doe';
        if (snapshot.hasData && snapshot.data != null) {
          final profile = snapshot.data!;
          final firstName = profile['first_name'] ?? '';
          final lastName = profile['last_name'] ?? '';
          if (firstName.isNotEmpty || lastName.isNotEmpty) {
            displayName = '$firstName $lastName'.trim();
          } else {
            displayName = profile['full_name'] ?? SupabaseService.currentUser?.email ?? 'John Doe';
          }
        } else {
          displayName = SupabaseService.currentUser?.email ?? 'John Doe';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeaderCard(name: displayName, role: 'Frontend Developer'),
            const SizedBox(height: 16),

            // Stats
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCard(value: '63%', label: 'Readiness\nIndex'),
                StatCard(value: '2', label: 'Skills That Need\nImproved'),
                StatCard(value: '4', label: 'Mini\nProject'),
                StatCard(value: '3x', label: 'Skill Test\nAttempts'),
              ],
            ),
            const SizedBox(height: 24),

            // Validated Competitions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Validated Competitions',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  CompetitionCard(
                    title: 'Fundamental React Testing',
                    equivalent: 'Meta Front-End Developer (Module 5)',
                    code: 'TEST L3',
                    date: 'Mar 8, 2026',
                  ),
                  SizedBox(height: 12),
                  CompetitionCard(
                    title: 'CSS Responsive Mastery',
                    equivalent: 'W3C FWD Certificate (Module 3)',
                    code: 'HCEV L3',
                    date: 'Mar 2, 2026',
                  ),
                  SizedBox(height: 12),
                  CompetitionCard(
                    title: 'React Component Architecture',
                    equivalent: 'Meta Front-End Developer (Module 6)',
                    code: 'PROG-REACT L3',
                    date: 'Mar 8, 2026',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Your Skill Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Skill Details',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  SkillProgress(
                    title: 'Testing (Jest)',
                    percentage: 30,
                    code: 'TEST L3',
                    date: 'Mar 9, 2026',
                    progressColor: AppColors.error,
                  ),
                  SizedBox(height: 16),
                  SkillProgress(
                    title: 'Web Performance',
                    percentage: 55,
                    code: 'SINT L3',
                    date: 'Mar 5, 2026',
                    progressColor: AppColors.error,
                  ),
                  SizedBox(height: 16),
                  SkillProgress(
                    title: 'Accessibility',
                    percentage: 50,
                    code: 'USEV L2',
                    date: 'Mar 4, 2026',
                    progressColor: Color(0xFFF59E0B),
                  ),
                  SizedBox(height: 16),
                  SkillProgress(
                    title: 'State Management',
                    percentage: 85,
                    code: 'PROG-SM L3',
                    date: 'Mar 6, 2026',
                    progressColor: AppColors.success,
                  ),
                  SizedBox(height: 16),
                  SkillProgress(
                    title: 'React.js',
                    percentage: 80,
                    code: 'PROG-SM L3',
                    date: 'Mar 6, 2026',
                    progressColor: AppColors.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildSettingsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsSection(
          title: 'Account Settings',
          items: [
            SettingsTile(
              icon: Icons.person_outline,
              title: 'Personal Information',
              route: '/personal-information',
            ),
            SettingsTile(
              icon: Icons.security,
              title: 'Password & Security',
              route: '/password-security',
            ),
            SettingsTile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              route: '/notifications',
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SettingsSection(
          title: 'Preferences',
          items: [
            SettingsTile(
              icon: Icons.language,
              title: 'Language & Appearance',
              route: '/language-appearance',
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SettingsSection(
          title: 'Integrations & Support',
          items: [
            SettingsTile(
              icon: Icons.link,
              title: 'Integrations',
              route: '/integrations',
            ),
            SettingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              route: '/help-support',
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Logout Button
        ElevatedButton(
          onPressed: () async {
            try {
              await SupabaseService.signOut();
              if (mounted) {
                context.go('/sign-in');
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sign out failed: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Log Out',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
