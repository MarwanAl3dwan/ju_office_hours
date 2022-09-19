import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ju_offices/models/department.dart';
import 'package:ju_offices/modules/department/department_screen.dart';
import 'package:ju_offices/modules/student_home/cubit/student_cubit.dart';
import 'package:ju_offices/modules/student_home/cubit/student_states.dart';
import 'package:ju_offices/shared/components/functions.dart';
import 'package:ju_offices/shared/styles/colors.dart';

class FacultyScreen extends StatelessWidget {
  const FacultyScreen({
    Key? key,
    required this.arFacultyName,
    required this.enFacultyName,
  }) : super(key: key);

  final String arFacultyName;
  final String enFacultyName;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentCubit, StudentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Department> departments = StudentCubit.getInstance(context)
            .faculties
            .firstWhere((faculty) => faculty.arName == arFacultyName)
            .departments;
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
                      arFacultyName,
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  return departmentItem(
                    arFacultyName: arFacultyName,
                    enFacultyName: enFacultyName,
                    context: context,
                    department: departments[index],
                  );
                }),
          ),
        );
      },
    );
  }
}

Widget departmentItem({
  required BuildContext context,
  required Department department,
  required String arFacultyName,
  required String enFacultyName,
}) {
  return GestureDetector(
    onTap: !department.isActive
        ? null
        : () {
            navigateToWithAnimation(
              context: context,
              screen: DepartmentScreen(
                arDeptName: department.arName,
                enDeptName: department.enName,
                arFacultyName: arFacultyName,
                enFacultyName: enFacultyName,
              ),
            );
          },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 5,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 8,
              decoration: BoxDecoration(
                color: kMainLightColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      department.arName,
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: kWhiteColor,
                            fontSize: 20,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            department.isActive
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height / 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
      ),
    ),
  );
}
