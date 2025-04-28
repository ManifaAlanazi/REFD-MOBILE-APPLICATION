import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:refd_app/config/local_storage/shared_preference.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/helpers/validators.dart';
import 'package:refd_app/logic/auth_cubit/auth_cubit.dart';
import 'package:refd_app/logic/auth_cubit/auth_states.dart';
import 'package:refd_app/logic/bottom_navigation_cubit/bottom_navigation_cubit.dart';
import 'package:refd_app/screens/auth/forget_password_screen.dart';
import 'package:refd_app/screens/auth/register_screen.dart';
import 'package:refd_app/screens/intro/index_screen.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/common_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit authCubit;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> checkBiometric() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    debugPrint('Biometrics supported: $canCheckBiometrics');
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await _localAuthentication.getAvailableBiometrics();
    debugPrint('Available biometrics: $availableBiometrics');
  }

  Future<void> authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
    }
    if (isAuthenticated) {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Helpers.showRequestMessageResponse(
          message: AppLocalizations.of(context)!.enterEmailAndPasswordFirst,
          context: context,
          isError: true,
        );
      } else {
        authCubit.login(
          email: emailController.text,
          password: passwordController.text,
        );
      }

      debugPrint('Biometric authentication successful');
    } else {
      debugPrint('Biometric authentication failed');
    }
  }

  @override
  void initState() {
    authCubit = BlocProvider.of(context);
    emailController = TextEditingController();
    passwordController = TextEditingController();
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
          if (state is LoginLoadingState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const RequestLoadingWidget(),
            );
          }

          /// If Success
          if (state is LoginSuccessState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.loginSuccessfully,
              context: context,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const IndexScreen(),
              ),
              (route) => false,
            );
            BottomNavigationCubit.get(context).changeIndex(0);
          }

          /// If Error
          if (state is LoginErrorState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: state.error.toString(),
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
                        AppLocalizations.of(context)!.login.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
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
                                  CommonTextFormField(
                                    radius: 32.0,
                                    controller: emailController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.email,
                                    keyboardType: TextInputType.emailAddress,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CommonTextFormField(
                                    radius: 32.0,
                                    controller: passwordController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.password,
                                    keyboardType: TextInputType.text,
                                    isPassword: true,
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgetPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .forgetYourPassword,
                                    style: const TextStyle(
                                      color: AppColors.greyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24.0,
                            ),

                            /// Make Login
                            Row(
                              children: [
                                Expanded(
                                  child: CommonButtonWidget(
                                    textColor: AppColors.whiteColor,
                                    borderColor: AppColors.mainColor,
                                    buttonText: AppLocalizations.of(context)!
                                        .login2
                                        .toUpperCase(),
                                    onTap: () {
                                      if (emailController.text.trim().isEmpty) {
                                        Helpers.showRequestMessageResponse(
                                          message: "Enter email",
                                          context: context,
                                          isError: true,
                                        );
                                      } else if (!Validators()
                                          .emailRegExp
                                          .hasMatch(
                                              emailController.text.trim())) {
                                        Helpers.showRequestMessageResponse(
                                          message: "Enter valid email",
                                          context: context,
                                          isError: true,
                                        );
                                      } else if (passwordController.text
                                          .trim()
                                          .isEmpty) {
                                        Helpers.showRequestMessageResponse(
                                          message: "Enter password",
                                          context: context,
                                          isError: true,
                                        );
                                      } else {
                                        checkBiometric();
                                        getAvailableBiometrics();
                                        authenticate();
                                      }
                                    },
                                    buttonBackgroundColor: AppColors.mainColor,
                                  ),
                                ),

                                /// Space
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.mainColor,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // checkBiometric();
                                      //getAvailableBiometrics();
                                      authenticate();
                                    },
                                    icon: const Icon(
                                      Icons.fingerprint,
                                      color: AppColors.whiteColor,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            /// Space
                            const SizedBox(
                              height: 22,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.dontHaveAccount,
                                  style: const TextStyle(
                                    color: AppColors.darkColor,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen(),
                                        ));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.signUp,
                                    style: const TextStyle(
                                      color: AppColors.secondColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
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
