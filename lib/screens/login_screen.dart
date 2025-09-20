import 'package:flutter/material.dart';
import '../widgets/auth_layout.dart';
import '../widgets/custom_widgets.dart';
import '../utils/app_colors.dart';
import 'password_reset_method.dart';
import 'otp_login_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: "User Safety\nGuarantee",
      description: "Buyers and sellers undergo strict checks and verification to ensure authenticity and reliability",
      currentStep: 0,
      leftPanel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            hintText: 'Email Address',
            icon: Icons.email_outlined,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Password',
            icon: Icons.lock_outline,
            controller: _passwordController,
            isPassword: true,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Login',
            onPressed: () {
              // Handle login logic here
              print('Login pressed');
            },
          ),
          const SizedBox(height: 24),
          GoogleSignInButton(
            onPressed: () {
              // Handle Google sign in
              print('Google sign in pressed');
            },
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Cant Login?',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextLink(
                text: 'Password Reset',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PasswordResetMethodScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 32),
              TextLink(
                text: 'OTP Login',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OTPLoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account ? ",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}