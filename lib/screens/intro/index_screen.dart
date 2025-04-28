import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/bottom_navigation_cubit/bottom_navigation_cubit.dart';
import 'package:refd_app/logic/bottom_navigation_cubit/bottom_navigation_states.dart';
import 'package:refd_app/screens/admin_screens/all_events_screen.dart';
import 'package:refd_app/screens/admin_screens/all_requests_screen.dart';
import 'package:refd_app/screens/admin_screens/all_users_screen.dart';
import 'package:refd_app/screens/auth/my_profile_screen.dart';
import 'package:refd_app/screens/home_page_screen.dart';
import 'package:refd_app/screens/search_screen.dart';
import 'package:refd_app/screens/settings/settings_screen.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  late BottomNavigationCubit bottomNavigationCubit;

  @override
  void initState() {
    bottomNavigationCubit = BlocProvider.of(context);
    super.initState();
  }

  List<Widget> body = [
    SharedText.userModel != null && SharedText.userModel!.roleID == 1
        ? const AllUsersScreen()
        : const HomePageScreen(),
    SharedText.userModel != null && SharedText.userModel!.roleID == 1
        ? const AllEventsScreen()
        : const MyProfileScreen(),
    SharedText.userModel != null && SharedText.userModel!.roleID == 1
        ? const AllRequestsScreen()
        : const SearchScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BlocConsumer<BottomNavigationCubit, BottomNavigationStates>(
        listener: (bottomNavigationContext, bottomNavigationState) {},
        builder: (bottomNavigationContext, bottomNavigationState) {
          return Container(
            clipBehavior: Clip.antiAlias,
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Home
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      bottomNavigationCubit.changeIndex(0);
                    },
                    child: Container(
                      width: 75,
                      height: 80,
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          Container(
                            color: bottomNavigationCubit.index != 0
                                ? AppColors.whiteColor
                                : AppColors.secondColor,
                            width: double.infinity,
                            height: 3,
                          ),
                          const Spacer(),
                          Icon(
                            SharedText.userModel != null &&
                                    SharedText.userModel!.roleID == 1
                                ? Icons.account_box_sharp
                                : Icons.home,
                            size: 24,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            SharedText.userModel != null &&
                                    SharedText.userModel!.roleID == 1
                                ? AppLocalizations.of(context)!.allUsers
                                : AppLocalizations.of(context)!.home,
                            style: TextStyle(
                              fontWeight: bottomNavigationCubit.index != 0
                                  ? FontWeight.w400
                                  : FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  /// Explore
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      bottomNavigationCubit.changeIndex(1);
                    },
                    child: Container(
                      width: 75,
                      height: 80,
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          Container(
                            color: bottomNavigationCubit.index != 1
                                ? AppColors.whiteColor
                                : AppColors.secondColor,
                            width: double.infinity,
                            height: 3,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.supervised_user_circle,
                            size: 24,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            SharedText.userModel != null &&
                                    SharedText.userModel!.roleID == 1
                                ? AppLocalizations.of(context)!.events
                                : AppLocalizations.of(context)!.profile,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: bottomNavigationCubit.index != 1
                                  ? FontWeight.w400
                                  : FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  /// Add Ads
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      bottomNavigationCubit.changeIndex(2);
                    },
                    child: Container(
                      width: 75,
                      height: 80,
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          Container(
                            color: bottomNavigationCubit.index != 2
                                ? AppColors.whiteColor
                                : AppColors.secondColor,
                            width: double.infinity,
                            height: 3,
                          ),
                          const Spacer(),
                          Icon(
                            SharedText.userModel != null &&
                                    SharedText.userModel!.roleID == 1
                                ? Icons.request_page
                                : Icons.search,
                            size: 24,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            SharedText.userModel != null &&
                                    SharedText.userModel!.roleID == 1
                                ? AppLocalizations.of(context)!.requests
                                : AppLocalizations.of(context)!.search,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: bottomNavigationCubit.index != 2
                                  ? FontWeight.w400
                                  : FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  /// My Ads / Requests
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      bottomNavigationCubit.changeIndex(3);
                    },
                    child: Container(
                      width: 75,
                      height: 80,
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: [
                          Container(
                            color: bottomNavigationCubit.index != 3
                                ? AppColors.whiteColor
                                : AppColors.secondColor,
                            width: double.infinity,
                            height: 3,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.settings,
                            size: 24,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            AppLocalizations.of(context)!.settings,
                            style: TextStyle(
                              fontWeight: bottomNavigationCubit.index != 3
                                  ? FontWeight.w400
                                  : FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ]),
          );
        },
      ),
      body: BlocConsumer<BottomNavigationCubit, BottomNavigationStates>(
        listener: (bottomNavigationContext, bottomNavigationState) {},
        builder: (bottomNavigationContext, bottomNavigationState) {
          return body.elementAt(bottomNavigationCubit.index);
        },
      ),
    );
  }
}
