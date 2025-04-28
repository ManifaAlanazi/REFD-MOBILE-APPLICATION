import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/helpers/helpers.dart';
import 'package:refd_app/helpers/validators.dart';
import 'package:refd_app/logic/auth_cubit/auth_cubit.dart';
import 'package:refd_app/logic/auth_cubit/auth_states.dart';
import 'package:refd_app/screens/auth/login_screen.dart';
import 'package:refd_app/widgets/common_asset_image_widget.dart';
import 'package:refd_app/widgets/common_button_widget.dart';
import 'package:refd_app/widgets/common_request_loading_widget.dart';
import 'package:refd_app/widgets/common_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AuthCubit authCubit;
  late TextEditingController universityIDController;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController dateOfBirthController;
  late TextEditingController collegeController;
  late TextEditingController majorController;
  late TextEditingController volunteeringLevelController;
  late TextEditingController skillsController;
  late TextEditingController interestsController;
  late TextEditingController bloodTypeController;
  late TextEditingController genderController;

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> checkBiometric() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    debugPrint('Biometrics supported: $canCheckBiometrics');
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await _localAuthentication.getAvailableBiometrics();
    debugPrint('Available biometrics: $availableBiometrics');
  }

  Future<void> authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
    }
    if (isAuthenticated) {
      authCubit.register(
        image: image,
        universityID: universityIDController.text,
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        gender: genderController.text,
        dateOfBirth: dateOfBirthController.text,
        college: collegeController.text,
        major: majorController.text,
        volunteeringLevel: volunteeringLevelController.text,
        skills: skillsController.text,
        interests: interestsController.text,
        bloodType: bloodTypeController.text,
      );

      // await SharedPreference.setEmail(emailController.text);
      // await SharedPreference.setPassword(passwordController.text);

      debugPrint('Biometric authentication successful');
    } else {
      debugPrint('Biometric authentication failed');
    }
  }

  @override
  void initState() {
    authCubit = BlocProvider.of(context);
    universityIDController = TextEditingController();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    dateOfBirthController = TextEditingController();
    collegeController = TextEditingController();
    majorController = TextEditingController();
    volunteeringLevelController = TextEditingController();
    skillsController = TextEditingController();
    interestsController = TextEditingController();
    bloodTypeController = TextEditingController();
    genderController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    universityIDController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    dateOfBirthController.dispose();
    collegeController.dispose();
    majorController.dispose();
    volunteeringLevelController.dispose();
    skillsController.dispose();
    interestsController.dispose();
    bloodTypeController.dispose();
    genderController.dispose();
    super.dispose();
  }

  /// Select Date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateOfBirthController.text = picked.toString();
      });
    }
  }

  File? image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          /// If Loading
          if (state is RegisterLoadingState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const RequestLoadingWidget(),
            );
          }

          /// If Success
          if (state is RegisterSuccessState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: AppLocalizations.of(context)!.registerSuccessfully,
              context: context,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
          }

          /// If Error
          if (state is RegisterErrorState) {
            Navigator.pop(context);
            Helpers.showRequestMessageResponse(
              message: state.error.toString(),
              context: context,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  AppColors.mainColor.withOpacity(0.9),
                  AppColors.mainColor.withOpacity(0.8),
                  AppColors.mainColor.withOpacity(0.4),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 80,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 30.0, right: 30.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.signUp.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60.0),
                        topRight: Radius.circular(60.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius:
                                    BorderRadiusDirectional.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  /// Image
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          pickImage();
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(1000.0),
                                          child: image != null
                                              ? Image.file(
                                                  image!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                )
                                              : const CommonAssetImage(
                                                  width: 100,
                                                  height: 100,
                                                  imageName:
                                                      "no_image_found.png",
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
                                          decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      1000.0)),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: AppColors.whiteColor,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  /// University ID
                                  CommonTextFormField(
                                    radius: 32,
                                    controller: universityIDController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle: AppLocalizations.of(context)!
                                        .universityID,
                                    keyboardType: TextInputType.number,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Full Name
                                  CommonTextFormField(
                                    radius: 32,
                                    controller: fullNameController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.fullName,
                                    keyboardType: TextInputType.text,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Email
                                  CommonTextFormField(
                                    radius: 32,
                                    controller: emailController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.email,
                                    keyboardType: TextInputType.emailAddress,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Phone
                                  CommonTextFormField(
                                    radius: 32,
                                    controller: phoneController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.phone,
                                    keyboardType: TextInputType.number,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Password
                                  CommonTextFormField(
                                    radius: 32,
                                    controller: passwordController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.password,
                                    keyboardType: TextInputType.text,
                                    isPassword: true,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Gender
                                  CommonTextFormField(
                                    radius: 32,
                                    readOnly: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              color: AppColors.whiteColor,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              // height: 200,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  ListTile(
                                                    title: const Text("Male"),
                                                    trailing:
                                                        genderController.text ==
                                                                "Male"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        genderController.text =
                                                            "Male";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("Female"),
                                                    trailing:
                                                        genderController.text ==
                                                                "Female"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        genderController.text =
                                                            "Female";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    controller: genderController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.gender,
                                    keyboardType: TextInputType.text,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Date Of Birth
                                  CommonTextFormField(
                                    radius: 32,
                                    readOnly: true,
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    controller: dateOfBirthController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle: AppLocalizations.of(context)!
                                        .dateOfBirth,
                                    keyboardType: TextInputType.text,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// College
                                  CommonTextFormField(
                                    radius: 32,
                                    readOnly: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              color: AppColors.whiteColor,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              // height: 200,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  ListTile(
                                                    title: const Text(
                                                        "College of Pharmacy"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "College of Pharmacy"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "College of Pharmacy";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "College of Applied Medical Sciences"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "College of Applied Medical Sciences"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "College of Applied Medical Sciences";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "College of Engineering"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "College of Engineering"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "College of Engineering";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "College of Computer Science and Engineering"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "College of Computer Science and Engineering"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "College of Computer Science and Engineering";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "College of Science"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "College of Science"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "College of Science";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "College of Literature"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "College of Literature"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "College of Literature";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "College of Business Administration"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "College of Business Administration"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "College of Business Administration";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "College of Applied"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "College of Applied"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "College of Applied";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Khafji University College"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "Khafji University College"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "Khafji University College";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "University College in Nairyah"),
                                                    trailing: collegeController
                                                                .text ==
                                                            "University College in Nairyah"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        collegeController.text =
                                                            "University College in Nairyah";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    controller: collegeController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.college,
                                    keyboardType: TextInputType.text,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Major
                                  CommonTextFormField(
                                    radius: 32,
                                    readOnly: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              color: AppColors.whiteColor,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              // height: 200,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  ListTile(
                                                    title: const Text(
                                                        "Technology"),
                                                    trailing:
                                                        majorController.text ==
                                                                "Technology"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Technology";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title:
                                                        const Text("Science"),
                                                    trailing:
                                                        majorController.text ==
                                                                "Science"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Science";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Environment"),
                                                    trailing:
                                                        majorController.text ==
                                                                "Environment"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Environment";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Health and Wellness"),
                                                    trailing: majorController
                                                                .text ==
                                                            "Health and Wellness"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Health and Wellness";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Business and Finance"),
                                                    trailing: majorController
                                                                .text ==
                                                            "Business and Finance"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Business and Finance";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Politics and Current Affairs"),
                                                    trailing: majorController
                                                                .text ==
                                                            "Politics and Current Affairs"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Politics and Current Affairs";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Arts and Culture"),
                                                    trailing: majorController
                                                                .text ==
                                                            "Arts and Culture"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Arts and Culture";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Travel and Exploration"),
                                                    trailing: majorController
                                                                .text ==
                                                            "Travel and Exploration"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Travel and Exploration";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Personal Development"),
                                                    trailing: majorController
                                                                .text ==
                                                            "Personal Development"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        majorController.text =
                                                            "Personal Development";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    controller: majorController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.major,
                                    keyboardType: TextInputType.text,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Volunteering Level
                                  CommonTextFormField(
                                    radius: 32,
                                    readOnly: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              color: AppColors.whiteColor,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              // height: 200,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  ListTile(
                                                    title: const Text(
                                                        "Entry-Level"),
                                                    trailing:
                                                        volunteeringLevelController
                                                                    .text ==
                                                                "Entry-Level"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        volunteeringLevelController
                                                                .text =
                                                            "Entry-Level";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title:
                                                        const Text("Regular"),
                                                    trailing:
                                                        volunteeringLevelController
                                                                    .text ==
                                                                "Regular"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        volunteeringLevelController
                                                            .text = "Regular";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Experienced"),
                                                    trailing:
                                                        volunteeringLevelController
                                                                    .text ==
                                                                "Experienced"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        volunteeringLevelController
                                                                .text =
                                                            "Experienced";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("Senior"),
                                                    trailing:
                                                        volunteeringLevelController
                                                                    .text ==
                                                                "Senior"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        volunteeringLevelController
                                                            .text = "Senior";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    controller: volunteeringLevelController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle: AppLocalizations.of(context)!
                                        .volunteeringLevel,
                                    keyboardType: TextInputType.text,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Skills
                                  CommonTextFormField(
                                    radius: 32,
                                    readOnly: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              color: AppColors.whiteColor,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              // height: 200,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  ListTile(
                                                    title: const Text(
                                                        "Communication"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Communication"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Communication";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Leadership"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Leadership"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Leadership";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title:
                                                        const Text("Teamwork"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Teamwork"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Teamwork";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Time Management"),
                                                    trailing: skillsController
                                                                .text ==
                                                            "Time Management"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Time Management";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Organization"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Organization"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Organization";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Problem-Solving"),
                                                    trailing: skillsController
                                                                .text ==
                                                            "Problem-Solving"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Problem-Solving";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Adaptability"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Adaptability"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Adaptability";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Interpersonal Skills"),
                                                    trailing: skillsController
                                                                .text ==
                                                            "Interpersonal Skills"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Interpersonal Skills";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title:
                                                        const Text("Empathy"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Empathy"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Empathy";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Creativity"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Creativity"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Creativity";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Project Management"),
                                                    trailing: skillsController
                                                                .text ==
                                                            "Project Management"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Project Management";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Public Speaking"),
                                                    trailing: skillsController
                                                                .text ==
                                                            "Public Speaking"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Public Speaking";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Conflict Resolution"),
                                                    trailing: skillsController
                                                                .text ==
                                                            "Conflict Resolution"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Conflict Resolution";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Flexibility"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Flexibility"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Flexibility";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Collaboration"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Collaboration"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Collaboration";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title:
                                                        const Text("Research"),
                                                    trailing:
                                                        skillsController.text ==
                                                                "Research"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Research";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Decision Making"),
                                                    trailing: skillsController
                                                                .text ==
                                                            "Decision Making"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        skillsController.text =
                                                            "Decision Making";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    controller: skillsController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.skills,
                                    keyboardType: TextInputType.text,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Interests
                                  CommonTextFormField(
                                    radius: 32,
                                    readOnly: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              color: AppColors.whiteColor,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              // height: 200,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  ListTile(
                                                    title: const Text(
                                                        "Animal Welfare"),
                                                    trailing:
                                                        interestsController
                                                                    .text ==
                                                                "Animal Welfare"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Animal Welfare";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Environmental Conservation"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Environmental Conservation"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Environmental Conservation";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Homeless Shelter Assistance"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Homeless Shelter Assistance"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Homeless Shelter Assistance";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Elderly Care"),
                                                    trailing:
                                                        interestsController
                                                                    .text ==
                                                                "Elderly Care"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Elderly Care";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Childcare and Education"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Childcare and Education"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Childcare and Education";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Disaster Relief"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Disaster Relief"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Disaster Relief";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Health and Wellness"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Health and Wellness"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Health and Wellness";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Refugee Support"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Refugee Support"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Refugee Support";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Food Bank and Hunger Relief"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Food Bank and Hunger Relief"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Food Bank and Hunger Relief";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Women's Empowerment"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Women's Empowerment"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Women's Empowerment";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Mental Health Support"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Mental Health Support"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Mental Health Support";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text(
                                                        "Literacy Programs"),
                                                    trailing: interestsController
                                                                .text ==
                                                            "Literacy Programs"
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 20,
                                                            color: AppColors
                                                                .successColor,
                                                          )
                                                        : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        interestsController
                                                                .text =
                                                            "Literacy Programs";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    controller: interestsController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.interests,
                                    keyboardType: TextInputType.text,
                                  ),

                                  /// Space
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  /// Blood Types
                                  CommonTextFormField(
                                    radius: 32,
                                    readOnly: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              color: AppColors.whiteColor,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              // height: 200,
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  ListTile(
                                                    title: const Text("A"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "A"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "A";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("B"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "B"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "B";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("AB"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "AB"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "AB";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("O"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "O"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "O";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("A+"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "A+"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "A+";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("A-"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "A-"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "A-";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("B+"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "B+"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "B+";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("B-"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "B-"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "B-";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("AB+"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "AB+"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "AB+";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("AB-"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "AB-"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "AB-";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("O+"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "O+"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "O+";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: const Text("O-"),
                                                    trailing:
                                                        bloodTypeController
                                                                    .text ==
                                                                "O-"
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                size: 20,
                                                                color: AppColors
                                                                    .successColor,
                                                              )
                                                            : const SizedBox(),
                                                    onTap: () {
                                                      setState(() {
                                                        bloodTypeController
                                                            .text = "O-";
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    controller: bloodTypeController,
                                    validate: (value) {
                                      return null;
                                    },
                                    labelTitle:
                                        AppLocalizations.of(context)!.bloodType,
                                    keyboardType: TextInputType.text,
                                  ),
                                ],
                              ),
                            ),

                            /// Space
                            const SizedBox(
                              height: 32,
                            ),

                            /// Make Sign Up
                            CommonButtonWidget(
                              textColor: Colors.white,
                              borderColor: AppColors.mainColor,
                              buttonText: AppLocalizations.of(context)!
                                  .signUp
                                  .toUpperCase(),
                              onTap: () {
                                // if (image == null) {
                                //   Helpers.showRequestMessageResponse(
                                //     message: "upload you photo",
                                //     context: context,
                                //     isError: true,
                                //   );
                                // } else
                                  if (universityIDController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Enter university id",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (fullNameController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Enter full name",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (emailController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Enter email",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (!Validators()
                                    .emailRegExp
                                    .hasMatch(emailController.text.trim())) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Enter valid email",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (phoneController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Enter phone number",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (passwordController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Enter password",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (genderController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Select gender",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (dateOfBirthController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Select date of birth",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (collegeController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Select college",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (majorController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Select major",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (volunteeringLevelController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Select volunteering level",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (skillsController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Select skills",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (interestsController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Select interests",
                                    context: context,
                                    isError: true,
                                  );
                                } else if (bloodTypeController.text
                                    .trim()
                                    .isEmpty) {
                                  Helpers.showRequestMessageResponse(
                                    message: "Select blood type",
                                    context: context,
                                    isError: true,
                                  );
                                } else {
                                  checkBiometric();
                                  getAvailableBiometrics();
                                  authenticate();
                                }
                              },
                              buttonBackgroundColor: AppColors.mainColor,
                            ),

                            /// Space
                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.youHaveAccount,
                                  style: const TextStyle(
                                    color: AppColors.darkColor,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: const TextStyle(
                                      color: AppColors.secondColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
