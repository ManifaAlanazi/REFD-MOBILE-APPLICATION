import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/logic/auth_cubit/auth_cubit.dart';
import 'package:refd_app/logic/auth_cubit/auth_states.dart';
import 'package:refd_app/screens/auth/verification_code_screen.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/common_text_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController emailController;
  late AuthCubit authCubit;

  @override
  void initState() {
    authCubit = BlocProvider.of(context);
    emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          /// If Loading
          if (state is SendOTPLoadingState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const RequestLoadingWidget(),
            );
          }

          /// If Success
          if (state is SendOTPSuccessState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.otpHasBeenSent,
              context: context,
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerificationCodeScreen(
                    email: emailController.text,
                  ),
                ));
          }

          /// If Error
          if (state is SendOTPErrorState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.otpFailed,
              context: context,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  AppColors.mainColor.withOpacity(0.9),
                  AppColors.mainColor.withOpacity(0.8),
                  AppColors.mainColor.withOpacity(0.4),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 80,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 30.0, right: 30.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .passwordRecovery
                            .toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// Space
                      const SizedBox(
                        height: 8,
                      ),

                      /// Description
                      SizedBox(
                        width: 200,
                        child: Text(
                          AppLocalizations.of(context)!
                              .enterYourEmailAddressToResetYourPassword,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60.0),
                        topRight: Radius.circular(60.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30.0),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius:
                                    BorderRadiusDirectional.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  /// Email
                                  CommonTextFormField(
                                    radius: 32.0,
                                    controller: emailController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle: "Email",
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ],
                              ),
                            ),

                            /// Space
                            const SizedBox(
                              height: 16,
                            ),

                            /// Send Code To Email
                            CommonButtonWidget(
                              textColor: Colors.white,
                              borderColor: AppColors.mainColor,
                              buttonText: AppLocalizations.of(context)!
                                  .sendCode
                                  .toUpperCase(),
                              onTap: () async {
                                authCubit.sendOTP(email: emailController.text);
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
