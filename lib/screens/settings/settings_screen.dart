import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/config/local_storage/shared_preference.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/auth_cubit/auth_cubit.dart';
import 'package:refd_app/logic/auth_cubit/auth_states.dart';
import 'package:refd_app/screens/intro/choose_action_screen.dart';
import 'package:refd_app/screens/settings/edit_informations_screen.dart';
import 'package:refd_app/screens/settings/edit_password_screen.dart';
import 'package:refd_app/screens/settings/faq_screen.dart';
import 'package:refd_app/screens/settings/guid_lines_screen.dart';
import 'package:refd_app/screens/settings/terms_and_conditions_screen.dart';
import 'package:refd_app/screens/volunteers/my_volunteer_requests_screen.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/drawer_list_tile_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        children: [
          Text(
            AppLocalizations.of(context)!.settings,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// Login
          if (SharedText.userToken == null) ...[
            CommonDrawerListTileItemWidget(
              showIcon: true,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChooseActionScreen(),
                    ),
                    (route) => false);
              },
              title: AppLocalizations.of(context)!.login,
              icon: Icons.login,
              iconColor: AppColors.mainColor,
            ),
          ],

          /// Logout
          if (SharedText.userToken != null) ...[
            /// Update Info
            CommonDrawerListTileItemWidget(
              showIcon: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateInformationScreen(),
                  ),
                );
              },
              title: AppLocalizations.of(context)!.updateMyInfo,
              icon: Icons.edit,
              iconColor: AppColors.mainColor,
            ),

            /// Update Password
            CommonDrawerListTileItemWidget(
              showIcon: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdatePasswordScreen(),
                  ),
                );
              },
              title: AppLocalizations.of(context)!.editPassword,
              icon: Icons.edit,
              iconColor: AppColors.mainColor,
            ),

            BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {
                /// If Loading
                if (state is LogoutLoadingState) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const RequestLoadingWidget(),
                  );
                }

                /// If Success
                if (state is LogoutSuccessState) {
                  Navigator.pop(context);
                  SharedPreference.clearData();
                  Helpers.showRequestMessageResponse(
                    message: AppLocalizations.of(context)!.logoutSuccessfully,
                    context: context,
                  );
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseActionScreen(),
                      ),
                      (route) => false);
                }

                /// If Error
                if (state is LogoutErrorState) {
                  Navigator.pop(context);
                  Helpers.showRequestMessageResponse(
                    message: state.error,
                    context: context,
                    isError: true,
                  );
                }
              },
              builder: (context, state) {
                return CommonDrawerListTileItemWidget(
                  showIcon: true,
                  onTap: () {
                    AuthCubit.get(context).logout();
                  },
                  title: AppLocalizations.of(context)!.logout,
                  icon: Icons.logout,
                  color: AppColors.errorColor,
                  iconColor: AppColors.errorColor,
                );
              },
            ),
          ],

          /// Divider
          const Divider(
            height: 1,
            thickness: 0.3,
          ),

          if (SharedText.userModel != null &&
              SharedText.userModel!.roleID != 1) ...[
            /// Space
            const SizedBox(
              height: 16,
            ),

            Text(
              AppLocalizations.of(context)!.general,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// Terms And Conditions
            CommonDrawerListTileItemWidget(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditionsScreen(),
                    ));
              },
              title: AppLocalizations.of(context)!.termsAndConditions,
              icon: Icons.article,
              iconColor: AppColors.mainColor,
            ),

            /// Divider
            const Divider(
              height: 1,
              thickness: 0.3,
            ),

            /// Frequently Asked Questions
            CommonDrawerListTileItemWidget(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FAQScreen(),
                    ));
              },
              title: AppLocalizations.of(context)!.frequentlyAskedQuestions,
              icon: Icons.article,
              iconColor: AppColors.mainColor,
            ),

            /// Divider
            const Divider(
              height: 1,
              thickness: 0.3,
            ),

            /// Guid Lines
            CommonDrawerListTileItemWidget(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GuidLinesScreen(),
                    ));
              },
              title: AppLocalizations.of(context)!.guidLines,
              icon: Icons.line_weight,
              iconColor: AppColors.mainColor,
            ),

            /// Requests
            if (SharedText.userModel != null) ...[
              CommonDrawerListTileItemWidget(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyVolunteerRequestsScreen(),
                      ));
                },
                title: AppLocalizations.of(context)!.requests,
                icon: Icons.request_page,
                iconColor: AppColors.mainColor,
              ),
            ],

            /// Space
            const SizedBox(
              height: 16,
            ),

            Text(
              AppLocalizations.of(context)!.contactUs,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// Email
            CommonDrawerListTileItemWidget(
              showIcon: false,
              onTap: () async {
                final Uri url = Uri.parse(
                  "mailto:refd@gmail.com",
                );
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              title: "refd@gmail.com",
              icon: Icons.email,
              iconColor: AppColors.mainColor,
            ),
          ]
        ],
      ),
    );
  }
}
