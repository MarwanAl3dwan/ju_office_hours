import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_sdk/magic_sdk.dart';

import 'cubit/app_cubit.dart';
import 'cubit/app_states.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/onborading_screen.dart';
import 'modules/snplash/splash_screen.dart';
import 'modules/student_home/cubit/student_cubit.dart';
import 'modules/student_home/student_home_screen.dart';
import 'modules/teacher_home/cubit/teacher_cubit.dart';
import 'modules/teacher_home/teacher_home_screen.dart';
import 'modules/user_type/user_ype_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();

  // var deviceToken = await FirebaseMessaging.instance.getToken();
  // print("deviceToken: $deviceToken");

  isOnBoardingDone = CacheHelper.getData(key: 'OnBoarding');
  // CacheHelper.removeData(key: 'OnBoarding');
  // CacheHelper.removeData(key: 'uId');

  uId = CacheHelper.getData(key: 'uId');
  // print("User ID");
  // print(uId);
  Widget startWidget = const OnBoardingScreen();
  if (isOnBoardingDone != null) {
    startWidget = const SplashScreen();
  }
  if (uId != null && uId != '') {
    startWidget = const TeacherHomeScreen();
  }

  BlocOverrides.runZoned(
    () => runApp(MyApp(startWidget: startWidget)),
    blocObserver: MyBlocObserver(),
  );
  Magic.instance = Magic("pk_live_694EB145D4B2621F");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(),
        ),
        BlocProvider(
          create: (context) => StudentCubit(),
        ),
        BlocProvider(
          create: (context) => TeacherCubit()..getTeacherData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: Stack(
              children: [
                MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: ThemeMode.light,
                  title: 'JUOfficeHours',
                  home: startWidget,
                  routes: {
                    UserTypeScreen.route: (context) => const UserTypeScreen(),
                    StudentHomeScreen.route: (context) =>
                        const StudentHomeScreen(),
                    TeacherHomeScreen.route: (context) =>
                        const TeacherHomeScreen(),
                    LoginScreen.route: (context) => LoginScreen(),
                  },
                ),
                Magic.instance.relayer,
              ],
            ),
          );
        },
      ),
    );
  }
}
