import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _projectUpdates = true;
  bool _skillProgress = true;
  bool _newSimulations = true;
  bool _codeReviewResults = true;
  bool _achievementUnlocked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Subtitle
          Text(
            'Choose what notifications you receive',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),

          // Notification items
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              children: [
                _buildNotificationTile(
                  title: 'Project updates',
                  subtitle: 'Get notified when project have new content',
                  value: _projectUpdates,
                  onChanged: (val) =>
                      setState(() => _projectUpdates = val),
                ),
                const Divider(height: 1, color: AppColors.divider),
                _buildNotificationTile(
                  title: 'Skill Progress',
                  subtitle: 'Weekly summary of your skill improvements',
                  value: _skillProgress,
                  onChanged: (val) =>
                      setState(() => _skillProgress = val),
                ),
                const Divider(height: 1, color: AppColors.divider),
                _buildNotificationTile(
                  title: 'New Simulations',
                  subtitle: 'New career simulation scenarios available',
                  value: _newSimulations,
                  onChanged: (val) =>
                      setState(() => _newSimulations = val),
                ),
                const Divider(height: 1, color: AppColors.divider),
                _buildNotificationTile(
                  title: 'Code Review Results',
                  subtitle: 'When AI completes your code review',
                  value: _codeReviewResults,
                  onChanged: (val) =>
                      setState(() => _codeReviewResults = val),
                ),
                const Divider(height: 1, color: AppColors.divider),
                _buildNotificationTile(
                  title: 'Achievement Unlocked',
                  subtitle: 'When you earn a new badge',
                  value: _achievementUnlocked,
                  onChanged: (val) =>
                      setState(() => _achievementUnlocked = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primaryBlue,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.divider,
            trackOutlineColor: WidgetStateProperty.resolveWith(
              (states) => Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
