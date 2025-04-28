import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/screens/auth/login_screen.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_logo_widget.dart';

class SuccessfullyChangePasswordScreen extends StatefulWidget {
  const SuccessfullyChangePasswordScreen({super.key});

  @override
  State<SuccessfullyChangePasswordScreen> createState() => _SuccessfullyChangePasswordScreenState();
}

class _SuccessfullyChangePasswordScreenState extends State<SuccessfullyChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// Logo
              const CommonLogoWidget(),

              /// Space
              const SizedBox(
                height: 20,
              ),

              /// Title
              Text(
                AppLocalizations.of(context)!.congratulations,
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              /// Space
              const SizedBox(
                height: 8,
              ),

              /// Description
              SizedBox(
                width: 250,
                child: Text(
                  AppLocalizations.of(context)!
                      .yourPasswordChangedSuccessfully,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              /// Space
              const SizedBox(
                height: 50,
              ),


              /// Space
              const SizedBox(
                height: 48,
              ),

              /// Go To Login
              CommonButtonWidget(
                textColor: Colors.white,
                borderColor: AppColors.mainColor,
                buttonText:
                AppLocalizations.of(context)!.login.toUpperCase(),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                           const LoginScreen(),
                      ));
                },
                buttonBackgroundColor: AppColors.mainColor,
              ),

              /// Space
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
