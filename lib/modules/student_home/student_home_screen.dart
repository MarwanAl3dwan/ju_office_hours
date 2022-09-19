import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ju_offices/modules/faculty/faculty_screen.dart';
import 'package:ju_offices/modules/student_home/cubit/student_cubit.dart';
import 'package:ju_offices/shared/components/functions.dart';
import 'package:ju_offices/shared/styles/colors.dart';

import 'cubit/student_states.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  static const String route = "StudentHomeScreen";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentCubit, StudentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "كليات الجامة الأردنية",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
          body: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: StudentCubit.getInstance(context).faculties.length,
            itemBuilder: (context, index) {
              return facultyItem(context: context, index: index);
            },
          ),
        );
      },
    );
  }
}

Widget facultyItem({required BuildContext context, required int index}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        GestureDetector(
          onTap: () {
            navigateToWithAnimation(
              context: context,
              screen: FacultyScreen(
                arFacultyName:
                    StudentCubit.getInstance(context).faculties[index].arName,
                enFacultyName:
                    StudentCubit.getInstance(context).faculties[index].enName,
              ),
            );
          },
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      StudentCubit.getInstance(context).faculties[index].image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 55,
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.8),
                width: 200,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  textAlign: TextAlign.center,
                  StudentCubit.getInstance(context).faculties[index].arName,
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 17,
                    height: 0.9,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
        StudentCubit.getInstance(context).faculties[index].isActive
            ? Container()
            : Container(
                height: double.infinity,
                width: 200,
                color: Colors.black.withOpacity(0.75),
                child: Center(
                  child: Text(
                    "..قريباً",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
      ],
    ),
  );
}
