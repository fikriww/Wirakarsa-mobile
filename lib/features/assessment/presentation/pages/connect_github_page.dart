import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ConnectGithubPage extends StatefulWidget {
  const ConnectGithubPage({super.key});

  @override
  State<ConnectGithubPage> createState() => _ConnectGithubPageState();
}

class _ConnectGithubPageState extends State<ConnectGithubPage> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isSuccess = false;
  String _githubUsername = '';
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
    _subscribeToAuthChanges();
  }

  void _checkInitialStatus() {
    final username = SupabaseService.getConnectedGitHubUsername();
    if (username != null) {
      setState(() {
        _isSuccess = true;
        _githubUsername = username;
      });
    }
  }

  void _subscribeToAuthChanges() {
    _authSubscription = SupabaseService.client.auth.onAuthStateChange.listen((data) {
      final username = SupabaseService.getConnectedGitHubUsername();
      if (username != null && mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
          _githubUsername = username;
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  void _handleAuthorize() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Trigger Supabase OAuth flow to link GitHub identity
      await SupabaseService.linkGitHub();
    } catch (e) {
      final errorMessage = e.toString();
      final isSessionInvalid = errorMessage.contains('session_id') || 
                               errorMessage.contains('JWT') || 
                               errorMessage.contains('session') ||
                               errorMessage.contains('AuthException');

      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });

        if (isSessionInvalid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session is invalid or has expired. Redirecting to sign in...'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // Clear invalid session locally and redirect
          await SupabaseService.signOut();
          if (mounted) {
            context.go('/sign-in');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // GitHub Logo
              Center(
                child: Image.asset(
                  'assets/images/github_logo.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.code,
                    size: 80,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Connect GitHub",
                style: AppTextStyles.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              if (_isSuccess)
                _buildSuccessState()
              else
                _buildFormState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_hasError)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE), // Light red background
              border: Border.all(color: const Color(0xFFFFCDD2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Connection failed. Please try again.",
              style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFD32F2F)),
              textAlign: TextAlign.center,
            ),
          ),
          
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.security_outlined,
                color: AppColors.primaryBlue,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                "Secure Authorization",
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Wirapath accesses only public repository metadata to analyze your programming experience. We never access private code or modify your account.",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleAuthorize,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isLoading 
            ? const SizedBox(
                height: 20, 
                width: 20, 
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text('Authorize Wirapath'),
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () => context.go('/home'),
            child: Text(
              "Skip for now", 
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryBlue, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    final avatarUrl = SupabaseService.currentUser?.userMetadata?['avatar_url'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9), // Light green background
            border: Border.all(color: const Color(0xFFC8E6C9)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "@$_githubUsername", 
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF2E7D32), 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "github.com/$_githubUsername", 
                      style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF4CAF50)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Text(
          "Your GitHub account has been successfully connected.\nWiraPath will begin analyzing your contributions.",
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => context.go('/home'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
