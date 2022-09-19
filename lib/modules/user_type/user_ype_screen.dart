import 'package:flutter/material.dart';
import 'package:ju_offices/modules/student_home/student_home_screen.dart';
import 'package:ju_offices/shared/components/functions.dart';
import 'package:ju_offices/shared/styles/colors.dart';

import '../../shared/components/components.dart';
import '../login/login_screen.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({Key? key}) : super(key: key);

  static const String route = "UserType";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الصفحة الرئيسية"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/images/student.png'),
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: MediaQuery.of(context).size.width / 2 - 30,
                  ),
                  defaultButton(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: 40,
                    text: "الدخول كـ طالب",
                    textSize: 17,
                    isUpperCase: false,
                    onPress: () {
                      navigateToWithAnimation(
                          context: context, screen: const StudentHomeScreen());
                    },
                    backgroundColor: kMainLightColor,
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/images/teacher.png'),
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: MediaQuery.of(context).size.width / 2 - 30,
                  ),
                  defaultButton(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: 40,
                    text: "الدخول كـ مُدرس",
                    textSize: 17,
                    isUpperCase: false,
                    onPress: () async {
                      // print(x);
                      navigateToWithAnimation(
                        context: context,
                        screen: LoginScreen(),
                      );
                    },
                    backgroundColor: kMainLightColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
