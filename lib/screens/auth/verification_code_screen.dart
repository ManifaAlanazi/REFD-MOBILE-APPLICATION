import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/logic/auth_cubit/auth_cubit.dart';
import 'package:refd_app/logic/auth_cubit/auth_states.dart';
import 'package:refd_app/screens/auth/set_new_password_screen.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;

  const VerificationCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  late OtpFieldController otpController;
  late AuthCubit authCubit;
  String otpCode = "";

  @override
  void initState() {
    authCubit = BlocProvider.of(context);
    otpController = OtpFieldController();
    super.initState();
  }

  @override
  void dispose() {
    otpController.clear();
    super.dispose();
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
          if (state is ConfirmOTPCodeLoadingState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const RequestLoadingWidget(),
            );
          }

          /// If Success
          if (state is ConfirmOTPCodeSuccessState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.codeConfirmedSuccessfully,
              context: context,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SetNewPasswordScreen(
                  email: widget.email,
                ),
              ),
            );
          }

          /// If Error
          if (state is ConfirmOTPCodeErrorState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: "error when confirm otp code",
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
                            .verificationCode
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
                        width: 220,
                        child: Text(
                          "${AppLocalizations.of(context)!.weSendVerificationCodeTo} ${widget.email}",
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
                                  /// Verification OTP
                                  OTPTextField(
                                    otpFieldStyle: OtpFieldStyle(
                                      borderColor: AppColors.greyColor,
                                      backgroundColor:
                                          AppColors.textFormFieldBackground,
                                      focusBorderColor:
                                          AppColors.greyColor.withOpacity(0.3),
                                      enabledBorderColor:
                                          AppColors.greyColor.withOpacity(0.3),
                                    ),
                                    length: 4,
                                    width: MediaQuery.of(context).size.width,
                                    fieldWidth: 60,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textFieldAlignment:
                                        MainAxisAlignment.spaceAround,
                                    fieldStyle: FieldStyle.box,
                                    controller: otpController,
                                    onCompleted: (pin) {
                                      setState(() {
                                        otpCode = pin;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            /// Space
                            const SizedBox(
                              height: 16,
                            ),

                            /// Confirm Code
                            CommonButtonWidget(
                              textColor: Colors.white,
                              borderColor: AppColors.mainColor,
                              buttonText: AppLocalizations.of(context)!
                                  .confirmCode
                                  .toUpperCase(),
                              onTap: () {
                                authCubit.confirmOTPCode(otp: otpCode);
                              },
                              buttonBackgroundColor: AppColors.mainColor,
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
