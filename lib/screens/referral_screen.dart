import 'package:flutter/material.dart';
import '../widgets/auth_layout.dart';
import '../widgets/custom_widgets.dart';
import '../utils/app_colors.dart';
import 'success_screen.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final TextEditingController _referralController = TextEditingController();

  @override
  void dispose() {
    _referralController.dispose();
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
          const Spacer(flex: 2),
          CustomTextField(
            hintText: 'Referal code (Optional)',
            icon: Icons.tag_outlined,
            controller: _referralController,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Verify',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuccessScreen(
                    message: 'Account created successfully',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuccessScreen(
                      message: 'Account created successfully',
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}