import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';

class SocialLoginRow extends StatelessWidget {
  /// Whether this row is shown on the sign-up screen. Controls whether a
  /// first-time GitHub login is allowed to create a new account.
  final bool isSignUp;

  const SocialLoginRow({super.key, this.isSignUp = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "Or Continue With"
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or Continue With',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.divider)),
          ],
        ),
        const SizedBox(height: 24),
        // Social Icons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              icon: Icons.facebook,
              color: AppColors.facebook,
              onTap: () {},
            ),
            const SizedBox(width: 20),
            _SocialButton(
              svgAsset: 'assets/icons/google.svg',
              onTap: () async {
                final String redirectUri = kIsWeb ? '${Uri.base.origin}/#/oauth-callback' : '';
                final String queryParams = redirectUri.isNotEmpty
                    ? '?redirect_uri=${Uri.encodeComponent(redirectUri)}'
                    : '';
                final url = Uri.parse('http://localhost:3000/google-login$queryParams');
                try {
                  await launchUrl(
                    url,
                    mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
                  );
                } catch (e) {
                  debugPrint('Failed to launch Google OAuth: $e');
                }
              },
              iconSize: 24,
            ),
            const SizedBox(width: 20),
            _SocialButton(
              svgAsset: 'assets/icons/github.svg',
              onTap: () async {
                // Open the web GitHub-login entry point in the system browser.
                // After authenticating, /oauth-callback hands the session tokens
                // back to the app via the wirapath:// deep link (native) or the
                // hash-route callback (web).
                final String redirectUri = kIsWeb
                    ? '${Uri.base.origin}/#/oauth-callback'
                    : 'wirapath://oauth-callback';
                final url = Uri.parse(
                  'http://localhost:3000/github-login'
                  '?is_signup=$isSignUp'
                  '&redirect_uri=${Uri.encodeComponent(redirectUri)}',
                );
                try {
                  await launchUrl(
                    url,
                    mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
                  );
                } catch (e) {
                  debugPrint('Failed to launch GitHub OAuth: $e');
                }
              },
              iconSize: 24,
            ),
            const SizedBox(width: 20),
            _SocialButton(
              icon: Icons.apple,
              color: AppColors.apple,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData? icon;
  final String? svgAsset;
  final Color? color;
  final VoidCallback onTap;
  final double iconSize;

  const _SocialButton({
    this.icon,
    this.svgAsset,
    this.color,
    required this.onTap,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: svgAsset != null
              ? SvgPicture.asset(
                  svgAsset!,
                  width: iconSize,
                  height: iconSize,
                )
              : Icon(
                  icon,
                  color: color,
                  size: iconSize,
                ),
        ),
      ),
    );
  }
}
