import 'package:flutter/material.dart';
import '../widgets/auth_layout.dart';
import '../widgets/custom_widgets.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String? email;
  final String? phoneNumber;

  const SetNewPasswordScreen({
    super.key,
    this.email,
    this.phoneNumber,
  });

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Form validation states
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      return 'Password must contain uppercase, lowercase and number';
    }
    return null;
  }

  String? _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) return 'Please confirm your password';
    if (confirmPassword != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  void _validateForm() {
    setState(() {
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError = _validateConfirmPassword(_confirmPasswordController.text);
    });
  }

  bool get _isFormValid {
    return _passwordError == null &&
        _confirmPasswordError == null &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 40,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Password Reset\nSuccessful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'You can now login with your new password',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue to Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _resetPassword() async {
    _validateForm();

    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    // Simulate API call to update password
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    _showSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
    final resetMethod = widget.email != null ? widget.email : widget.phoneNumber;

    return AuthLayout(
      title: "User Safety\nGuarantee",
      description: "Buyers and sellers undergo strict checks and verification to ensure authenticity and reliability",
      currentStep: 2,
      leftPanel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set New Password',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (resetMethod != null) ...[
            Text(
              'Creating new password for $resetMethod',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
          ] else ...[
            const Text(
              'Enter your new password below',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
          ],
          CustomTextField(
            hintText: 'New Password',
            icon: Icons.lock_outline,
            controller: _passwordController,
            isPassword: true,
            errorText: _passwordError,
            onChanged: (value) {
              setState(() {
                _passwordError = _validatePassword(value);
                if (_confirmPasswordController.text.isNotEmpty) {
                  _confirmPasswordError = _validateConfirmPassword(_confirmPasswordController.text);
                }
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Confirm New Password',
            icon: Icons.lock_outline,
            controller: _confirmPasswordController,
            isPassword: true,
            errorText: _confirmPasswordError,
            onChanged: (value) {
              setState(() {
                _confirmPasswordError = _validateConfirmPassword(value);
              });
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Password must contain at least 8 characters with uppercase, lowercase, and number',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Update Password',
            isLoading: _isLoading,
            onPressed: _isFormValid ? _resetPassword : null,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Remember your password? ",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                },
                child: const Text(
                  'Login',
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