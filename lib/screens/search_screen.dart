import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/models/volunteer_model.dart';
import 'package:refd_app/widgets/common_text_form_field.dart';
import 'package:refd_app/widgets/common_volunteer_item_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;
  late VolunteerCubit volunteerCubit;

  @override
  void initState() {
    volunteerCubit = BlocProvider.of(context);
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.search,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor),
        ),
      ),
      body: BlocConsumer<VolunteerCubit, VolunteerStates>(
        listener: (context, state) {
          /// If Success
          if (state is RegisterOnVolunteerSuccessState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.youRegisteredSuccessfully,
              context: context,
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              /// Space
              const SizedBox(
                height: 16,
              ),

              /// Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CommonTextFormField(
                  radius: 32.0,
                  keyboardType: TextInputType.text,
                  controller: searchController,
                  validate: (value) {
                    return null;
                  },
                  onChange: (value) {
                    searchController.text = value.toString();
                    volunteerCubit.getAllVolunteersForSearch(
                      key: value!.trim(),
                    );

                    return null;
                  },
                  labelTitle: AppLocalizations.of(context)!.search,
                  autoFocus: true,
                ),
              ),

              /// Space
              const SizedBox(
                height: 16,
              ),

              if (volunteerCubit.filterVolunteerListForSearch.isEmpty) ...[
                Center(
                  child: Text(AppLocalizations.of(context)!.noDataFound),
                ),
              ] else ...[
                Expanded(
                    child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: volunteerCubit.filterVolunteerListForSearch.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                  itemBuilder: (context, index) {
                    return CommonVolunteerItemWidget(
                      isCenter: true,
                      volunteerModel: VolunteerModel(
                        id: volunteerCubit
                            .filterVolunteerListForSearch[index].id,
                        city: volunteerCubit
                            .filterVolunteerListForSearch[index].city,
                        description: volunteerCubit
                            .filterVolunteerListForSearch[index].description,
                        eventEndDate: volunteerCubit
                            .filterVolunteerListForSearch[index].eventEndDate,
                        gender: volunteerCubit
                            .filterVolunteerListForSearch[index].gender,
                        hours: volunteerCubit
                            .filterVolunteerListForSearch[index].hours,
                        image: volunteerCubit
                            .filterVolunteerListForSearch[index].image,
                        numberOfVolunteer: volunteerCubit
                            .filterVolunteerListForSearch[index]
                            .numberOfVolunteer,
                        title: volunteerCubit
                            .filterVolunteerListForSearch[index].title,
                        userID: volunteerCubit
                            .filterVolunteerListForSearch[index].userID,
                        // status: volunteerCubit
                        //     .filterVolunteerListForSearch[index].status,
                        userAdded: volunteerCubit
                            .filterVolunteerListForSearch[index].userAdded,
                      ),
                    );
                  },
                ))
              ]
            ],
          );
        },
      ),
    );
  }
}
