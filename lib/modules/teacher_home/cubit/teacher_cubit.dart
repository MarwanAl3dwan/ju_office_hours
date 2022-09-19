import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ju_offices/modules/teacher_home/cubit/teacher_states.dart';
import 'package:ju_offices/shared/components/constants.dart';
import 'package:ju_offices/shared/components/functions.dart';
import 'package:ju_offices/shared/styles/colors.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:magic_sdk/modules/user/user_module.dart';

import '../../../models/teacher.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../user_type/user_ype_screen.dart';

class TeacherCubit extends Cubit<TeacherStates> {
  TeacherCubit() : super(TeacherInitialStates());

  static TeacherCubit getInstance(BuildContext context) =>
      BlocProvider.of(context);

  bool isOnline = false;
  int time = 0;
  final _firestore = FirebaseFirestore.instance;

  Future<void> changeStatus(String uId) async {
    emit(ChangeStatusLoadingState());
    isOnline = !isOnline;
    await _firestore.collection("Users").doc(uId).update({
      'isOnline': isOnline,
    }).then((value) {
      emit(ChangeStatusSuccessState());
    }).catchError((error) {
      emit(ChangeStatusErrorState(error.toString()));
    });
  }

  Future<void> resetStatus(String uId) async {
    emit(ChangeStatusLoadingState());
    isOnline = false;
    await _firestore.collection("Users").doc(uId).update({
      'isOnline': isOnline,
    }).then((value) {
      emit(ChangeStatusSuccessState());
    }).catchError((error) {
      emit(ChangeStatusErrorState(error.toString()));
    });
  }

  Future<void> changeTime(String uId, int selectedTime) async {
    emit(ChangeTimeLoadingState());
    time = selectedTime;
    await _firestore.collection("Users").doc(uId).update({
      'time': time,
    }).then((value) {
      emit(ChangeTimeSuccessState());
    }).catchError((error) {
      emit(ChangeTimeErrorState(error.toString()));
    });
  }

  Future<void> resetTime(String uId) async {
    emit(ResetTimeLoadingState());
    time = 0;
    await _firestore.collection("Users").doc(uId).update({
      'time': 0,
    }).then((value) {
      emit(ResetTimeSuccessState());
    }).catchError((error) {
      emit(ResetTimeErrorState(error.toString()));
    });
  }

  Future<void> getStatus(String userId) async {
    emit(GetStatusLoadingState());
    await _firestore
        .collection("Users")
        // .doc(user!.uid)
        .doc(userId)
        .get()
        .then((value) {
      isOnline = value.data()!['isOnline'];
      time = value.data()!['time'];
      emit(GetStatusSuccessState());
    }).catchError((error) {
      emit(GetStatusErrorState(error.toString()));
    });
  }

  Teacher? teacher;
  UserModule? user;
  FirebaseAuth auth = FirebaseAuth.instance;

  void signOut(BuildContext context) async {
    emit(SignOutLoadingState());
    await Magic.instance.user.logout();
    CacheHelper.removeData(key: 'uId').then((value) {
      emit(SignOutSuccessState());
      FirebaseMessaging.instance.unsubscribeFromTopic("Users");
      navigateAndRemoveUntil(
        context: context,
        screenRoute: UserTypeScreen.route,
      );
    }).catchError((error) {
      emit(SignOutErrorState(error.toString()));
    });
    uId = null;
  }

  Future<void> getTeacherData() async {
    emit(GetTeacherDataLoadingState());
    String? id = CacheHelper.getData(key: 'uId');
    if (id != null) {
      await _firestore.collection("Users").doc(id).get().then((value) {
        teacher = Teacher.fromJSON(value.data()!);
        emit(GetTeacherDataSuccessState());
      }).catchError((error) {
        emit(GetTeacherDataErrorState(error.toString()));
      });
    } else {
      emit(GetTeacherDataSuccessState());
    }
  }

  Future<bool> isItTeacher(String email) async {
    bool teacher = false;
    await _firestore.collection("Database").get().then((value) {
      for (var doc in value.docs) {
        if (doc.data()['email'] == email) {
          teacher = true;
        }
      }
    }).catchError((error) {});
    return teacher;
  }

  Future<void> loginWithLink({
    required BuildContext context,
    required String email,
    required String goTo,
  }) async {
    emit(LoginWithEmailLinkLoadingState());

    await _firestore.collection("Database").get().then((value) async {
      String newId =
          value.docs.firstWhere((doc) => doc.data()['email'] == email).id;
      await _firestore
          .collection("Database")
          .doc(newId)
          .get()
          .then((value) async {
        bool hasAccount = false;
        String userId = newId;
        await _firestore.collection("Users").get().then((value) {
          for (var doc in value.docs) {
            if (doc.data()['email'] == email) {
              userId = doc.id;
              hasAccount = true;
            }
          }
        }).catchError((error) {
          Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: kWhiteColor,
          );
        });
        bool oldStatus = false;
        int oldTime = 0;
        if (hasAccount) {
          await _firestore.collection("Users").doc(userId).get().then((value) {
            oldStatus = value.data()!['isOnline'] ?? false;
            oldTime = value.data()!['time'];
            time = oldTime;
          }).catchError((error) {
            Fluttertoast.showToast(
              msg: error.toString(),
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: kWhiteColor,
            );
          });
        }
        await Magic.instance.auth
            .loginWithMagicLink(email: email)
            .then((value) {
          // String idToken = await Magic.instance.user.getIdToken();
          // print("IdToken: $idToken");
          CacheHelper.saveData(key: 'uId', value: userId).then((value) async {
            FirebaseMessaging.instance.subscribeToTopic("Users");
            user = Magic.instance.user;
          }).catchError((error) {
            Fluttertoast.showToast(
              msg: error.toString(),
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: kWhiteColor,
            );
          });
        }).catchError((error) {
          Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: kWhiteColor,
          );
        });
        await _firestore.collection("Users").doc(userId).set({
          'id': userId,
          'department': value.data()!['department'],
          'faculty': value.data()!['faculty'],
          'isOnline': hasAccount ? oldStatus : false,
          'userName': value.data()!['userName'],
          'time': hasAccount ? oldTime : 0,
          'email': email,
          'image': value.data()!['image'],
        }).then((_) async {
          await _firestore
              .collection("Users")
              .doc(userId)
              .get()
              .then((value) async {
            teacher = Teacher.fromJSON(value.data()!);
            emit(LoginWithEmailLinkSuccessState());
            bool isLoggedIn = await Magic.instance.user.isLoggedIn();
            if (isLoggedIn) {
              navigateAndRemoveUntil(context: context, screenRoute: goTo);
            }
          }).catchError((error) {
            Fluttertoast.showToast(
              msg: error.toString(),
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: kWhiteColor,
            );
          });
        }).catchError((error) {
          Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: kWhiteColor,
          );
        });
      });
    });
  }
}
