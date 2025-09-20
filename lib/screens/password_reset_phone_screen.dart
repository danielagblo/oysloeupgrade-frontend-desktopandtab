import 'package:flutter/material.dart';
import '../widgets/auth_layout.dart';
import '../widgets/custom_widgets.dart';
import '../utils/app_colors.dart';
import 'password_reset_email_screen.dart';
import 'otp_verification_reset_screen.dart';
import 'signup_screen.dart';

class PasswordResetPhoneScreen extends StatefulWidget {
  const PasswordResetPhoneScreen({super.key});

  @override
  State<PasswordResetPhoneScreen> createState() => _PasswordResetPhoneScreenState();
}

class _PasswordResetPhoneScreenState extends State<PasswordResetPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitReset() async {
    if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call to send OTP to phone
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationResetScreen(
            phoneNumber: _phoneController.text,
            isEmail: false,
          ),
        ),
      );
    }
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
            'Reset Password',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            hintText: '+233',
            icon: Icons.phone_outlined,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          const Text(
            "We'll send a verification link to the number if it's beign in our system",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Send Code',
            isLoading: _isLoading,
            onPressed: _submitReset,
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PasswordResetEmailScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 32),
              TextLink(
                text: 'Login',
                onTap: () {
                  Navigator.pop(context);
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