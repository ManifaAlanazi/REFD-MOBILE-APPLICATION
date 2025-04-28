abstract class SplashScreenStates {}

/// Splash Screen Init
class SplashScreenStatesInit extends SplashScreenStates {}

/// Splash Screen Loading State
class SplashScreenLoadingState extends SplashScreenStates {}

/// User Found In Local State
class UserFoundInLocalState extends SplashScreenStates {}

/// User Not Found In Local State
class UserNotFoundInLocalState extends SplashScreenStates {}



/// Get Onboarding Data
class GetOnboardingDataLoadingState extends SplashScreenStates {}
class GetOnboardingDataSuccessState extends SplashScreenStates {}
class GetOnboardingDataErrorState extends SplashScreenStates {
  final String error;

  GetOnboardingDataErrorState({
    required this.error,
  });
}
