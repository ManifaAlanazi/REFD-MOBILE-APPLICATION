import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/auth_cubit/auth_cubit.dart';
import 'package:refd_app/logic/auth_cubit/auth_states.dart';
import 'package:refd_app/widgets/common_asset_svg_image_widget.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/common_text_form_field.dart';

class UpdateInformationScreen extends StatefulWidget {
  const UpdateInformationScreen({super.key});

  @override
  State<UpdateInformationScreen> createState() =>
      _UpdateInformationScreenState();
}

class _UpdateInformationScreenState extends State<UpdateInformationScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    nameController = TextEditingController(
      text: SharedText.userModel!.fullName,
    );
    emailController = TextEditingController(
      text: SharedText.userModel!.email,
    );
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(
          AppLocalizations.of(context)!.updateMyInfo,
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
          if (authState is UpdateInfoLoadingState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const RequestLoadingWidget(),
            );
          }

          /// If Success
          if (authState is UpdateInfoSuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.updatedSuccessfully,
              context: context,
            );
          }

          /// If Error
          if (authState is UpdateInfoErrorState) {
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

                  /// Name
                  CommonTextFormField(
                    radius: 32.0,
                    controller: nameController,
                    validate: (value) {
                      return null;
                    },
                    labelTitle: AppLocalizations.of(context)!.fullName,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  /// Space
                  const SizedBox(
                    height: 16,
                  ),

                  /// Email
                  CommonTextFormField(
                    radius: 32.0,
                    controller: emailController,
                    validate: (value) {
                      return null;
                    },
                    labelTitle: AppLocalizations.of(context)!.email,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  /// Space
                  const SizedBox(
                    height: 32,
                  ),

                  /// Make Register
                  CommonButtonWidget(
                    textColor: Colors.white,
                    borderColor: AppColors.mainColor,
                    buttonText: AppLocalizations.of(context)!.update.toUpperCase(),
                    onTap: () {
                      AuthCubit.get(context).updateData(
                          email: emailController.text,
                          fullName: nameController.text);
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
          );
        },
      ),
    );
  }
}
