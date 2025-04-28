import 'package:flutter/material.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/screens/auth/register_screen.dart';
import 'package:refd_app/screens/intro/index_screen.dart';
import 'package:refd_app/screens/auth/login_screen.dart';
import 'package:refd_app/widgets/common_asset_svg_image_widget.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/widgets/common_logo_widget.dart';

class ChooseActionScreen extends StatefulWidget {
  const ChooseActionScreen({super.key});

  @override
  State<ChooseActionScreen> createState() => _ChooseActionScreenState();
}

class _ChooseActionScreenState extends State<ChooseActionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            const CommonLogoWidget(),

            /// Space
            const SizedBox(
              height: 50,
            ),

            /// Skip Register
            CommonButtonWidget(
              textColor: Colors.white,
              borderColor: AppColors.mainColor,
              buttonText:
                  AppLocalizations.of(context)!.skipRegistration.toUpperCase(),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IndexScreen()),
                    (route) => false);
              },
              buttonBackgroundColor: AppColors.mainColor,
            ),

            /// Space
            const SizedBox(
              height: 24,
            ),

            /// Login
            CommonButtonWidget(
              textColor: Colors.white,
              borderColor: AppColors.mainColor,
              buttonText: AppLocalizations.of(context)!.login2.toUpperCase(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              buttonBackgroundColor: AppColors.mainColor,
            ),

            /// Space
            const SizedBox(
              height: 24,
            ),

            /// Create Account
            CommonButtonWidget(
              textColor: Colors.white,
              borderColor: AppColors.mainColor,
              buttonText:
                  AppLocalizations.of(context)!.createAccount.toUpperCase(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              buttonBackgroundColor: AppColors.mainColor,
            )
          ],
        ),
      ),
    );
  }
}
