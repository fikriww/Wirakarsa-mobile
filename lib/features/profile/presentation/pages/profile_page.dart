import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/models/user_model.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/competition_card.dart';
import '../widgets/skill_progress.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  int _selectedTab = 0; // 0 for My Profile, 1 for Settings

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);
    
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
              _buildProfileContent(userProfileAsync)
            else
              _buildSettingsContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(AsyncValue<UserModel?> userProfileAsync) {
    final userProfile = userProfileAsync.value;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileHeaderCard(
          name: userProfile?.displayName ?? 'User',
          role: userProfile?.role ?? 'Frontend Developer',
        ),
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
        const SizedBox(height: 16),

        // Documents (CV + Transcript) — mirrors the web DocumentsCard.
        _buildDocumentsSection(userProfile),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDocumentsSection(UserModel? userProfile) {
    final cvUrl = (userProfile?.preferences['cvUrl'] ?? '') as String;
    final transcriptUrl =
        (userProfile?.preferences['transcriptUrl'] ?? '') as String;
    final hasDocs = cvUrl.isNotEmpty || transcriptUrl.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Documents',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (!hasDocs)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 28,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No documents uploaded yet',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            if (cvUrl.isNotEmpty)
              _buildDocumentRow(
                icon: Icons.description_outlined,
                iconColor: AppColors.primaryBlue,
                title: 'CV',
                filename: cvUrl.split('/').last,
                url: cvUrl,
              ),
            if (cvUrl.isNotEmpty && transcriptUrl.isNotEmpty)
              const SizedBox(height: 12),
            if (transcriptUrl.isNotEmpty)
              _buildDocumentRow(
                icon: Icons.article_outlined,
                iconColor: const Color(0xFFF59E0B),
                title: 'Transcript',
                filename: transcriptUrl.split('/').last,
                url: transcriptUrl,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String filename,
    required String url,
  }) {
    return InkWell(
      onTap: () => _openDocument(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    filename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.download_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDocument(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final messenger = ScaffoldMessenger.of(context);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open document')),
      );
    }
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
            final router = GoRouter.of(context);
            await ref.read(apiServiceProvider).logout();
            ref.read(userProfileProvider.notifier).logout();
            router.go('/sign-in');
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
