import 'package:flutter/material.dart';

abstract class LanguageState {}

class LanguageInitialLangState extends LanguageState {}

class GetLangLangState extends LanguageState {}

class UpdateLangState extends LanguageState {
  Locale locale;
  UpdateLangState(this.locale);
}

class UpdateNewLangState extends LanguageState {
  Locale locale;
  UpdateNewLangState(this.locale);
}

class ErrorLangState extends LanguageState {
  final String error;
  ErrorLangState(this.error);
}
