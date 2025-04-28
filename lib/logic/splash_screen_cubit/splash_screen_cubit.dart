import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/config/local_storage/shared_preference.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/splash_screen_cubit/splash_screen_states.dart';
import 'package:refd_app/models/user_model.dart';

class SplashScreenCubit extends Cubit<SplashScreenStates> {
  SplashScreenCubit() : super(SplashScreenStatesInit());

  static SplashScreenCubit get(context) => BlocProvider.of(context);

  /// Go To Next Page After 5 Seconds
  goToNextPage() async {

    emit(SplashScreenLoadingState());
    await SharedPreference.getUserToken().then((token) async {
      Timer(
        const Duration(seconds: 5),
        () async {
          if (token != null && token.isNotEmpty) {
            SharedText.userToken = token;

            /// If User Found
            await SharedPreference.getUserMap().then((value) {
              SharedText.userModel = UserModel.fromJson(json.decode(value!));
              emit(UserFoundInLocalState());
            });
          } else {
            /// If User Not Found
            emit(UserNotFoundInLocalState());
          }
        },
      );
    });
  }
}
