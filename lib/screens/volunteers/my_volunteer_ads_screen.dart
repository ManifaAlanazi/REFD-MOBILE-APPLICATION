import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/models/volunteer_model.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';
import 'package:refd_app/widgets/common_volunteer_item_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyVolunteerAdsScreen extends StatefulWidget {
  const MyVolunteerAdsScreen({super.key});

  @override
  State<MyVolunteerAdsScreen> createState() => _MyVolunteerAdsScreenState();
}

class _MyVolunteerAdsScreenState extends State<MyVolunteerAdsScreen> {
  late VolunteerCubit volunteerCubit;

  @override
  void initState() {
    volunteerCubit = BlocProvider.of(context);
    volunteerCubit.getMyVolunteers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VolunteerCubit, VolunteerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetMyVolunteersLoadingState) {
          return const Center(child: CommonLoaderWidget());
        } else {
          if (volunteerCubit.myVolunteersList.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noDataFound),
            );
          } else {
            return ListView.separated(
              itemCount: volunteerCubit.myVolunteersList.length,
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
                    id: volunteerCubit.myVolunteersList[index].id,
                    city: volunteerCubit.myVolunteersList[index].city,
                    description:
                        volunteerCubit.myVolunteersList[index].description,
                    eventEndDate:
                        volunteerCubit.myVolunteersList[index].eventEndDate,
                    gender: volunteerCubit.myVolunteersList[index].gender,
                    hours: volunteerCubit.myVolunteersList[index].hours,
                    image: volunteerCubit.myVolunteersList[index].image,
                    numberOfVolunteer: volunteerCubit
                        .myVolunteersList[index].numberOfVolunteer,
                    title: volunteerCubit.myVolunteersList[index].title,
                    userID: volunteerCubit.myVolunteersList[index].userID,
                    userAdded: volunteerCubit.myVolunteersList[index].userAdded,
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
