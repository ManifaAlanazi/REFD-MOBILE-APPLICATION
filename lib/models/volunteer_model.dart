List<VolunteerModel> volunteerListFromJson(List str) =>
    List<VolunteerModel>.from(
      str.map(
        (x) => VolunteerModel.fromJson(x),
      ),
    );

class VolunteerModel {
  late final String id;
  late final String image;
  late final String userID;
  late final String userAdded;
  late final String title;
  late final String description;
  late final String eventEndDate;
  late final String gender;
  late final String city;
  late final String numberOfVolunteer;
  late final String hours;

  VolunteerModel({
    required this.id,
    required this.gender,
    required this.title,
    required this.city,
    required this.description,
    required this.eventEndDate,
    required this.image,
    required this.hours,
    required this.numberOfVolunteer,
    required this.userID,
    required this.userAdded,
  });

  VolunteerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gender = json['gender'];
    title = json['title'];
    city = json['city'];
    description = json['description'];
    eventEndDate = json['event_end_date'];
    image = json['image'];
    hours = json['hours'];
    numberOfVolunteer = json['number_of_volunteers'];
    userID = json['user_id'];
    userAdded = json['user_added'];
  }
}
