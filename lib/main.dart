import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/config/local_storage/shared_preference.dart';
import 'package:refd_app/config/observer/bloc_observer.dart';
import 'package:refd_app/logic/language_cubit/language_cubit.dart';
import 'package:refd_app/logic/language_cubit/language_states.dart';
import 'package:refd_app/multi_bloc_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:refd_app/screens/intro/splash_screen.dart';

void main() async {
  /// Initialize Widgets
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          appId: '1:16097364905:android:af466fe819bc09cca092b8',
          apiKey: 'AIzaSyDq0iN5_--4Gff_ZOTokVJX5CyQ0q4-nBI',
          projectId: 'refd-a4050',
          messagingSenderId: '16097364905',
          storageBucket: "gs://refd-a4050.appspot.com"),
    );
  }

  /// Initialize Local Storage
  await SharedPreference.getInstance();

  /// Bloc Observer
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvidersPage(
      body: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (languageContext, languageState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Refd App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: "Avenir",
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: LanguageCubit.get(languageContext).appLocal,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
