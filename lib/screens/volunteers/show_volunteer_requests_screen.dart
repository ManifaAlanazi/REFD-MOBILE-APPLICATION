import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';

class ShowVolunteerRequestsScreen extends StatefulWidget {
  final String volunteerID;

  const ShowVolunteerRequestsScreen({
    super.key,
    required this.volunteerID,
  });

  @override
  State<ShowVolunteerRequestsScreen> createState() =>
      _ShowVolunteerRequestsScreenState();
}

class _ShowVolunteerRequestsScreenState
    extends State<ShowVolunteerRequestsScreen> {
  late VolunteerCubit volunteerCubit;

  @override
  void initState() {
    volunteerCubit = BlocProvider.of(context);
    volunteerCubit.getVolunteerRequests(volunteerID: widget.volunteerID);
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
          AppLocalizations.of(context)!.requests,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<VolunteerCubit, VolunteerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetVolunteerRequestsLoadingState) {
            return const Center(child: CommonLoaderWidget());
          } else {
            if (volunteerCubit.volunteerRequests.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noDataFound),
              );
            } else {
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: volunteerCubit.volunteerRequests.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            0,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .receivingNewStudent
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkColor,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Text(
                              "Event title : ${volunteerCubit.volunteerRequests[index].volunteerTitle}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Username : ${volunteerCubit.volunteerRequests[index].userName}",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        if (volunteerCubit
                                .volunteerRequests[index].requestStatus ==
                            "accept") ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: AppColors.successColor,
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Text(
                                  AppLocalizations.of(context)!.accepted,
                                  style: const TextStyle(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ] else if (volunteerCubit
                                .volunteerRequests[index].requestStatus ==
                            "refuse") ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: AppColors.errorColor,
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Text(
                                  AppLocalizations.of(context)!.refused,
                                  style: const TextStyle(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ] else ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: AppColors.secondColor,
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Text(
                                  AppLocalizations.of(context)!.waiting,
                                  style: const TextStyle(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
