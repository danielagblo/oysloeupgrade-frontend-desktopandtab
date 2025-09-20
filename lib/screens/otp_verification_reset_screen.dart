import 'package:flutter/material.dart';
import '../widgets/auth_layout.dart';
import '../widgets/custom_widgets.dart';
import '../utils/app_colors.dart';
import 'set_new_password_screen.dart';
import 'login_screen.dart';

class OTPVerificationResetScreen extends StatefulWidget {
  final String? email;
  final String? phoneNumber;
  final bool isEmail;

  const OTPVerificationResetScreen({
    super.key,
    this.email,
    this.phoneNumber,
    required this.isEmail,
  });

  @override
  State<OTPVerificationResetScreen> createState() => _OTPVerificationResetScreenState();
}

class _OTPVerificationResetScreenState extends State<OTPVerificationResetScreen> {
  final List<TextEditingController> _otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
  List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _hasError = false;
  bool _isResending = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOTPChanged(String value, int index) {
    setState(() {
      _hasError = false;
    });

    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOTP() async {
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length < 6) {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete 6-digit code')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call to verify OTP
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetNewPasswordScreen(
            email: widget.email,
            phoneNumber: widget.phoneNumber,
          ),
        ),
      );
    }
  }

  Future<void> _resendOTP() async {
    setState(() => _isResending = true);

    // Simulate API call to resend OTP
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isResending = false);

    // Clear existing OTP
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _otpFocusNodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'New code sent to ${widget.isEmail ? widget.email : widget.phoneNumber}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactInfo = widget.isEmail ? widget.email : widget.phoneNumber;

    return AuthLayout(
      title: "User Safety\nGuarantee",
      description: "Buyers and sellers undergo strict checks and verification to ensure authenticity and reliability",
      currentStep: 1,
      leftPanel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verify Code',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: 'Enter the 6-digit verification code sent to ',
                ),
                TextSpan(
                  text: contactInfo ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return OTPInputField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                onChanged: (value) => _onOTPChanged(value, index),
                hasError: _hasError,
              );
            }),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Verify Code',
            isLoading: _isLoading,
            onPressed: _verifyOTP,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Didn't receive the code? ",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: _isResending ? null : _resendOTP,
                child: Text(
                  _isResending ? 'Sending...' : 'Resend',
                  style: TextStyle(
                    color: _isResending ? AppColors.textSecondary : AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'Need Help?',
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
                text: 'Back to Login',
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                },
              ),
              const SizedBox(width: 32),
              TextLink(
                text: 'Try Different Method',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}