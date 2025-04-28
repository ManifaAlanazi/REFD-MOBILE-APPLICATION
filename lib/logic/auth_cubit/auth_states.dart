abstract class AuthStates {}

/// Home Init
class AuthInitState extends AuthStates {}

/// Login
class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {
  final String error;

  LoginErrorState({
    required this.error,
  });
}

/// Register
class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {}

class RegisterErrorState extends AuthStates {
  final String error;

  RegisterErrorState({
    required this.error,
  });
}

/// Logout
class LogoutLoadingState extends AuthStates {}

class LogoutSuccessState extends AuthStates {}

class LogoutErrorState extends AuthStates {
  final String error;

  LogoutErrorState({
    required this.error,
  });
}

/// Send OTP
class SendOTPLoadingState extends AuthStates {}

class SendOTPSuccessState extends AuthStates {}

class SendOTPErrorState extends AuthStates {
  final String error;

  SendOTPErrorState({
    required this.error,
  });
}






/// Send OTP
class ConfirmOTPCodeLoadingState extends AuthStates {}

class ConfirmOTPCodeSuccessState extends AuthStates {}

class ConfirmOTPCodeErrorState extends AuthStates {
  final String error;

  ConfirmOTPCodeErrorState({
    required this.error,
  });
}




/// Change Password
class ChangePasswordLoadingState extends AuthStates {}

class ChangePasswordSuccessState extends AuthStates {}

class ChangePasswordErrorState extends AuthStates {
  final String error;

  ChangePasswordErrorState({
    required this.error,
  });
}





/// Update User Info
class UpdateInfoLoadingState extends AuthStates {}

class UpdateInfoSuccessState extends AuthStates {}

class UpdateInfoErrorState extends AuthStates {
  final String error;

  UpdateInfoErrorState({
    required this.error,
  });
}




/// Update User Password
class UpdatePasswordLoadingState extends AuthStates {}

class UpdatePasswordSuccessState extends AuthStates {}

class UpdatePasswordErrorState extends AuthStates {
  final String error;

  UpdatePasswordErrorState({
    required this.error,
  });
}
