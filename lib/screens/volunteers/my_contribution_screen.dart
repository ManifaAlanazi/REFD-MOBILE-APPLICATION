import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/models/volunteer_model.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';
import 'package:refd_app/widgets/common_volunteer_item_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyContributionScreen extends StatefulWidget {
  const MyContributionScreen({super.key});

  @override
  State<MyContributionScreen> createState() => _MyContributionScreenState();
}

class _MyContributionScreenState extends State<MyContributionScreen> {
  late VolunteerCubit volunteerCubit;

  @override
  void initState() {
    volunteerCubit = BlocProvider.of(context);
    volunteerCubit.getMyContributions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VolunteerCubit, VolunteerStates>(
      listener: (context, state) {
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
        if (state is GetMyContributionsLoadingState) {
          return const Center(child: CommonLoaderWidget());
        } else {
          if (volunteerCubit.myContributionsRequests.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noDataFound),
            );
          } else {
            return ListView.separated(
              itemCount: volunteerCubit.myContributionsRequests.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 16,
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CommonVolunteerItemWidget(
                  volunteerModel: VolunteerModel(
                    id: volunteerCubit.myContributionsRequests[index].id,
                    city: volunteerCubit.myContributionsRequests[index].city,
                    description: volunteerCubit
                        .myContributionsRequests[index].description,
                    eventEndDate: volunteerCubit
                        .myContributionsRequests[index].eventEndDate,
                    gender:
                        volunteerCubit.myContributionsRequests[index].gender,
                    hours: volunteerCubit.myContributionsRequests[index].hours,
                    image: volunteerCubit.myContributionsRequests[index].image,
                    numberOfVolunteer: volunteerCubit
                        .myContributionsRequests[index].numberOfVolunteer,
                    title: volunteerCubit.myContributionsRequests[index].title,
                    userID:
                        volunteerCubit.myContributionsRequests[index].userID,
                    userAdded:
                        volunteerCubit.myContributionsRequests[index].userAdded,
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
