import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/widgets/common_asset_image_widget.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/common_text_form_field.dart';

class AddNewVolunteerScreen extends StatefulWidget {
  const AddNewVolunteerScreen({super.key});

  @override
  State<AddNewVolunteerScreen> createState() => _AddNewVolunteerScreenState();
}

class _AddNewVolunteerScreenState extends State<AddNewVolunteerScreen> {
  final _formKey = GlobalKey<FormState>();
  late VolunteerCubit volunteerCubit;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController eventEndDateController;
  late TextEditingController genderController;
  late TextEditingController cityController;
  late TextEditingController numberOfVolunteersController;
  late TextEditingController hoursController;

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String dateString = DateFormat("yyyy-MM-dd").format(selectedDate);
        eventEndDateController.text = dateString;
      });
    }
  }

  @override
  void initState() {
    volunteerCubit = BlocProvider.of(context);
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    eventEndDateController = TextEditingController();
    genderController = TextEditingController();
    cityController = TextEditingController();
    numberOfVolunteersController = TextEditingController();
    hoursController = TextEditingController();
    super.initState();
  }

  File? image;

  /// Pick Volunteer Image
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    eventEndDateController.dispose();
    genderController.dispose();
    cityController.dispose();
    numberOfVolunteersController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.addNewVolunteer,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: BlocConsumer<VolunteerCubit, VolunteerStates>(
        listener: (context, state) {
          /// If Loading
          if (state is AddVolunteerLoadingState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const RequestLoadingWidget(),
            );
          }

          /// If Success
          if (state is AddVolunteerSuccessState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message:
                  AppLocalizations.of(context)!.volunteerCreatedSuccessfully,
              context: context,
            );
            Navigator.pop(context);
          }

          /// If Error
          if (state is AddVolunteerErrorState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: state.error.toString(),
              context: context,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: [
                /// Image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          child: image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: Image.file(
                                    File(image!.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: const CommonAssetImage(
                                    width: 100.0,
                                    height: 100.0,
                                    imageName: "no_image_found.png",
                                    boxFit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        IconButton(
                          onPressed: () {
                            pickImage();
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.mainColor,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// Space
                const SizedBox(
                  height: 16.0,
                ),

                /// Title
                CommonTextFormField(
                  radius: 32.0,
                  controller: titleController,
                  validate: (value) {
                    return null;
                  },
                  labelTitle: AppLocalizations.of(context)!.title,
                  keyboardType: TextInputType.text,
                ),

                /// Space
                const SizedBox(
                  height: 16.0,
                ),

                /// Description
                CommonTextFormField(
                  radius: 32.0,
                  maxLines: 4,
                  minLines: 4,
                  controller: descriptionController,
                  validate: (value) {
                    return null;
                  },
                  labelTitle: AppLocalizations.of(context)!.description,
                  keyboardType: TextInputType.text,
                ),

                /// Space
                const SizedBox(
                  height: 16.0,
                ),

                /// Event End Date
                CommonTextFormField(
                  radius: 32.0,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  controller: eventEndDateController,
                  validate: (value) {
                    return null;
                  },
                  labelTitle: AppLocalizations.of(context)!.eventEndTime,
                  keyboardType: TextInputType.text,
                ),

                /// Space
                const SizedBox(
                  height: 16.0,
                ),

                /// Gender
                CommonTextFormField(
                  radius: 32.0,
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          color: AppColors.whiteColor,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .male)),
                                    genderController.text ==
                                            AppLocalizations.of(context)!.male
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: AppColors.successColor,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                onTap: () {
                                  genderController.text =
                                      AppLocalizations.of(context)!.male;
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!.female,
                                      ),
                                    ),
                                    genderController.text ==
                                            AppLocalizations.of(context)!.female
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: AppColors.successColor,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                onTap: () {
                                  genderController.text =
                                      AppLocalizations.of(context)!.female;
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  controller: genderController,
                  validate: (value) {
                    return null;
                  },
                  labelTitle: AppLocalizations.of(context)!.gender,
                  keyboardType: TextInputType.text,
                ),

                /// Space
                const SizedBox(
                  height: 16.0,
                ),

                /// City
                CommonTextFormField(
                  radius: 32.0,
                  controller: cityController,
                  validate: (value) {
                    return null;
                  },
                  labelTitle: AppLocalizations.of(context)!.city,
                  keyboardType: TextInputType.text,
                ),

                /// Space
                const SizedBox(
                  height: 16.0,
                ),

                /// Number Of Volunteers
                CommonTextFormField(
                  radius: 32.0,
                  controller: numberOfVolunteersController,
                  validate: (value) {
                    return null;
                  },
                  labelTitle: AppLocalizations.of(context)!.numberOfVolunteers,
                  keyboardType: TextInputType.number,
                ),

                /// Space
                const SizedBox(
                  height: 16.0,
                ),

                /// Hours
                CommonTextFormField(
                  radius: 32.0,
                  controller: hoursController,
                  validate: (value) {
                    return null;
                  },
                  labelTitle: AppLocalizations.of(context)!.hours,
                  keyboardType: TextInputType.number,
                ),

                /// Space
                const SizedBox(
                  height: 32.0,
                ),

                /// Save
                CommonButtonWidget(
                  textColor: Colors.white,
                  borderColor: AppColors.mainColor,
                  buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
                  onTap: () {
                    if (titleController.text.trim().isEmpty) {
                      Helpers.showRequestMessageResponse(
                        message: "Enter title",
                        context: context,
                        isError: true,
                      );
                    } else if (descriptionController.text.trim().isEmpty) {
                      Helpers.showRequestMessageResponse(
                        message: "Enter description",
                        context: context,
                        isError: true,
                      );
                    } else if (eventEndDateController.text.trim().isEmpty) {
                      Helpers.showRequestMessageResponse(
                        message: "Enter event end date",
                        context: context,
                        isError: true,
                      );
                    } else if (genderController.text.trim().isEmpty) {
                      Helpers.showRequestMessageResponse(
                        message: "Select gender",
                        context: context,
                        isError: true,
                      );
                    } else if (cityController.text.trim().isEmpty) {
                      Helpers.showRequestMessageResponse(
                        message: "Enter city",
                        context: context,
                        isError: true,
                      );
                    } else if (numberOfVolunteersController.text
                        .trim()
                        .isEmpty) {
                      Helpers.showRequestMessageResponse(
                        message: "Enter number of volunteers",
                        context: context,
                        isError: true,
                      );
                    } else if (hoursController.text.trim().isEmpty) {
                      Helpers.showRequestMessageResponse(
                        message: "Enter hours",
                        context: context,
                        isError: true,
                      );
                    } else {
                      volunteerCubit.addNewVolunteer(
                        image: image,
                        title: titleController.text,
                        description: descriptionController.text,
                        eventEndTime: eventEndDateController.text,
                        gender: genderController.text,
                        city: cityController.text,
                        numberOfVolunteers: numberOfVolunteersController.text,
                        hours: hoursController.text,
                      );
                    }
                  },
                  buttonBackgroundColor: AppColors.mainColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
