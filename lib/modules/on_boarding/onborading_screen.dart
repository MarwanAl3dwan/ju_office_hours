import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ju_offices/cubit/app_states.dart';
import 'package:ju_offices/shared/components/components.dart';
import 'package:ju_offices/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../cubit/app_cubit.dart';
import '../../shared/components/functions.dart';
import '../../shared/network/local/cache_helper.dart';
import '../user_type/user_ype_screen.dart';

class BoardingModel {
  final String title;
  final String image;
  final String body;

  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  static const String route = "OnBoardingScreen";

  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController boardingController = PageController();
  bool isLast = false;

  void submitOnBoarding() {
    /// Save in the local memory (shared preferences / cache) that the user is has already run the application at the first time
    /// and the the app shouldn't go to OnBoardingScreen any more.
    /// GO TO LoginScreen
    CacheHelper.saveData(key: 'OnBoarding', value: true).then((value) {
      if (value) {
        navigateAndRemoveUntil(
          context: context,
          screenRoute: UserTypeScreen.route,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leadingWidth: (screenHeight + screenWidth) / 15,
            leading: defaultTextButton(
              onPress: submitOnBoarding,
              text: "تخطي",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kMainLightColor,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all((screenHeight + screenWidth) / 40.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    reverse: true,
                    controller: boardingController,
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        AppCubit.getInstance(context).getBoardings().length,
                    itemBuilder: (context, index) {
                      return buildBoardingView(
                        context: context,
                        boarding:
                            AppCubit.getInstance(context).getBoardings()[index],
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      );
                    },
                    onPageChanged: (int index) {
                      if (index ==
                          AppCubit.getInstance(context).getBoardings().length -
                              1) {
                        setState(() {
                          isLast = true;
                        });
                      } else {
                        setState(() {
                          isLast = false;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: screenHeight / 15),
                SmoothPageIndicator(
                  textDirection: TextDirection.rtl,
                  key: const Key(''),
                  effect: ExpandingDotsEffect(
                    // type: WormType.thin,
                    activeDotColor: kMainLightColor,
                    dotColor: kSecondaryLightColor,
                    dotHeight: (screenHeight + screenWidth) / 85.9,
                    dotWidth: (screenHeight + screenWidth) / 85.9,
                    spacing: (screenHeight + screenWidth) / 80,
                    expansionFactor: 5,
                  ),
                  controller: boardingController,
                  count: AppCubit.getInstance(context).getBoardings().length,
                  onDotClicked: (int dotIndex) {
                    boardingController.animateToPage(
                      dotIndex,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                    );
                  },
                ),
                SizedBox(height: screenHeight / 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedCrossFade(
                      crossFadeState: isLast
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: ElevatedButton(
                        onPressed: submitOnBoarding,
                        child: const Text(
                          "إبدأ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      secondChild: TextButton(
                        child: const Text(
                          "التالي",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          boardingController.nextPage(
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
                        },
                      ),
                      duration: const Duration(milliseconds: 400),
                      firstCurve: Curves.fastOutSlowIn,
                      secondCurve: Curves.fastOutSlowIn,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildBoardingView({
  required BuildContext context,
  required BoardingModel boarding,
  required double screenHeight,
  required double screenWidth,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // const SizedBox(height: 10),
      const Spacer(),
      SizedBox(
        height: screenHeight / 3,
        child: Image(
          // height: ,
          image: AssetImage(boarding.image),
          fit: BoxFit.fitWidth,
        ),
      ),
      SizedBox(height: screenHeight / 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Text(
              boarding.title,
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 26),
            ),
            SizedBox(height: screenHeight / 50),
            Text(
              boarding.body,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    ],
  );
}
