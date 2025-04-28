import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/config/local_storage/shared_preference.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'language_states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitialLangState());
  Locale? appLocal;

  static LanguageCubit get(context) => BlocProvider.of(context);
  String currentLang = "en";

  /// CHANGE LANGUAGE
  Future<void> changeLang(newLang, context) async {
    currentLang = newLang;
    SharedText.currentLocale = currentLang;
    SharedPreference.setLanguage(newLang);
    appLocal = Locale(newLang);
    await AppLocalizations.delegate.load(appLocal!);
    emit(UpdateNewLangState(appLocal!));
  }

  /// GET LANGUAGE
  getLang() async {
    emit(GetLangLangState());
    await SharedPreference.getLanguage().then((lang) {
      if (lang == null) {
        SharedPreference.setLanguage(currentLang);
      } else {
        currentLang = lang;
      }
    });
    appLocal = Locale(currentLang);
    SharedText.currentLocale = currentLang;
    AppLocalizations.delegate.load(appLocal!);
    currentLang = appLocal.toString();
    emit(UpdateLangState(appLocal!));
  }
}
