import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/logic/auth_cubit/auth_cubit.dart';
import 'package:refd_app/logic/auth_cubit/auth_states.dart';
import 'package:refd_app/widgets/common_asset_svg_image_widget.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/common_text_form_field.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(
          AppLocalizations.of(context)!.editPassword,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
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
        listener: (authContext, authState) {
          /// If Loading
          if (authState is UpdatePasswordLoadingState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const RequestLoadingWidget(),
            );
          }

          /// If Success
          if (authState is UpdatePasswordSuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.updatedSuccessfully,
              context: context,
            );
          }

          /// If Error
          if (authState is UpdatePasswordErrorState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: authState.error.toString(),
              context: context,
              isError: true,
            );
          }
        },
        builder: (authContext, authState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// Space
                    const SizedBox(
                      height: 32,
                    ),

                    /// Logo
                    const CommonAssetSvgImageWidget(
                      name: "edit.svg",
                      height: 150,
                      width: 200,
                    ),

                    /// Space
                    const SizedBox(
                      height: 32,
                    ),

                    /// Password
                    CommonTextFormField(
                      radius: 32.0,
                      controller: passwordController,
                      validate: (value) {
                        return null;
                      },
                      labelTitle: AppLocalizations.of(context)!.newPassword,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                    ),

                    /// Space
                    const SizedBox(
                      height: 16,
                    ),

                    /// Confirm Password
                    CommonTextFormField(
                      radius: 32.0,
                      controller: confirmPasswordController,
                      validate: (value) {
                        if (value!.trim() != passwordController.text) {
                          return AppLocalizations.of(context)!
                              .confirmPasswordNotMatch;
                        } else {
                          return null;
                        }
                      },
                      labelTitle:
                          AppLocalizations.of(context)!.confirmNewPassword,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                    ),

                    /// Space
                    const SizedBox(
                      height: 32,
                    ),

                    /// Make Register
                    CommonButtonWidget(
                      textColor: Colors.white,
                      borderColor: AppColors.mainColor,
                      buttonText:
                          AppLocalizations.of(context)!.update.toUpperCase(),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          AuthCubit.get(context).updatePassword(
                              newPassword: passwordController.text);
                        }
                      },
                      buttonBackgroundColor: AppColors.mainColor,
                    ),

                    /// Space
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
