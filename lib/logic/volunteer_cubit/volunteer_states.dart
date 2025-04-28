abstract class VolunteerStates {}

/// Home Init
class AddVolunteerInitState extends VolunteerStates {}

/// Add Volunteer
class AddVolunteerLoadingState extends VolunteerStates {}

class AddVolunteerSuccessState extends VolunteerStates {}

class AddVolunteerErrorState extends VolunteerStates {
  final String error;

  AddVolunteerErrorState({
    required this.error,
  });
}






/// Get All Volunteers
class GetAllVolunteerLoadingState extends VolunteerStates {}

class GetAllVolunteerSuccessState extends VolunteerStates {}

class GetAllVolunteerErrorState extends VolunteerStates {
  final String error;

  GetAllVolunteerErrorState({
    required this.error,
  });
}





/// Register On Volunteer
class RegisterOnVolunteerLoadingState extends VolunteerStates {}

class RegisterOnVolunteerSuccessState extends VolunteerStates {}

class RegisterOnVolunteerErrorState extends VolunteerStates {
  final String error;

  RegisterOnVolunteerErrorState({
    required this.error,
  });
}




/// Register On Volunteer
class GetRegisterOnVolunteerLoadingState extends VolunteerStates {}

class GetRegisterOnVolunteerSuccessState extends VolunteerStates {}

class GetRegisterOnVolunteerErrorState extends VolunteerStates {
  final String error;

  GetRegisterOnVolunteerErrorState({
    required this.error,
  });
}






/// Change Status Of Volunteer Request
class ChangeStatusVolunteerRequestLoadingState extends VolunteerStates {}

class ChangeStatusVolunteerRequestSuccessState extends VolunteerStates {}

class ChangeStatusVolunteerRequestErrorState extends VolunteerStates {
  final String error;

  ChangeStatusVolunteerRequestErrorState({
    required this.error,
  });
}








/// Get All Volunteers For Search
class GetAllVolunteersForSearchLoadingState extends VolunteerStates {}

class GetAllVolunteersForSearchSuccessState extends VolunteerStates {}

class GetAllVolunteersForSearchErrorState extends VolunteerStates {
  final String error;

  GetAllVolunteersForSearchErrorState({
    required this.error,
  });
}








/// Get My Volunteers
class GetMyVolunteersLoadingState extends VolunteerStates {}

class GetMyVolunteersSuccessState extends VolunteerStates {}

class GetMyVolunteersErrorState extends VolunteerStates {
  final String error;

  GetMyVolunteersErrorState({
    required this.error,
  });
}




/// Get My Contributions
class GetMyContributionsLoadingState extends VolunteerStates {}

class GetMyContributionsSuccessState extends VolunteerStates {}

class GetMyContributionsErrorState extends VolunteerStates {
  final String error;

  GetMyContributionsErrorState({
    required this.error,
  });
}






/// Get All Users For Admin
class GetAllUsersForAdminLoadingState extends VolunteerStates {}

class GetAllUsersForAdminSuccessState extends VolunteerStates {}

class GetAllUsersForAdminErrorState extends VolunteerStates {
  final String error;

  GetAllUsersForAdminErrorState({
    required this.error,
  });
}







/// Delete Volunteer
class DeleteVolunteerLoadingState extends VolunteerStates {}

class DeleteVolunteerSuccessState extends VolunteerStates {}

class DeleteVolunteerErrorState extends VolunteerStates {
  final String error;

  DeleteVolunteerErrorState({
    required this.error,
  });
}











/// Get Volunteer Requests
class GetVolunteerRequestsLoadingState extends VolunteerStates {}

class GetVolunteerRequestsSuccessState extends VolunteerStates {}

class GetVolunteerRequestsErrorState extends VolunteerStates {
  final String error;

  GetVolunteerRequestsErrorState({
    required this.error,
  });
}