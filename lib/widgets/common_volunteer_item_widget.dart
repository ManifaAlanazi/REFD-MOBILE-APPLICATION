import 'package:flutter/material.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/models/volunteer_model.dart';
import 'package:refd_app/screens/volunteers/register_volunteer_screen.dart';
import 'package:refd_app/widgets/common_cached_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonVolunteerItemWidget extends StatelessWidget {
  final bool isCenter;
  final VolunteerModel volunteerModel;

  const CommonVolunteerItemWidget({
    super.key,
    this.isCenter = false,
    required this.volunteerModel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: RegisterVolunteerScreen(
                      volunteerModel: volunteerModel,
                    ));
              },
            );
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                alignment: isCenter ? Alignment.center : Alignment.topLeft,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.greyColor.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image
                    CommonCachedImageWidget(
                      imagePath: volunteerModel.image,
                      width: isCenter ? double.infinity : 200,
                      height: 120,
                      loaderSize: 25,
                    ),

                    /// Space
                    const SizedBox(
                      height: 4,
                    ),

                    /// Title
                    SizedBox(
                      width: 200,
                      child: Text(
                        volunteerModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    /// Space
                    const SizedBox(
                      height: 2,
                    ),

                    /// Expire Date
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        volunteerModel.eventEndDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),

                    /// Space
                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      volunteerModel.gender,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),

                    /// Space
                    const SizedBox(
                      height: 4,
                    ),

                    /// Location
                    Text(
                      volunteerModel.city,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),

                    /// Space
                    const SizedBox(
                      height: 4,
                    ),

                    /// Added By
                    Text(
                      "Added by : ${volunteerModel.userAdded}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  VolunteerCubit.get(context).deleteVolunteer(
                    volunteerID: volunteerModel.id,
                  );
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: AppColors.errorColor,
                ),
              )
            ],
          ),
        ),
        if (volunteerModel.userID == SharedText.userToken) ...[
          Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.areYouSureToDelete,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          /// Space
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  VolunteerCubit.get(context).deleteVolunteer(
                                      volunteerID: volunteerModel.id);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.yes,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.successColor,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.no,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.errorColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ]
      ],
    );
  }
}
