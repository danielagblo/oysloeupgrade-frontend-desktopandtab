import 'package:flutter/material.dart';
import '../widgets/auth_layout.dart';
import '../widgets/custom_widgets.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';
import 'referral_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();
  bool _agreeToTerms = false;
  bool _isLoading = false;

  // Form validation states
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _retypePasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? _validatePhone(String phone) {
    if (phone.isEmpty) return 'Phone number is required';
    if (phone.length < 10) return 'Enter a valid phone number';
    return null;
  }

  void _validateForm() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Name is required' : null;
      _emailError = _validateEmail(_emailController.text);
      _phoneError = _validatePhone(_phoneController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _retypePasswordError = _passwordController.text != _retypePasswordController.text
          ? 'Passwords do not match' : null;
    });
  }

  bool get _isFormValid {
    return _nameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _passwordError == null &&
        _retypePasswordError == null &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _retypePasswordController.text.isNotEmpty;
  }

  Future<void> _handleSignUp() async {
    _validateForm();

    if (!_isFormValid || !_agreeToTerms) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ReferralScreen(),
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
            'Get started',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            hintText: 'Name',
            icon: Icons.person_outline,
            controller: _nameController,
            errorText: _nameError,
            onChanged: (value) {
              setState(() {
                _nameError = value.isEmpty ? 'Name is required' : null;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Email Address',
            icon: Icons.email_outlined,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
            onChanged: (value) {
              setState(() {
                _emailError = _validateEmail(value);
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: '+233',
            icon: Icons.phone_outlined,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            errorText: _phoneError,
            onChanged: (value) {
              setState(() {
                _phoneError = _validatePhone(value);
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Password',
            icon: Icons.lock_outline,
            controller: _passwordController,
            isPassword: true,
            errorText: _passwordError,
            onChanged: (value) {
              setState(() {
                _passwordError = _validatePassword(value);
                if (_retypePasswordController.text.isNotEmpty) {
                  _retypePasswordError = value != _retypePasswordController.text
                      ? 'Passwords do not match' : null;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Retype Password',
            icon: Icons.lock_outline,
            controller: _retypePasswordController,
            isPassword: true,
            errorText: _retypePasswordError,
            onChanged: (value) {
              setState(() {
                _retypePasswordError = _passwordController.text != value
                    ? 'Passwords do not match' : null;
              });
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Expanded(
                child: Text(
                  'I have agreed to the Privacy policy and terms & conditions',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Sign up',
            isLoading: _isLoading,
            onPressed: (_agreeToTerms && _isFormValid) ? _handleSignUp : null,
          ),
          const SizedBox(height: 24),
          GoogleSignInButton(
            onPressed: () {
              print('Google sign up pressed');
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "I have an account already ? ",
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