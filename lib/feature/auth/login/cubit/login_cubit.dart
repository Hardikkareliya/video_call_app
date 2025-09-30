import 'package:dev_essentials/dev_essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipster_assignment_task/core/utils/StringExt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/form/auth_form.dart';
import '../../../../routes/app_router.dart';
import '../../repo/auth_repo.dart';
import '../models/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState()) {
    loginForm = AuthForm.loginForm;
  }

  final AuthRepo authRepo = AuthRepo();
  late DevEssentialFormGroup loginForm;

  Future<void> userLogin(BuildContext context) async {
    if (loginForm.invalid) {
      loginForm.markAllAsTouched();
      return;
    }
    Map<String, dynamic> loginCredentials = {
      "email": loginForm.control('email').value,
      "password": loginForm.control('password').value,
    };
    // "email": "eve.holt@reqres.in",
    // "password": "cityslicka"
    await authRepo
        .login(loginCredentials)
        .then((value) async {
          if (value.statusCode == 200) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isAuthenticated', true);
            Dev.offNamed(context, Routes.home);
          }
        })
        .onError((error, stackTrace) async {
          String errorMessage = 'Login failed. Please try again.';
          if (error is Map<String, dynamic> && error.containsKey('error')) {
            errorMessage = error['error'];
          }
          errorMessage.capitalizeFirst!.showToast(contentColor: Colors.red);
          return;
        });
  }

  @override
  Future<void> close() async {
    super.close();
    loginForm.reset();
  }
}
