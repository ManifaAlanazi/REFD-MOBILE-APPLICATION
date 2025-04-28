import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:refd_app/helpers/shared_text.dart';
import 'package:refd_app/logic/volunteer_cubit/volunteer_states.dart';
import 'package:refd_app/models/user_model.dart';
import 'package:refd_app/models/volunteer_model.dart';
import 'package:refd_app/models/volunteer_request_model.dart';

class VolunteerCubit extends Cubit<VolunteerStates> {
  VolunteerCubit() : super(AddVolunteerInitState());

  static VolunteerCubit get(context) => BlocProvider.of(context);

  int numberOfVolunteersHours = 0;
  List<UserModel> usersListForAdmin = [];
  List<VolunteerModel> getAllVolunteersForAdmin = [];

  List<VolunteerModel> activeVolunteerList = [];
  List<VolunteerModel> upComingVolunteerList = [];
  List<VolunteerModel> completeVolunteerList = [];

  List<VolunteerModel> allVolunteerListForSearch = [];
  List<VolunteerModel> filterVolunteerListForSearch = [];

  List<VolunteerModel> myVolunteersList = [];
  List<VolunteerModel> myContributionsRequests = [];

  List<VolunteerRequestsModel> volunteerRequests = [];

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> addNewVolunteer({
    File? image,
    required String title,
    required String description,
    required String eventEndTime,
    required String gender,
    required String city,
    required String numberOfVolunteers,
    required String hours,
  }) async {
    emit(AddVolunteerLoadingState());

    if (image == null) {
      await FirebaseFirestore.instance.collection("volunteers").add(
        {
          "image":
              "https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=2048x2048&w=is&k=20&c=ohMtddTt7BppCvEUNGqJ9FRDyJqAdkzonVQ7KmWbTrg=",
          "user_id": SharedText.userToken,
          "user_added": SharedText.userModel!.fullName,
          "title": title,
          "description": description,
          "event_end_date": eventEndTime,
          "gender": gender,
          "city": city,
          "number_of_volunteers": numberOfVolunteers,
          "hours": hours,
        },
      ).then((value) {
        getAllVolunteer();
        emit(AddVolunteerSuccessState());
      }).catchError((err) {
        AddVolunteerErrorState(error: err.toString());
      });
    } else {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child("images/${Uri.file(image.path)}")
          .putFile(image)
          .then((snapShot) {
        snapShot.ref.getDownloadURL().then((imageUrl) async {
          await FirebaseFirestore.instance.collection("volunteers").add(
            {
              "image": imageUrl,
              "user_id": SharedText.userToken,
              "user_added": SharedText.userModel!.fullName,
              "title": title,
              "description": description,
              "event_end_date": eventEndTime,
              "gender": gender,
              "city": city,
              "number_of_volunteers": numberOfVolunteers,
              "hours": hours,
            },
          ).then((value) {
            getAllVolunteer();
            emit(AddVolunteerSuccessState());
          }).catchError((err) {
            AddVolunteerErrorState(error: err.toString());
          });
        });
      });
    }
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getAllVolunteer() async {
    activeVolunteerList.clear();
    upComingVolunteerList.clear();
    completeVolunteerList.clear();
    emit(GetAllVolunteerLoadingState());

    String dateString = DateFormat("yyyy-MM-dd").format(DateTime.now());

    DateTime currentDate = DateTime.parse(dateString);

    FirebaseFirestore.instance.collection("volunteers").get().then((value) {
      int count = 0;
      for (var pet in value.docs) {
        if (DateTime.parse(pet.data()['event_end_date']).isAfter(currentDate)) {
          upComingVolunteerList.add(
            VolunteerModel(
              id: pet.id,
              gender: pet.data()['gender'],
              title: pet.data()['title'],
              city: pet.data()['city'],
              description: pet.data()['description'],
              eventEndDate: pet.data()['event_end_date'],
              image: pet.data()['image'],
              hours: pet.data()['hours'],
              numberOfVolunteer: pet.data()['number_of_volunteers'],
              userID: pet.data()['user_id'],
              userAdded: pet.data()['user_added'],
            ),
          );
        } else if (DateTime.parse(pet.data()['event_end_date'])
            .isBefore(currentDate)) {
          count += int.parse(pet.data()['hours']);
          completeVolunteerList.add(
            VolunteerModel(
              id: pet.id,
              gender: pet.data()['gender'],
              title: pet.data()['title'],
              city: pet.data()['city'],
              description: pet.data()['description'],
              eventEndDate: pet.data()['event_end_date'],
              image: pet.data()['image'],
              hours: pet.data()['hours'],
              numberOfVolunteer: pet.data()['number_of_volunteers'],
              userID: pet.data()['user_id'],
              userAdded: pet.data()['user_added'],
            ),
          );
        } else {
          activeVolunteerList.add(
            VolunteerModel(
              id: pet.id,
              gender: pet.data()['gender'],
              title: pet.data()['title'],
              city: pet.data()['city'],
              description: pet.data()['description'],
              eventEndDate: pet.data()['event_end_date'],
              image: pet.data()['image'],
              hours: pet.data()['hours'],
              numberOfVolunteer: pet.data()['number_of_volunteers'],
              userID: pet.data()['user_id'],
              userAdded: pet.data()['user_added'],
            ),
          );
        }
      }
      numberOfVolunteersHours = count;
      getAllVolunteersForAdmin = [
        ...activeVolunteerList,
        ...upComingVolunteerList,
        ...completeVolunteerList
      ];
      emit(GetAllVolunteerSuccessState());
    }).catchError((err) {
      emit(GetAllVolunteerErrorState(error: err.toString()));
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> registerOnVolunteer({
    required String volunteerID,
    required String registeredUserID,
    required String registeredUserName,
    required String registeredEmail,
    required String registeredPhone,
    required String volunteerCount,
    required String volunteerTitle,
  }) async {
    emit(RegisterOnVolunteerLoadingState());

    await FirebaseFirestore.instance
        .collection("volunteers")
        .doc(volunteerID)
        .collection("requests")
        .get()
        .then((value) async {
      if (value.docs.length >= int.parse(volunteerCount)) {
        emit(RegisterOnVolunteerErrorState(
            error: "Sorry, the number of volunteers is complete"));
      } else {
        await FirebaseFirestore.instance
            .collection("volunteers")
            .doc(volunteerID)
            .collection("requests")
            .where("user_id", isEqualTo: SharedText.userToken)
            .get()
            .then((value) async {
          if (value.docs.isEmpty) {
            await FirebaseFirestore.instance
                .collection("volunteers")
                .doc(volunteerID)
                .collection("requests")
                .add({
              "user_id": registeredUserID,
              "user_name": registeredUserName,
              "user_email": registeredEmail,
              "user_phone": registeredPhone,
              "request_status": "waiting",
              "volunteer_title": volunteerTitle,
            });
            emit(RegisterOnVolunteerSuccessState());
          } else {
            emit(
              RegisterOnVolunteerErrorState(
                  error: "You have already registered before"),
            );
          }
        });
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getRequestsOnMyVolunteers() async {
    volunteerRequests.clear();
    emit(GetRegisterOnVolunteerLoadingState());
    await FirebaseFirestore.instance
        .collection("volunteers")
        .where("user_id", isEqualTo: SharedText.userToken)
        .get()
        .then((value) async {
      for (var volunteer in value.docs) {
        await FirebaseFirestore.instance
            .collection("volunteers")
            .doc(volunteer.id)
            .collection("requests")
            .get()
            .then((requests) {
          if (requests.docs.isNotEmpty) {
            for (var request in requests.docs) {
              if (request.data()['user_id'] != SharedText.userToken) {
                volunteerRequests.add(VolunteerRequestsModel(
                  userID: request.data()['user_id'],
                  requestID: request.id,
                  userEmail: request.data()['user_email'],
                  userName: request.data()['user_name'],
                  userPhone: request.data()['user_phone'],
                  volunteerTitle: request.data()['volunteer_title'] ?? "",
                  requestStatus: request.data()['request_status'] ?? "",
                ));
              }
            }
          }
          emit(GetRegisterOnVolunteerSuccessState());
        }).catchError((err) {
          GetRegisterOnVolunteerErrorState(error: err.toString());
        });
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> changeStatusOfRegisterVolunteer({
    required String requestID,
    required String status,
  }) async {
    emit(ChangeStatusVolunteerRequestLoadingState());

    await FirebaseFirestore.instance
        .collection("volunteers")
        .get()
        .then((value) async {
      for (var volunteer in value.docs) {
        await FirebaseFirestore.instance
            .collection("volunteers")
            .doc(volunteer.id)
            .collection("requests")
            .doc(requestID)
            .update({
          "request_status": status,
        }).then((value) {
          getRequestsOnMyVolunteers();
          emit(ChangeStatusVolunteerRequestSuccessState());
        }).catchError((err) {
          ChangeStatusVolunteerRequestErrorState(error: err.toString());
        });
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getAllVolunteersForSearch({required String key}) async {
    allVolunteerListForSearch.clear();
    emit(GetAllVolunteersForSearchLoadingState());
    await FirebaseFirestore.instance
        .collection("volunteers")
        .get()
        .then((value) {
      for (var pet in value.docs) {
        allVolunteerListForSearch.add(
          VolunteerModel(
            id: pet.id,
            gender: pet.data()['gender'],
            title: pet.data()['title'],
            city: pet.data()['city'],
            description: pet.data()['description'],
            eventEndDate: pet.data()['event_end_date'],
            image: pet.data()['image'],
            hours: pet.data()['hours'],
            numberOfVolunteer: pet.data()['number_of_volunteers'],
            userID: pet.data()['user_id'],
            userAdded: pet.data()['user_added'],
          ),
        );
      }

      filterVolunteerListForSearch = allVolunteerListForSearch
          .where((volunteer) => volunteer.title.toLowerCase().contains(key))
          .toList();
      emit(GetAllVolunteersForSearchSuccessState());
    }).catchError((err) {
      GetAllVolunteersForSearchErrorState(error: err.toString());
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getMyVolunteers() async {
    myVolunteersList.clear();
    emit(GetMyVolunteersLoadingState());
    await FirebaseFirestore.instance
        .collection("volunteers")
        .get()
        .then((value) {
      for (var pet in value.docs) {
        if (pet.data()['user_id'] == SharedText.userToken) {
          myVolunteersList.add(
            VolunteerModel(
              id: pet.id,
              gender: pet.data()['gender'],
              title: pet.data()['title'],
              city: pet.data()['city'],
              description: pet.data()['description'],
              eventEndDate: pet.data()['event_end_date'],
              image: pet.data()['image'],
              hours: pet.data()['hours'],
              numberOfVolunteer: pet.data()['number_of_volunteers'],
              userID: pet.data()['user_id'],
              // status: "",
              userAdded: pet.data()['user_added'],
            ),
          );
        }
      }
      emit(GetMyVolunteersSuccessState());
    }).catchError((err) {
      GetMyVolunteersErrorState(error: err.toString());
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getMyContributions() async {
    myContributionsRequests.clear();
    emit(GetMyContributionsLoadingState());

    await FirebaseFirestore.instance
        .collection("volunteers")
        .get()
        .then((value) async {
      for (var volunteer in value.docs) {
        await FirebaseFirestore.instance
            .collection("volunteers")
            .doc(volunteer.id)
            .collection("requests")
            .get()
            .then((requests) {
          if (requests.docs.isNotEmpty) {
            for (var request in requests.docs) {
              if (request.data()['user_id'] == SharedText.userToken) {
                myContributionsRequests.add(VolunteerModel(
                  id: volunteer.id,
                  gender: volunteer.data()['gender'],
                  title: volunteer.data()['title'],
                  city: volunteer.data()['city'],
                  description: volunteer.data()['description'],
                  eventEndDate: volunteer.data()['event_end_date'],
                  image: volunteer.data()['image'],
                  hours: volunteer.data()['hours'],
                  numberOfVolunteer: volunteer.data()['number_of_volunteers'],
                  userID: volunteer.data()['user_id'],
                  userAdded: volunteer.data()['user_added'],
                ));
              }
            }
          }
          emit(GetMyVolunteersSuccessState());
        }).catchError((err) {
          GetMyVolunteersErrorState(error: err.toString());
        });
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getAllUsersForAdmin() async {
    usersListForAdmin.clear();
    emit(GetAllUsersForAdminLoadingState());

    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var pet in value.docs) {
        if (pet.data()['role_id'] != 1) {
          usersListForAdmin.add(UserModel.fromJson(pet.data()));
        }
      }
      emit(GetAllUsersForAdminSuccessState());
    }).catchError((err) {
      emit(GetAllUsersForAdminErrorState(error: err.toString()));
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getAllRequestsForAdmin() async {
    volunteerRequests.clear();
    emit(GetRegisterOnVolunteerLoadingState());

    await FirebaseFirestore.instance
        .collection("volunteers")
        .get()
        .then((value) async {
      for (var volunteer in value.docs) {
        await FirebaseFirestore.instance
            .collection("volunteers")
            .doc(volunteer.id)
            .collection("requests")
            .get()
            .then((requests) {
          if (requests.docs.isNotEmpty) {
            for (var request in requests.docs) {
              volunteerRequests.add(VolunteerRequestsModel(
                userID: request.data()['user_id'],
                requestID: request.id,
                userEmail: request.data()['user_email'],
                userName: request.data()['user_name'],
                userPhone: request.data()['user_phone'],
                volunteerTitle: request.data()['volunteer_title'] ?? "",
                requestStatus: request.data()['request_status'] ?? "",
              ));
            }
          }
          emit(GetRegisterOnVolunteerSuccessState());
        }).catchError((err) {
          GetRegisterOnVolunteerErrorState(error: err.toString());
        });
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> deleteVolunteer({
    required String volunteerID,
  }) async {
    emit(DeleteVolunteerLoadingState());

    await FirebaseFirestore.instance
        .collection("volunteers")
        .doc(volunteerID)
        .delete()
        .then((value) {
      getAllVolunteer();
      emit(DeleteVolunteerSuccessState());
    }).catchError((err) {
      DeleteVolunteerErrorState(error: err.toString());
    });
  }

////////////////////////////////////////////////////////////////////////////////////

  Future<dynamic> getVolunteerRequests({
    required String volunteerID,
  }) async {
    volunteerRequests.clear();
    emit(GetVolunteerRequestsLoadingState());

    await FirebaseFirestore.instance
        .collection("volunteers")
        .doc(volunteerID)
        .collection("requests")
        .get()
        .then((requests) {
      if (requests.docs.isNotEmpty) {
        for (var request in requests.docs) {
          if (request.data()['user_id'] != SharedText.userToken) {
            volunteerRequests.add(
              VolunteerRequestsModel(
                userID: request.data()['user_id'],
                requestID: request.id,
                userEmail: request.data()['user_email'],
                userName: request.data()['user_name'],
                userPhone: request.data()['user_phone'],
                volunteerTitle: request.data()['volunteer_title'] ?? "",
                requestStatus: request.data()['request_status'] ?? "",
              ),
            );
          }
        }
      }
      emit(GetVolunteerRequestsSuccessState());
    }).catchError((err) {
      GetVolunteerRequestsErrorState(error: err.toString());
    });
  }
}
