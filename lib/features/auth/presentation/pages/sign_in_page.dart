import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_login_row.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _authService = FirebaseAuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in successfully! Welcome back.'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        String message = e.toString();
        if (message.startsWith('Exception: ')) {
          message = message.substring(11);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Title
              Center(
                child: Column(
                  children: [
                    Text('Sign In', style: AppTextStyles.heading1),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome Back! Your Path is Waiting.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Email Field
              CustomTextField(
                label: 'Email or Username',
                hintText: 'Enter Your Email',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // Password Field
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

              const SizedBox(height: 16),

              // Remember Me + Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() => _rememberMe = value ?? false);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remember Me',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.link,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sign In Button
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _signIn,
                      child: const Text('Sign In'),
                    ),

              const SizedBox(height: 28),

              // Social Login
              const SocialLoginRow(),

              const SizedBox(height: 32),

              // Create Account Link
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New here? Your path starts now!',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => context.go('/create-account'),
                      child: Text(
                        'Create Account',
                        style: AppTextStyles.link,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
