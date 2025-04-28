import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/config/local_storage/shared_preference.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/auth_cubit/auth_states.dart';
import 'package:refd_app/models/user_model.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());

  static AuthCubit get(context) => BlocProvider.of(context);

  EmailOTP myAuth = EmailOTP();

  ////////////////////////////////////////////////////////////////////////////////////

  /// Register
  Future<dynamic> register({
    File? image,
    required String universityID,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String gender,
    required String dateOfBirth,
    required String college,
    required String major,
    required String volunteeringLevel,
    required String skills,
    required String interests,
    required String bloodType,
  }) async {
    emit(RegisterLoadingState());

    if(image == null) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.user!.uid)
            .set(
          {
            "user_image": "",
            "university_id": universityID,
            "full_name": fullName,
            "email": email,
            "phone": phone,
            "password": password,
            "gender": gender,
            "date_of_birth": dateOfBirth,
            "college": college,
            "major": major,
            "volunteering_level": volunteeringLevel,
            "skills": skills,
            "interests": interests,
            "blood_type": bloodType,
            "role_id": 2,
          },
        );

        emit(RegisterSuccessState());
      }).catchError((err) {
        log(err.toString(), name: "error when make register");
        RegisterErrorState(error: err.toString());
      });
    }else {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child("images/${Uri.file(image.path)}")
          .putFile(image)
          .then((snapShot) {
        snapShot.ref.getDownloadURL().then((imageUrl) async {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password)
              .then((user) async {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.user!.uid)
                .set(
              {
                "user_image": imageUrl,
                "university_id": universityID,
                "full_name": fullName,
                "email": email,
                "phone": phone,
                "password": password,
                "gender": gender,
                "date_of_birth": dateOfBirth,
                "college": college,
                "major": major,
                "volunteering_level": volunteeringLevel,
                "skills": skills,
                "interests": interests,
                "blood_type": bloodType,
                "role_id": 2,
              },
            );

            emit(RegisterSuccessState());
          }).catchError((err) {
            log(err.toString(), name: "error when make register");
            RegisterErrorState(error: err.toString());
          });
        });
      });
    }
  }

////////////////////////////////////////////////////////////////////////////////////

  /// Login
  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      log(user.user.toString(), name: "user data after login");
      final userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.user!.uid)
          .get();
      print("dmskdmskm ${user.user!.uid}");

      UserModel userModel = UserModel.fromJson(userData.data()!);
      String jEncode = json.encode(userModel.toJson());

      await SharedPreference.setUserMap(jEncode);
      await SharedPreference.setUserToken(user.user!.uid);
      SharedText.userToken = user.user!.uid;
      SharedText.userModel = userModel;

      emit(LoginSuccessState());
    }).catchError((error) {
      print("dmskdmskm ${error.toString()}");
      emit(LoginErrorState(error: error));
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  /// Logout
  Future<dynamic> logout() async {
    emit(LogoutLoadingState());
    await FirebaseAuth.instance.signOut().then((value) {
      emit(LogoutSuccessState());
    }).catchError((err) {
      emit(LogoutErrorState(error: err.toString()));
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  /// Send OTP
  Future<dynamic> sendOTP({required String email}) async {
    emit(SendOTPLoadingState());
    myAuth.setConfig(
      appEmail: "refd@gmail.com",
      appName: "Refd",
      userEmail: email,
      otpLength: 4,
      otpType: OTPType.digitsOnly,
    );

    if (await myAuth.sendOTP() == true) {
      emit(SendOTPSuccessState());
    } else {
      emit(SendOTPErrorState(error: "otp not send"));
    }
  }

////////////////////////////////////////////////////////////////////////////////////

  /// Send OTP
  Future<dynamic> confirmOTPCode({required String otp}) async {
    emit(ConfirmOTPCodeLoadingState());
    if (await myAuth.verifyOTP(otp: otp) == true) {
      emit(ConfirmOTPCodeSuccessState());
    } else {
      emit(ConfirmOTPCodeErrorState(error: "error"));
    }
  }

////////////////////////////////////////////////////////////////////////////////////

  void changePassword(
      {required String email, required String newPassword}) async {
    emit(ChangePasswordLoadingState());
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      UserModel userData = UserModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: userData.password,
      );
      await userCredential.user!.updatePassword(newPassword).then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .update({
          "password": newPassword,
        }).then((_) {
          emit(ChangePasswordSuccessState());
        });
      }).catchError((error) {
        emit(ChangePasswordErrorState(error: error.toString()));
      });
    }
  }

////////////////////////////////////////////////////////////////////////////////////

  void updateData({required String email, required String fullName}) async {
    emit(UpdateInfoLoadingState());

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: SharedText.userModel!.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      UserModel userData = UserModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: SharedText.userModel!.email,
        password: userData.password,
      );

      await userCredential.user!.updateEmail(email).then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .update({
          "email": email,
          "full_name": fullName,
        }).then((_) async {
          UserModel? user = UserModel(
            id: SharedText.userToken.toString(),
            interests: SharedText.userModel!.interests,
            skills: SharedText.userModel!.skills,
            volunteeringLevel: SharedText.userModel!.volunteeringLevel,
            major: SharedText.userModel!.major,
            college: SharedText.userModel!.college,
            dateOfBirth: SharedText.userModel!.dateOfBirth,
            gender: SharedText.userModel!.gender,
            password: SharedText.userModel!.password,
            email: email,
            fullName: fullName,
            universityID: SharedText.userModel!.universityID,
            bloodType: SharedText.userModel!.bloodType,
            roleID: SharedText.userModel!.roleID,
            userImage: SharedText.userModel!.userImage,
            phone: SharedText.userModel!.phone,
          );
          String jEncode = json.encode(user.toJson());

          await SharedPreference.setUserMap(jEncode);
          await SharedPreference.setUserToken(user.id.toString());
          SharedText.userToken = user.id.toString();
          SharedText.userModel = user;

          emit(UpdateInfoSuccessState());
        });
      }).catchError((error) {
        emit(UpdateInfoErrorState(error: error.toString()));
      });
    }
  }

////////////////////////////////////////////////////////////////////////////////////

  void updatePassword({required String newPassword}) async {
    emit(UpdatePasswordLoadingState());

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: SharedText.userModel!.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      UserModel userData = UserModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: SharedText.userModel!.email,
        password: userData.password,
      );

      await userCredential.user!.updatePassword(newPassword).then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .update({
          "password": newPassword,
        }).then((_) async {
          emit(UpdatePasswordSuccessState());
        });
      }).catchError((error) {
        emit(UpdatePasswordErrorState(error: error.toString()));
      });
    }
  }
}
