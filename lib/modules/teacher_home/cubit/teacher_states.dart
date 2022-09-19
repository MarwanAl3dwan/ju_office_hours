import 'package:ju_offices/modules/teacher_home/cubit/teacher_cubit.dart';

abstract class TeacherStates {}

class TeacherInitialStates extends TeacherStates {}

class ChangeStatusLoadingState extends TeacherStates {}

class ChangeStatusSuccessState extends TeacherStates {}

class ChangeStatusErrorState extends TeacherStates {
  final String error;

  ChangeStatusErrorState(this.error);
}

class GetStatusLoadingState extends TeacherStates {}

class GetStatusSuccessState extends TeacherStates {}

class GetStatusErrorState extends TeacherStates {
  final String error;

  GetStatusErrorState(this.error);
}

class GetTeacherDataLoadingState extends TeacherStates {}

class GetTeacherDataSuccessState extends TeacherStates {}

class GetTeacherDataErrorState extends TeacherStates {
  final String error;

  GetTeacherDataErrorState(this.error);
}

class SignOutLoadingState extends TeacherStates {}

class SignOutSuccessState extends TeacherStates {}

class SignOutErrorState extends TeacherStates {
  final String error;

  SignOutErrorState(this.error);
}

class ChangeTimeLoadingState extends TeacherStates {}

class ChangeTimeSuccessState extends TeacherStates {}

class ChangeTimeErrorState extends TeacherStates {
  final String error;

  ChangeTimeErrorState(this.error);
}

class ResetTimeLoadingState extends TeacherStates {}

class ResetTimeSuccessState extends TeacherStates {}

class ResetTimeErrorState extends TeacherStates {
  final String error;

  ResetTimeErrorState(this.error);
}

class LoginWithEmailLinkLoadingState extends TeacherStates {}

class LoginWithEmailLinkSuccessState extends TeacherStates {}

class LoginWithEmailLinkErrorState extends TeacherStates {
  final String error;

  LoginWithEmailLinkErrorState(this.error);
}
