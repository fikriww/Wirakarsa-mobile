import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../../../core/providers/user_provider.dart';

class ConnectGithubPage extends ConsumerStatefulWidget {
  const ConnectGithubPage({super.key});

  @override
  ConsumerState<ConnectGithubPage> createState() => _ConnectGithubPageState();
}

class _ConnectGithubPageState extends ConsumerState<ConnectGithubPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  bool _isLoading = false;
  bool _hasError = false;
  bool _isSuccess = false;
  String _githubUsername = "";

  void _handleAuthorize() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Mock network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_emailController.text.toLowerCase().contains('error')) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    } else {
      final username = _emailController.text.split('@').first;
      
      // Save GitHub username to Firestore
      final user = ref.read(authServiceProvider).currentUser;
      if (user != null) {
        try {
          await ref.read(authServiceProvider).updateUserProfile(
            uid: user.uid,
            data: {
              'preferences': {
                'githubUsername': username,
              }
            },
          );
        } catch (e) {
          debugPrint('Error saving github username: $e');
        }
      }

      setState(() {
        _isLoading = false;
        _isSuccess = true;
        _githubUsername = username;
      });
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
                child: SvgPicture.asset(
                  'assets/icons/github.svg',
                  height: 80,
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
              "Login failed\nIncorrect username or password. Please try again.",
              style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFD32F2F)),
              textAlign: TextAlign.center,
            ),
          ),
          
        CustomTextField(
          label: 'Email or Username',
          hintText: 'Enter Your Email',
          prefixIcon: Icons.email_outlined,
          controller: _emailController,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Password',
          hintText: 'Enter Your Password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          obscureText: _obscurePassword,
          controller: _passwordController,
          onToggleVisibility: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
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
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Authorize Wirapath'),
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () => context.go('/home'),
            child: Text("Skip for now", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    final userProfile = ref.watch(userProfileProvider).value;
    final displayUsername = _githubUsername.isNotEmpty 
        ? _githubUsername 
        : (userProfile?.displayName.toLowerCase().replaceAll(' ', '-') ?? 'user');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9), // Light green background
            border: Border.all(color: const Color(0xFFC8E6C9)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("@$displayUsername", style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                  Text("github.com/$displayUsername", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF4CAF50))),
                ],
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
