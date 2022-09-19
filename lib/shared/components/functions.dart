import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void navigateTo({required BuildContext context, required String screenRoute}) {
  Navigator.pushNamed(context, screenRoute);
}

void navigateToWithAnimation({
  required BuildContext context,
  required Widget screen,
}) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRightWithFade,
      duration: const Duration(milliseconds: 400),
      opaque: true,
      reverseDuration: const Duration(milliseconds: 400),
      child: screen,
    ),
  );
}

void navigateAndRemoveUntil({
  required BuildContext context,
  required String screenRoute,
}) {
  Navigator.pushNamedAndRemoveUntil(context, screenRoute, (route) => false);
}
