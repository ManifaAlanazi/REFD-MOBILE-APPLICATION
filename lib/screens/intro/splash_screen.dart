import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/logic/splash_screen_cubit/splash_screen_cubit.dart';
import 'package:refd_app/logic/splash_screen_cubit/splash_screen_states.dart';
import 'package:refd_app/screens/intro/choose_action_screen.dart';
import 'package:refd_app/screens/intro/index_screen.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';
import 'package:refd_app/widgets/common_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SplashScreenCubit, SplashScreenStates>(
        listener: (splashContext, splashState) {
          /// If User Found
          if (splashState is UserFoundInLocalState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const IndexScreen(),
              ),
              (route) => false,
            );
          }

          /// If User Not Found
          if (splashState is UserNotFoundInLocalState) {
            /// Navigate To Login
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ChooseActionScreen(),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Logo
              CommonLogoWidget(),

              /// Space
              SizedBox(
                height: 32,
              ),

              /// Loader
              CommonLoaderWidget(),
            ],
          );
        },
      ),
    );
  }
}
