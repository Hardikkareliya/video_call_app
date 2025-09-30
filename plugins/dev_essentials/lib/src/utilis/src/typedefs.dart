part of '../utils.dart';

typedef DevEssentialPageBuilder = Widget Function(
  BuildContext context,
  Object? arguments,
);

typedef OnAppCloseCallback = Future<bool> Function();

typedef SplashUIBuilder = Widget Function(
  Widget? logo,
);

typedef SplashCallback = Future<void> Function(
  BuildContext splashContext,
);

typedef OnSplashCompleteCallback = Future<String> Function(
  BuildContext splashContext,
);

typedef DevEssentialSvgPicture = SvgPicture;
typedef DevEssentialSvgTheme = SvgTheme;

typedef DevEssentialToast = BotToast;

typedef DevEssentialForm = ReactiveForm;
typedef DevEssentialFormArray<T> = FormArray<T>;
typedef DevEssentialFormGroup = FormGroup;
typedef DevEssentialAbstractFormControl<T> = AbstractControl<T>;
typedef DevEssentialFormControl<T> = FormControl<T>;
typedef DevEssentialFormValidator<T> = Validator<T>;
typedef DevEssentialFormValidators = Validators;
typedef DevEssentialFormValidationMessage = ValidationMessage;
typedef DevEssentialFormBuilder = ReactiveFormBuilder;
typedef DevEssentialFormConsumerBuilder = ReactiveFormConsumerBuilder;
typedef DevEssentialFormConsumer = ReactiveFormConsumer;
typedef DevEssentialPinTheme = PinTheme;
typedef DevEssentialPinCodeHapticFeedbackTypes = HapticFeedbackTypes;
typedef DevEssentialPinCodeAnimationType = AnimationType;
typedef DevEssentialPinCodeErrorAnimationType = ErrorAnimationType;
typedef DevEssentialPinCodeFieldShape = PinCodeFieldShape;
typedef DevEssentialPinCodeDialogConfig = DialogConfig;
typedef DevEssentialCheckBoxFormField = ReactiveCheckbox;
typedef DevEssentialCheckboxListTileFormField = ReactiveCheckboxListTile;

typedef FlipAnimationChildBuilder = Widget Function(
  BuildContext context,
  AnimationController flipAnimationController,
);

typedef DownloadProgressCallback = void Function(int count, int total);
