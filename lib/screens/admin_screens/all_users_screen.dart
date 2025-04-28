import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/widgets/common_cached_image_widget.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late VolunteerCubit volunteerCubit;

  @override
  void initState() {
    volunteerCubit = BlocProvider.of(context);
    volunteerCubit.getAllUsersForAdmin();
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
          AppLocalizations.of(context)!.allUsers,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: BlocConsumer<VolunteerCubit, VolunteerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetAllUsersForAdminLoadingState) {
            return const Center(child: CommonLoaderWidget());
          } else {
            if (volunteerCubit.usersListForAdmin.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noDataFound),
              );
            } else {
              return RefreshIndicator(
                onRefresh: volunteerCubit.getAllUsersForAdmin,
                child: ListView.separated(
                  itemCount: volunteerCubit.usersListForAdmin.length,
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.whiteColor,
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
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CommonCachedImageWidget(
                              imagePath: volunteerCubit
                                  .usersListForAdmin[index].userImage,
                              width: 65,
                              height: 65,
                              loaderSize: 25,
                            ),
                          ),

                          /// Space
                          const SizedBox(
                            width: 16,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                volunteerCubit
                                    .usersListForAdmin[index].fullName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              /// Space
                              const SizedBox(
                                height: 2,
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  volunteerCubit.usersListForAdmin[index].email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),

                              /// Space
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                volunteerCubit.usersListForAdmin[index].phone,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),

                              /// Space
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                volunteerCubit.usersListForAdmin[index].gender,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
