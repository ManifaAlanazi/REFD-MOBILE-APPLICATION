List<VolunteerRequestsModel> volunteerRequestsListFromJson(List str) =>
    List<VolunteerRequestsModel>.from(
      str.map(
        (x) => VolunteerRequestsModel.fromJson(x),
      ),
    );

class VolunteerRequestsModel {
  late final String requestID;
  late final String userID;
  late final String userName;
  late final String userEmail;
  late final String userPhone;
  late final String requestStatus;
  late final String volunteerTitle;

  VolunteerRequestsModel({
    required this.userID,
    required this.requestID,
    required this.userEmail,
    required this.userName,
    required this.userPhone,
    required this.requestStatus,
    required this.volunteerTitle,
  });

  VolunteerRequestsModel.fromJson(Map<String, dynamic> json) {
    requestID = json['request_id'];
    userID = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    requestStatus = json['request_status'];
    volunteerTitle = json['volunteer_title'];
  }
}
