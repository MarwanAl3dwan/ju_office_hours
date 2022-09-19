import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ju_offices/modules/snplash/splash_data.dart';
import 'package:ju_offices/modules/user_type/user_ype_screen.dart';
import 'package:ju_offices/shared/components/functions.dart';
import 'package:ju_offices/shared/styles/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 10)).then((value) {
      navigateAndRemoveUntil(
        context: context,
        screenRoute: UserTypeScreen.route,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    int index = Random().nextInt(notes.length);
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(pics[index]),
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
            ),
            Text(
              notes[index],
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kMainLightColor),
            ),
            const SizedBox(height: 20),
            CupertinoActivityIndicator(
              radius: 15,
              color: kMainLightColor,
            ),
          ],
        ),
      ),
    );
  }
}
