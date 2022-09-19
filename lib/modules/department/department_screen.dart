import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ju_offices/models/teacher.dart';
import 'package:ju_offices/modules/student_home/cubit/student_cubit.dart';
import 'package:ju_offices/modules/student_home/cubit/student_states.dart';
import 'package:ju_offices/modules/teacher_home/cubit/teacher_cubit.dart';
import 'package:ju_offices/modules/teacher_home/cubit/teacher_states.dart';

import '../../shared/styles/colors.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({
    Key? key,
    required this.arDeptName,
    required this.enDeptName,
    required this.arFacultyName,
    required this.enFacultyName,
  }) : super(key: key);

  final String arDeptName;
  final String enDeptName;
  final String arFacultyName;
  final String enFacultyName;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentCubit, StudentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<TeacherCubit, TeacherStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          arDeptName,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_forward,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: StudentCubit.getInstance(context).loadUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        radius: 15,
                        color: kMainLightColor,
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        radius: 15,
                        color: kMainLightColor,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<Teacher> teachers = StudentCubit.getInstance(context)
                        .getTeachersByDepartment(
                      faculty: enFacultyName,
                      dept: enDeptName,
                      userCollectionSnapshot: snapshot.data!.docs,
                    );
                    // Timer.periodic(const Duration(seconds: 1), (timer) {});
                    for (var teacher in teachers) {
                      if (teacher.time != 0) {
                        if (DateTime.now().isAfter(
                            DateTime.fromMillisecondsSinceEpoch(
                                teacher.time))) {
                          TeacherCubit.getInstance(context)
                              .resetStatus(teacher.id);
                          TeacherCubit.getInstance(context)
                              .resetTime(teacher.id);
                        }
                      }
                    }
                    return teachers.isEmpty
                        ? Center(
                            child: Text(
                              ".لا يوجد مدرسين متاحين في هذا القسم حالياً",
                              style: TextStyle(
                                fontSize: 18,
                                color: kMainLightColor,
                              ),
                            ),
                          )
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: teachers.length,
                            itemBuilder: (context, index) {
                              return buildTeacherItem(
                                context: context,
                                teacher: teachers[index],
                              );
                            },
                          );
                  } else {
                    return Center(
                      child: Text(
                        ".لا يوجد مدرسين متاحين في هذا القسم حالياً",
                        style: TextStyle(
                          fontSize: 18,
                          color: kMainLightColor,
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTeacherItem({
    required BuildContext context,
    required Teacher teacher,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: kMainLightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Column(
            children: [
              teacher.image == null
                  ? const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/person-icon.png'),
                      radius: 40,
                    )
                  : ClipOval(
                      child: Image.network(
                        teacher.image!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: (MediaQuery.of(context).size.width / 2) - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      teacher.name,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.3,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              CircleAvatar(
                backgroundColor: teacher.isOnline && teacher.time != 0
                    ? Colors.green
                    : Colors.red,
                radius: 10,
              ),
              const SizedBox(height: 10),
              teacher.isOnline && teacher.time != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.jm()
                              .format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  teacher.time,
                                ),
                              )
                              .toString(),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "متاح حتى الساعة",
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                        ),
                      ],
                    )
                  : const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
