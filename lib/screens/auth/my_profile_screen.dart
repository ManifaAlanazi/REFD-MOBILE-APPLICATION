import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/screens/auth/login_screen.dart';
import 'package:refd_app/screens/volunteers/my_contribution_screen.dart';
import 'package:refd_app/screens/volunteers/my_volunteer_ads_screen.dart';
import 'package:refd_app/widgets/common_asset_image_widget.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_cached_image_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late VolunteerCubit volunteerCubit;

  @override
  void initState() {
    volunteerCubit = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.profile,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        body: SharedText.userModel == null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.makeLoginFirst,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    /// Space
                    const SizedBox(
                      height: 32.0,
                    ),

                    CommonButtonWidget(
                      textColor: Colors.white,
                      borderColor: AppColors.mainColor,
                      buttonText:
                          AppLocalizations.of(context)!.login.toUpperCase(),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      buttonBackgroundColor: AppColors.mainColor,
                    ),
                  ],
                ),
              )
            : BlocConsumer<VolunteerCubit, VolunteerStates>(
                listener: (context, state) {
                  /// If Deleted Loading
                  if (state is DeleteVolunteerLoadingState) {
                    Navigator.pop(context);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => const RequestLoadingWidget(),
                    );
                  }

                  /// If Deleted Success
                  if (state is DeleteVolunteerSuccessState) {
                    Navigator.pop(context);
                    VolunteerCubit.get(context).getMyVolunteers();
                    Helpers.showRequestMessageResponse(
                      message: AppLocalizations.of(context)!
                          .volunteerDeletedSuccessfully,
                      context: context,
                    );
                  }

                  /// If Success
                  if (state is RegisterOnVolunteerSuccessState) {
                    Navigator.pop(context);
                    Helpers.showRequestMessageResponse(
                      message: AppLocalizations.of(context)!
                          .youRegisteredSuccessfully,
                      context: context,
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      /// Space
                      const SizedBox(
                        height: 16.0,
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                0,
                                0,
                              ),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            /// User Image
                            Container(
                              alignment: Alignment.center,
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: SharedText.userModel!.userImage == ""
                                    ? const CommonAssetImage(
                                        width: 100,
                                        height: 100,
                                        imageName: "volunteer_image.jpeg",
                                      )
                                    : CommonCachedImageWidget(
                                        height: 100,
                                        width: 100,
                                        imagePath:
                                            SharedText.userModel!.userImage,
                                        loaderSize: 20,
                                      ),
                              ),
                            ),

                            /// Space
                            const SizedBox(
                              width: 16,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Space
                                const SizedBox(
                                  height: 8,
                                ),

                                /// Name
                                Text(
                                  SharedText.userModel!.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),

                                /// Gender
                                Text(
                                  SharedText.userModel!.gender,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),

                                /// Email
                                Text(
                                  SharedText.userModel!.email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),

                                /// Phone
                                Text(
                                  SharedText.userModel!.phone,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      /// Space
                      const SizedBox(
                        height: 16,
                      ),

                      /// Space
                      Divider(
                        thickness: 1.0,
                        color: AppColors.greyColor.withOpacity(0.1),
                      ),

                      /// Space
                      const SizedBox(
                        height: 16,
                      ),

                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.greyColor.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: TabBar(
                              padding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.zero,
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                color: AppColors.mainColor,
                                border: Border.all(color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              indicatorColor: AppColors.mainColor,
                              labelColor: AppColors.whiteColor,
                              tabs: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: double.infinity,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    AppLocalizations.of(context)!
                                        .myContribution,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: double.infinity,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    AppLocalizations.of(context)!
                                        .myVolunteerAds,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 290,
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: MyContributionScreen(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: MyVolunteerAdsScreen(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
