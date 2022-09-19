import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ju_offices/modules/student_home/cubit/student_cubit.dart';
import 'package:ju_offices/modules/student_home/cubit/student_states.dart';
import 'package:ju_offices/modules/teacher_home/cubit/teacher_states.dart';
import 'package:ju_offices/shared/components/components.dart';
import 'package:ju_offices/shared/styles/colors.dart';

import 'cubit/teacher_cubit.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  static const String route = "TeacherHomeScreen";

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  bool? online;
  int time = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {
        if (state is ChangeStatusSuccessState ||
            state is LoginWithEmailLinkSuccessState) {
          TeacherCubit.getInstance(context).getStatus(
            TeacherCubit.getInstance(context).teacher!.id,
          );
        }
        if (state is LoginWithEmailLinkSuccessState) {
          Fluttertoast.showToast(
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        if (state is ChangeStatusErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
          );
        }
        if (state is GetStatusErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
          );
        }
        if (state is SignOutErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
          );
        }
        if (state is GetTeacherDataSuccessState) {
          if (TeacherCubit.getInstance(context).teacher!.time != 0) {
            if (DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(
                TeacherCubit.getInstance(context).teacher!.time))) {
              TeacherCubit.getInstance(context)
                  .resetStatus(TeacherCubit.getInstance(context).teacher!.id);
              TeacherCubit.getInstance(context)
                  .resetTime(TeacherCubit.getInstance(context).teacher!.id);
            }
          }
        }
      },
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot>(
          stream: StudentCubit.getInstance(context).loadUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                TeacherCubit.getInstance(context).teacher != null) {
              List<Map<String, dynamic>?>? docs = snapshot.data!.docs.map((e) {
                return e.data() as Map<String, dynamic>?;
              }).toList();
              var doc = docs.firstWhere(
                (doc) =>
                    doc!['id'] == TeacherCubit.getInstance(context).teacher!.id,
              );
              online = doc!['isOnline'];
              time = doc['time'];
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  '',
                  style: TextStyle(
                    color: kWhiteColor,
                  ),
                ),
                actions: [
                  defaultTextButton(
                    onPress: () async {
                      TeacherCubit.getInstance(context).signOut(context);
                    },
                    text: "تسجيل الخروج",
                    color: kWhiteColor,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02)
                ],
                backgroundColor: kMainLightColor,
              ),
              body: state is GetTeacherDataLoadingState ||
                      online == null ||
                      !snapshot.hasData ||
                      TeacherCubit.getInstance(context).teacher == null
                  ? Center(
                      child: CupertinoActivityIndicator(
                        radius: 15,
                        color: kMainLightColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: BlocConsumer<StudentCubit, StudentStates>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (snapshot.hasError) {
                            Fluttertoast.showToast(
                              msg: snapshot.error.toString(),
                              backgroundColor: Colors.red,
                              gravity: ToastGravity.CENTER,
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return const Center(
                              child: Text(""),
                            );
                          }
                          return Center(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1),
                                Text(
                                  TeacherCubit.getInstance(context)
                                      .teacher!
                                      .name,
                                  // teacher!.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 35),
                                ),
                                const SizedBox(height: 20),
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/person-icon.png'),
                                  radius: 60,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25),
                                Wrap(
                                  // textDirection: TextDirection.RTL,
                                  children: [
                                    AnimatedCrossFade(
                                      firstChild: Text(
                                        // TeacherCubit.getInstance(context).isOnline
                                        "مُتاح",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                fontSize: 30,
                                                color:
                                                    // TeacherCubit.getInstance(context)
                                                    //         .isOnline
                                                    Colors.green),
                                      ),
                                      secondChild: Text(
                                        // TeacherCubit.getInstance(context).isOnline
                                        "غير مُتاح",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                              fontSize: 30,
                                              color:
                                                  // TeacherCubit.getInstance(context)
                                                  //         .isOnline
                                                  Colors.redAccent
                                                      .withOpacity(0.9),
                                            ),
                                      ),
                                      crossFadeState: online ?? false
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                      // firstCurve: Curves.elasticInOut,
                                      // secondCurve: Curves.elasticInOut,
                                      duration:
                                          const Duration(milliseconds: 200),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "أنت الآن",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                            fontSize: 30,
                                          ),
                                    ),
                                  ],
                                ),
                                time != 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat.jm().format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    time)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(
                                                  fontSize: 25,
                                                ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "لغاية الساعة",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(
                                                  fontSize: 25,
                                                ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05),
                                state is GetStatusLoadingState
                                    ? CupertinoActivityIndicator(
                                        radius: 15,
                                        color: kMainLightColor,
                                      )
                                    : defaultButton(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 45,
                                        backgroundColor:
                                            // TeacherCubit.getInstance(context)
                                            //         .isOnline
                                            online ?? false
                                                ? Colors.redAccent
                                                    .withOpacity(0.9)
                                                : Colors.green,
                                        onPress: () {
                                          if (!online!) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  customDialog(
                                                context: context,
                                                cubit: TeacherCubit.getInstance(
                                                  context,
                                                ),
                                                title: "حدد الوقت",
                                                body:
                                                    "من فضلك حدد الوقت الذي سوف تبقى به متاحاً في المكتب ",
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              TeacherCubit.getInstance(context)
                                                  .resetStatus(
                                                      TeacherCubit.getInstance(
                                                              context)
                                                          .teacher!
                                                          .id)
                                                  // changeStatus(
                                                  //   TeacherCubit.getInstance(
                                                  //           context)
                                                  //       .teacher!
                                                  //       .id,
                                                  // )
                                                  .then((value) {
                                                TeacherCubit.getInstance(
                                                        context)
                                                    .resetTime(
                                                  TeacherCubit.getInstance(
                                                          context)
                                                      .teacher!
                                                      .id,
                                                );
                                              });
                                              // print(
                                              //     "Is Timer type: ${TeacherCubit.getInstance(context).timer is Timer}");
                                              // if (TeacherCubit.getInstance(
                                              //         context)
                                              //     .timer is Timer) {
                                              //   TeacherCubit.getInstance(
                                              //           context)
                                              //       .timer
                                              //       .cancel();
                                              // }
                                            });
                                          }
                                        },
                                        text:
                                            // TeacherCubit.getInstance(context)
                                            //         .isOnline
                                            online ?? false ? "خروج" : "مُتاح",
                                        textWeight: FontWeight.w700,
                                        textSize: 20,
                                      ),
                                // TeacherCubit.getInstance(context).time != ""
                                //     ? Text(
                                //         TeacherCubit.getInstance(context).time)
                                //     : Text("")
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
