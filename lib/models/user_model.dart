class UserModel {
  late final String id;
  late final String fullName;
  late final String bloodType;
  late final String college;
  late final String dateOfBirth;
  late final String email;
  late final String gender;
  late final String interests;
  late final String major;
  late final String password;
  late final int roleID;
  late final String skills;
  late final String universityID;
  late final String userImage;
  late final String volunteeringLevel;
  late final String phone;

  UserModel({
    required this.id,
    required this.interests,
    required this.skills,
    required this.volunteeringLevel,
    required this.major,
    required this.college,
    required this.dateOfBirth,
    required this.gender,
    required this.password,
    required this.email,
    required this.fullName,
    required this.universityID,
    required this.bloodType,
    required this.roleID,
    required this.userImage,
    required this.phone,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    // required this.id,
    interests = json['interests'];
    skills = json['skills'];
    volunteeringLevel = json['volunteering_level'];
    major = json['major'];
    college = json['college'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    password = json['password'];
    email = json['email'];
    fullName = json['full_name'];
    universityID = json['university_id'];
    bloodType = json['blood_type'];
    roleID = json['role_id'];
    userImage = json['user_image'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['interests'] = interests;
    data['skills'] = skills;
    data['volunteering_level'] = volunteeringLevel;
    data['major'] = major;
    data['college'] = college;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['password'] = password;
    data['email'] = email;
    data['full_name'] = fullName;
    data['university_id'] = universityID;
    data['blood_type'] = bloodType;
    data['role_id'] = roleID;
    data['user_image'] = userImage;
    data['phone'] = phone;

    return data;
  }
}
