import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
          'Help & Support',
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
          Text(
            'Get help with using Wirapath',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              children: const [
                _ExpandableSupportTile(
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions',
                  content:
                      'Find answers to common questions about Wirapath, '
                      'including account setup, skill assessments, career '
                      'simulations, and how to get the most out of the platform.',
                ),
                Divider(height: 1, color: AppColors.divider),
                _ExpandableSupportTile(
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  content:
                      'Need help? Reach out to our support team at '
                      'support@wirapath.com or use the in-app chat. '
                      'We typically respond within 24 hours on business days.',
                ),
                Divider(height: 1, color: AppColors.divider),
                _ExpandableSupportTile(
                  title: 'Report a Bug',
                  subtitle: 'Let us know about issues',
                  content:
                      'Found something that doesn\'t work right? Please describe '
                      'the issue, steps to reproduce it, and your device info. '
                      'Send reports to bugs@wirapath.com.',
                ),
                Divider(height: 1, color: AppColors.divider),
                _ExpandableSupportTile(
                  title: 'Feature Request',
                  subtitle: 'Suggest new features',
                  content:
                      'We love hearing your ideas! Share your feature suggestions '
                      'to help us improve Wirapath. Submit requests to '
                      'feedback@wirapath.com.',
                ),
                Divider(height: 1, color: AppColors.divider),
                _ExpandableSupportTile(
                  title: 'Terms of Service',
                  subtitle: 'Review our terms',
                  content:
                      'By using Wirapath, you agree to our Terms of Service. '
                      'These terms cover your rights, responsibilities, and '
                      'the rules for using our platform and services.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableSupportTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String content;

  const _ExpandableSupportTile({
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  State<_ExpandableSupportTile> createState() => _ExpandableSupportTileState();
}

class _ExpandableSupportTileState extends State<_ExpandableSupportTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggle,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textHint,
                    size: 16,
                  ),
                ),
              ],
            ),
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Text(
                  widget.content,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
