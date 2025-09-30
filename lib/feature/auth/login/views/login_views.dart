import 'package:dev_essentials/dev_essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widgets/buttons/common_button.dart';
import '../../../../core/custom_widgets/common_text_field.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/login_cubit.dart';
import '../models/login_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        LoginCubit loginCubit = BlocProvider.of<LoginCubit>(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: loginWithEmailWidgets(context, loginCubit, state),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loginWithEmailWidgets(
    BuildContext context,
    LoginCubit loginCubit,
    LoginState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _loginHeader(
          title: 'Welcome to Hipster Assignment',
          subTitle: 'Log in to Continue',
          context: context,
        ),

        _buildBodyForLogin(context, loginCubit, state),
        const SizedBox(height: 40),
        CommonButton(
          text: 'Log in',
          color: AppColors.primary,
          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          radius: 8.0,
          onPressed: () async {
            await loginCubit.userLogin(context);
          },
          borderColor: AppColors.primary,
          textColor: AppColors.white,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  _loginHeader({
    required String title,
    required String subTitle,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBodyForLogin(
    BuildContext context,
    LoginCubit loginCubit,
    LoginState state,
  ) {
    return DevEssentialFormBuilder(
      form: () => loginCubit.loginForm,
      builder:
          (
            BuildContext context,
            DevEssentialFormGroup formGroup,
            Widget? child,
          ) => Padding(
            padding: const EdgeInsets.only(top: 45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextField<String>(
                  obscureText: false,
                  formControlName: 'email',
                  hintText: "ex. email@domain.com",
                  borderRadius: 8,
                  showHintText: true,
                  labelText: 'Email ID',
                  userborderColor: Colors.grey.shade300,
                  isRequired: true,
                  validationMessages: {
                    DevEssentialFormValidationMessage.required: (control) =>
                        "Email is required",
                    DevEssentialFormValidationMessage.email: (control) =>
                        "Please enter valid email address",
                    'emailNotFound': (control) =>
                        "Email address not found. Please sign up first.",
                  },
                  onEditingComplete: (_) => formGroup.focus('password'),
                  keyboardType: TextInputType.emailAddress,
                  showLabelText: true,
                ),

                const SizedBox(height: 14),
                CommonTextField<String>(
                  obscureText: true,
                  userborderColor: Colors.grey.shade300,
                  formControlName: 'password',
                  hintText: "Enter Password",
                  showHintText: true,
                  isRequired: true,
                  borderRadius: 8,
                  validationMessages: {
                    DevEssentialFormValidationMessage.required: (control) =>
                        "Enter valid password",
                    // Minimum 6 characters required.
                    DevEssentialFormValidationMessage.minLength: (control) =>
                        "Minimum 6 characters required",
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  labelText: 'Password',
                  showLabelText: true,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }
}
