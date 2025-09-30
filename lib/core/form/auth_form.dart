import 'package:dev_essentials/dev_essentials.dart';

class AuthForm {
  static final DevEssentialFormGroup loginForm = DevEssentialFormGroup({
    'email': DevEssentialFormControl<String>(
      validators: [
        DevEssentialFormValidators.required,
        DevEssentialFormValidators.email,
      ],
    ),
    'password': DevEssentialFormControl<String>(
      validators: [
        DevEssentialFormValidators.required,
        DevEssentialFormValidators.minLength(6),
      ],
    ),
  });

}
