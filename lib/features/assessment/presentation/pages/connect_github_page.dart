import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';

class ConnectGithubPage extends StatefulWidget {
  const ConnectGithubPage({super.key});

  @override
  State<ConnectGithubPage> createState() => _ConnectGithubPageState();
}

class _ConnectGithubPageState extends State<ConnectGithubPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  bool _isLoading = false;
  bool _hasError = false;
  bool _isSuccess = false;

  void _handleAuthorize() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Mock network delay
    await Future.delayed(const Duration(seconds: 1));

    // For demonstration, if email contains 'error', we show the error state.
    // Otherwise, we show the success state.
    if (_emailController.text.toLowerCase().contains('error')) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
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
                child: Image.asset(
                  'assets/images/github_logo.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.code,
                    size: 80,
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
            onTap: () => context.go('/devhub'),
            child: Text("Skip for now", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
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
                  Text("@john-doe", style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                  Text("github.com/john-doe", style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF4CAF50))),
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
          onPressed: () => context.go('/devhub'),
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
