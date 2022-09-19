// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ju_offices/cubit/app_states.dart';
import 'package:ju_offices/modules/on_boarding/onborading_screen.dart';
import 'package:ju_offices/shared/components/constants.dart';
import 'package:ju_offices/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit getInstance(BuildContext context) => BlocProvider.of(context);

  dynamic language = CacheHelper.getData(key: 'Lang');

  List<BoardingModel> getBoardings() => [
        BoardingModel(
          title: language == "English"
              ? boardingData[0]['englishTitle']!
              : boardingData[0]['arabicTitle']!,
          image: boardingData[0]['image']!,
          body: language == "English"
              ? boardingData[0]['englishBody']!
              : boardingData[0]['arabicBody']!,
        ),
        BoardingModel(
          title: language == "English"
              ? boardingData[1]['englishTitle']!
              : boardingData[1]['arabicTitle']!,
          image: boardingData[1]['image']!,
          body: language == "English"
              ? boardingData[1]['englishBody']!
              : boardingData[1]['arabicBody']!,
        ),
        BoardingModel(
          title: language == "English"
              ? boardingData[2]['englishTitle']!
              : boardingData[2]['arabicTitle']!,
          image: boardingData[2]['image']!,
          body: language == "English"
              ? boardingData[2]['englishBody']!
              : boardingData[2]['arabicBody']!,
        ),
      ];
}
