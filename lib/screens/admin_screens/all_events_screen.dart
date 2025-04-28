import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/common_volunteer_item_widget.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
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
          AppLocalizations.of(context)!.events,
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
            // Navigator.pop(context);
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
            volunteerCubit.getAllVolunteer();
          }
        },
        builder: (context, state) {
          if (state is GetAllVolunteerLoadingState) {
            return const Center(child: CommonLoaderWidget());
          } else {
            if (volunteerCubit.getAllVolunteersForAdmin.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noDataFound),
              );
            } else {
              return RefreshIndicator(
                onRefresh: volunteerCubit.getAllVolunteer,
                child: ListView.separated(
                  itemCount: volunteerCubit.getAllVolunteersForAdmin.length,
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                  itemBuilder: (context, index) {
                    return CommonVolunteerItemWidget(
                      isCenter: true,
                      volunteerModel:
                          volunteerCubit.getAllVolunteersForAdmin[index],
                    );
                    // return Text(volunteerCubit.usersListForAdmin[index].fullName);
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
