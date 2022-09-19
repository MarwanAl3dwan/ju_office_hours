// ignore_for_file: constant_identifier_names, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import '../../modules/teacher_home/cubit/teacher_cubit.dart';
import '../styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  double height = 34.0,
  required Color backgroundColor,
  Color textColor = kWhiteColor,
  double textSize = 16.0,
  FontWeight textWeight = FontWeight.normal,
  bool isUpperCase = true,
  double radius = 5.0,
  required Function onPress,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      child: RaisedButton(
        textColor: textColor,
        color: backgroundColor,
        onPressed: () => onPress(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: textWeight,
          ),
        ),
      ),
    );

Widget defaultTextButton({
  required Function onPress,
  required String text,
  double fontSize = 14,
  Color color = Colors.blue,
  FontWeight fontWeight = FontWeight.normal,
  bool isUpperCase = false,
}) =>
    TextButton(
        onPressed: () => onPress(),
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ));

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  required Function validate,
  required String label,
  required IconData prefix,
  required Color borderColor,
  double width = double.infinity,
  int? maxLength,
  Function? onSubmit,
  String? onChangeText,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  double borderRadius = 5.0,
  Color fillColor = Colors.transparent,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    Container(
      width: width,
      child: TextFormField(
        controller: controller,
        onTap: () => onTap,
        validator: (value) => validate(value),
        obscureText: isPassword,
        maxLength: maxLength,
        decoration: InputDecoration(
          prefixIcon: Icon(prefix, color: kMainLightColor),
          suffixIcon: GestureDetector(
            onTap: () {
              suffixPressed!();
            },
            child: Icon(suffix, color: kMainLightColor),
          ),
          hintText: label,
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );

Widget customDialog({
  required BuildContext context,
  String? title,
  required String body,
  required TeacherCubit cubit,
}) {
  DateTime selectedTime;
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: kGreyColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title ?? "",
                    style: TextStyle(
                      color: kMainLightColor,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.access_time,
                    color: kMainLightColor,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                body,
                // textDirection: TextDirection.RTL,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: kMainLightColor,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  defaultButton(
                    width: 100,
                    backgroundColor: kMainLightColor,
                    onPress: () {
                      Navigator.pop(context);
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then(
                        (value) {
                          if (value != null) {
                            selectedTime = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              value.hour,
                              value.minute,
                            );
                            int msEpoch = selectedTime.millisecondsSinceEpoch;
                            cubit
                                .changeTime(
                              cubit.teacher!.id,
                              msEpoch,
                            )
                                .then((value) {
                              print("Here");
                              cubit.changeStatus(cubit.teacher!.id);
                              if (!cubit.isOnline) {
                                cubit.changeStatus(cubit.teacher!.id);
                              }
                            });
                            // Timer(
                            //   Duration(
                            //       milliseconds:
                            //           DateTime.fromMillisecondsSinceEpoch(
                            //     msEpoch,
                            //   )
                            //               .difference(
                            //                 DateTime.now(),
                            //               )
                            //               .inMilliseconds),
                            //   () {
                            //     cubit.resetTime(cubit.teacher!.id);
                            //     cubit.resetStatus(cubit.teacher!.id);
                            //   },
                            // );
                          }
                        },
                      );
                    },
                    text: "اختر وقت",
                  ),
                  defaultButton(
                      width: 65,
                      backgroundColor: kMainLightColor,
                      onPress: () {
                        Navigator.pop(context);
                      },
                      text: "إلغاء"),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.yellowAccent;
      break;
  }
  return color;
}

// Widget buildListProduct(BuildContext context, Product product,
//         {bool isOldPrice = true}) =>
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//       child: Container(
//         height: 120,
//         child: Row(
//           children: [
//             Container(
//               width: 120.0,
//               height: 120.0,
//               child: Stack(
//                 alignment: AlignmentDirectional.bottomStart,
//                 children: [
//                   Image(
//                     width: 120.0,
//                     height: 120.0,
//                     image: NetworkImage(product.image!),
//                     // fit: BoxFit.cover,
//                   ),
//                   if (product.discount != 0 && isOldPrice)
//                     Container(
//                       color: Colors.red,
//                       child: const Text(
//                         "DISCOUNT",
//                         style: TextStyle(color: kWhiteColor, fontSize: 13),
//                       ),
//                     )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       product.name!,
//                       overflow: TextOverflow.ellipsis,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyText1!
//                           .copyWith(fontSize: 15),
//                       maxLines: 2,
//                     ),
//                     const Spacer(),
//                     Row(
//                       children: [
//                         Text(
//                           product.price == null
//                               ? "NULL"
//                               : '\$${product.price!.round()}',
//                           style: const TextStyle(
//                             color: kMainLightColor,
//                             fontSize: 15.0,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         if (product.discount != 0 && isOldPrice)
//                           Text(
//                             product.oldPrice == null
//                                 ? "NULL"
//                                 : '\$${product.oldPrice!.round()}',
//                             style: const TextStyle(
//                               fontSize: 13.0,
//                               color: kSecondaryLightColor,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                         const Spacer(),
//                         IconButton(
//                           padding: EdgeInsets.zero,
//                           onPressed: () {
//                             AppCubit.getInstance(context)
//                                 .toggleFavorite(product.id!);
//                           },
//                           icon: Icon(
//                             AppCubit.getInstance(context)
//                                     .isFavorite![product.id!]!
//                                 ? Icons.favorite
//                                 : Icons.favorite_border_outlined,
//                             size: 18,
//                             color: AppCubit.getInstance(context)
//                                     .isFavorite![product.id!]!
//                                 ? kMainLightColor
//                                 : Colors.grey,
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
