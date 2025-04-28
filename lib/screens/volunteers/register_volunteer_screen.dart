import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/models/volunteer_model.dart';
import 'package:refd_app/screens/volunteers/show_volunteer_requests_screen.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_cached_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';

class RegisterVolunteerScreen extends StatefulWidget {
  final VolunteerModel volunteerModel;

  const RegisterVolunteerScreen({
    super.key,
    required this.volunteerModel,
  });

  @override
  State<RegisterVolunteerScreen> createState() =>
      _RegisterVolunteerScreenState();
}

class _RegisterVolunteerScreenState extends State<RegisterVolunteerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VolunteerCubit, VolunteerStates>(
      listener: (context, state) {
        /// If Loading
        if (state is RegisterOnVolunteerLoadingState) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const RequestLoadingWidget(),
          );
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.volunteerModel.title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              Divider(
                thickness: 0.5,
                color: AppColors.greyColor.withOpacity(0.4),
              ),

              /// Space
              const SizedBox(
                height: 4,
              ),

              /// Image
              CommonCachedImageWidget(
                imagePath: widget.volunteerModel.image,
                width: double.infinity,
                height: 120,
                loaderSize: 25,
              ),

              /// Space
              const SizedBox(
                height: 8,
              ),

              /// Description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.volunteerModel.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              /// Space
              const SizedBox(
                height: 2,
              ),

              /// Expire Date
              Row(
                children: [
                  const Text(
                    "Event End Date: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.volunteerModel.eventEndDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              /// Space
              const SizedBox(
                height: 2,
              ),

              /// Gender
              Row(
                children: [
                  const Text(
                    "Gender: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.volunteerModel.gender,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              /// Space
              const SizedBox(
                height: 2,
              ),

              /// Location
              Row(
                children: [
                  const Text(
                    "City: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.volunteerModel.city,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              /// Space
              const SizedBox(
                height: 2,
              ),

              /// Number Of Volunteers
              Row(
                children: [
                  const Text(
                    "Number Of Volunteers: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.volunteerModel.numberOfVolunteer,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              /// Space
              const SizedBox(
                height: 2,
              ),

              /// Hours
              Row(
                children: [
                  const Text(
                    "Hours: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.volunteerModel.hours,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              /// Space
              const SizedBox(
                height: 2,
              ),

              /// Added By
              Row(
                children: [
                  const Text(
                    "Added By: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.volunteerModel.userAdded,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              /// Space
              const SizedBox(
                height: 8,
              ),

              /// Show All Requests
              if (SharedText.userModel != null &&
                  SharedText.userToken == widget.volunteerModel.userID) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowVolunteerRequestsScreen(
                              volunteerID: widget.volunteerModel.id,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Show All Requests",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ),
                  ],
                ),

                /// Space
                const SizedBox(
                  height: 8,
                ),
              ],

              if (SharedText.userModel != null &&
                  SharedText.userModel!.roleID != 1) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: CommonButtonWidget(
                        padding: 2,
                        textColor: Colors.white,
                        borderColor: AppColors.errorColor,
                        buttonText:
                            AppLocalizations.of(context)!.close.toUpperCase(),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        buttonBackgroundColor: AppColors.errorColor,
                      ),
                    ),
                    if (widget.volunteerModel.userID != SharedText.userToken &&
                        SharedText.userModel != null) ...[
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: CommonButtonWidget(
                          padding: 2,
                          textColor: Colors.white,
                          borderColor: AppColors.mainColor,
                          buttonText: AppLocalizations.of(context)!
                              .register
                              .toUpperCase(),
                          onTap: () {
                            VolunteerCubit.get(context).registerOnVolunteer(
                              registeredEmail: SharedText.userModel!.email,
                              registeredPhone: SharedText.userModel!.phone,
                              registeredUserID: SharedText.userToken!,
                              registeredUserName:
                                  SharedText.userModel!.fullName,
                              volunteerID: widget.volunteerModel.id,
                              volunteerCount:
                                  widget.volunteerModel.numberOfVolunteer,
                              volunteerTitle: widget.volunteerModel.title,
                            );
                            Navigator.pop(context);
                          },
                          buttonBackgroundColor: AppColors.mainColor,
                        ),
                      ),
                    ],
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
