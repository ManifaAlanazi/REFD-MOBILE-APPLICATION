import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/logic/auth_cubit/auth_cubit.dart';
import 'package:refd_app/logic/bottom_navigation_cubit/bottom_navigation_cubit.dart';
import 'package:refd_app/logic/language_cubit/language_cubit.dart';
import 'package:refd_app/logic/splash_screen_cubit/splash_screen_cubit.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_cubit.dart';

class MultiBlocProvidersPage extends StatefulWidget {
  final Widget body;

  const MultiBlocProvidersPage({Key? key, required this.body})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiBlocProvidersPageState();
}

class _MultiBlocProvidersPageState extends State<MultiBlocProvidersPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Splash Screen Cubit
        BlocProvider<SplashScreenCubit>(
          create: (_) => SplashScreenCubit()..goToNextPage(),
        ),

        /// Language Cubit
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit()..getLang(),
        ),

        /// Auth Cubit
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),

        /// Bottom Navigation Cubit
        BlocProvider<BottomNavigationCubit>(
          create: (_) => BottomNavigationCubit(),
        ),

        /// Volunteers Cubit
        BlocProvider<VolunteerCubit>(
          create: (_) => VolunteerCubit(),
        ),
      ],
      child: widget.body,
    );
  }
}
