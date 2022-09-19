import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ju_offices/modules/teacher_home/cubit/teacher_cubit.dart';
import 'package:ju_offices/modules/teacher_home/teacher_home_screen.dart';
import 'package:ju_offices/shared/styles/colors.dart';

import '../../shared/components/components.dart';
import '../teacher_home/cubit/teacher_states.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  static const String route = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Duration duration = const Duration(milliseconds: 900);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Text(
                  "تسجيل الدخول",
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
      body: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {
          if (state is LoginWithEmailLinkErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        builder: (context, state) {
          TeacherCubit teacherCubit = TeacherCubit.getInstance(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FadeInDown(
                    duration: duration,
                    delay: const Duration(milliseconds: 1300),
                    child: Text(
                      "نظام تسجيل الدخول مسموح فقط للمدرسين, حيث يمكن للطلبة الدخول إلى التطبيق من غير الحاجة إلى تسجيل الدخول ",
                      textDirection: TextDirection.rtl,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInDown(
                    duration: duration,
                    delay: const Duration(milliseconds: 1000),
                    child: TextFormField(
                      scrollPhysics: const BouncingScrollPhysics(),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorHeight: 25,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Icon(Icons.email_outlined,
                                  color: kMainLightColor),
                            ],
                          ),
                        ),
                        hintText: 'example@ju.edu.jo',
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: kMainLightColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "لا يمكن أن يكون هذا الحقل فارغ";
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (String? value) {
                        if (formKey.currentState!.validate()) {}
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  state is LoginWithEmailLinkLoadingState
                      ? Center(
                          child: CupertinoActivityIndicator(
                            radius: 15,
                            color: kMainLightColor,
                          ),
                        )
                      : FadeInDown(
                          duration: duration,
                          delay: const Duration(milliseconds: 600),
                          child: defaultButton(
                            backgroundColor: kMainLightColor,
                            onPress: () async {
                              if (formKey.currentState!.validate()) {
                                bool isTeacher = false;
                                isTeacher =
                                    await TeacherCubit.getInstance(context)
                                        .isItTeacher(
                                  emailController.text.trim(),
                                );
                                if (isTeacher) {
                                  teacherCubit.loginWithLink(
                                    context: context,
                                    email: emailController.text.trim(),
                                    goTo: TeacherHomeScreen.route,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "البريد الإلكتروني الذي أدخلته غير مسجل لدينا كـ بريد إلكتروني لمدرس في الجامعة الأردنية",
                                    textColor: kMainLightColor,
                                    backgroundColor: Colors.amber,
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                }
                              }
                            },
                            text: 'دخول',
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
