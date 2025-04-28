import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/screens/auth/login_screen.dart';
import 'package:refd_app/screens/volunteers/add_new_volunteer_screen.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/common_volunteer_item_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late VolunteerCubit volunteerCubit;

  @override
  void initState() {
    volunteerCubit = BlocProvider.of(context);
    volunteerCubit.getAllVolunteer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.home,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: BlocConsumer<VolunteerCubit, VolunteerStates>(
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
            Helpers.showRequestMessageResponse(
              message:
                  AppLocalizations.of(context)!.volunteerDeletedSuccessfully,
              context: context,
            );
          }

          /// If Success
          if (state is RegisterOnVolunteerSuccessState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.youRegisteredSuccessfully,
              context: context,
            );
          }

          /// If Error
          if (state is RegisterOnVolunteerErrorState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: state.error.toString(),
              context: context,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          if (state is GetAllVolunteerLoadingState) {
            return const Center(child: CommonLoaderWidget());
          } else {
            return RefreshIndicator(
              onRefresh: () => volunteerCubit.getAllVolunteer(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: [
                  /// Active Events
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.activeEvents,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// Space
                      const SizedBox(
                        height: 8,
                      ),

                      SizedBox(
                        height: 260,
                        child: volunteerCubit.activeVolunteerList.isEmpty
                            ? Center(
                                child: Text(
                                    AppLocalizations.of(context)!.noDataFound),
                              )
                            : ListView.separated(
                                itemCount:
                                    volunteerCubit.activeVolunteerList.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    width: 8,
                                  );
                                },
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return CommonVolunteerItemWidget(
                                    volunteerModel: volunteerCubit
                                        .activeVolunteerList[index],
                                  );
                                },
                              ),
                      )
                    ],
                  ),

                  /// Space
                  const SizedBox(
                    height: 16,
                  ),

                  /// Upcoming Events
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.upcomingEvents,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// Space
                      const SizedBox(
                        height: 8,
                      ),

                      SizedBox(
                        height: 260,
                        child: volunteerCubit.upComingVolunteerList.isEmpty
                            ? Center(
                                child: Text(
                                    AppLocalizations.of(context)!.noDataFound),
                              )
                            : ListView.separated(
                                itemCount:
                                    volunteerCubit.upComingVolunteerList.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    width: 8,
                                  );
                                },
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return CommonVolunteerItemWidget(
                                    volunteerModel: volunteerCubit
                                        .upComingVolunteerList[index],
                                  );
                                },
                              ),
                      )
                    ],
                  ),

                  /// Space
                  const SizedBox(
                    height: 16,
                  ),

                  /// Complete Events
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.completeEvents,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// Space
                      const SizedBox(
                        height: 8,
                      ),

                      SizedBox(
                        height: 260,
                        child: volunteerCubit.completeVolunteerList.isEmpty
                            ? Center(
                                child: Text(
                                    AppLocalizations.of(context)!.noDataFound),
                              )
                            : ListView.separated(
                                itemCount:
                                    volunteerCubit.completeVolunteerList.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    width: 8,
                                  );
                                },
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return CommonVolunteerItemWidget(
                                    volunteerModel: volunteerCubit
                                        .completeVolunteerList[index],
                                  );
                                },
                              ),
                      )
                    ],
                  ),

                  /// Statistics
                  Container(
                    padding: const EdgeInsets.all(
                      16.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: AppColors.mainColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(
                                      color:
                                          AppColors.greyColor.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Volunteers Hours",
                                      style: TextStyle(
                                        color: AppColors.mainColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    /// Space
                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      volunteerCubit.numberOfVolunteersHours
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: AppColors.secondColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// Space
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(
                                      color:
                                          AppColors.greyColor.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Volunteers",
                                      style: TextStyle(
                                        color: AppColors.mainColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    /// Space
                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      volunteerCubit
                                          .getAllVolunteersForAdmin.length
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: AppColors.secondColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// Space
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "( فمن تطوع خيرا فهو خيرا له )",
                          style: TextStyle(
                            color: AppColors.secondColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Space
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (SharedText.userModel == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewVolunteerScreen(),
              ),
            );
          }
        },
        backgroundColor: AppColors.mainColor,
        child: const Icon(
          Icons.add,
          size: 18,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
