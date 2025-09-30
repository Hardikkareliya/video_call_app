part of '../../widgets.dart';

class DevEssentialPinCodeFormField<T> extends ReactiveFormField<T, String> {
  DevEssentialPinCodeFormField({
    super.key,
    super.formControlName,
    super.formControl,
    super.validationMessages,
    Map<String, String>? customValidationMessages,
    super.valueAccessor,
    super.showErrors,
    bool obscureText = false,
    List<BoxShadow>? boxShadows,
    required int length,
    String obscuringCharacter = '●',
    Widget? obscuringWidget,
    bool useHapticFeedback = false,
    DevEssentialPinCodeHapticFeedbackTypes hapticFeedbackTypes =
        DevEssentialPinCodeHapticFeedbackTypes.light,
    bool blinkWhenObscuring = false,
    Duration blinkDuration = const Duration(milliseconds: 500),
    ValueChanged<String>? onCompleted,
    ValueChanged<String>? onSubmitted,
    TextStyle? textStyle,
    TextStyle? pastedTextStyle,
    Color? backgroundColor,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
    DevEssentialPinCodeAnimationType animationType =
        DevEssentialPinCodeAnimationType.slide,
    Duration animationDuration = const Duration(milliseconds: 150),
    Curve animationCurve = Curves.easeInOut,
    TextInputType keyboardType = TextInputType.visiblePassword,
    bool autofocus = false,
    FocusNode? focusNode,
    List<TextInputFormatter> inputFormatters = const <TextInputFormatter>[],
    TextEditingController? controller,
    bool enableActiveFill = false,
    bool autoDismissKeyboard = true,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.done,
    StreamController<DevEssentialPinCodeErrorAnimationType>?
        errorAnimationController,
    bool Function(String? text)? beforeTextPaste,
    Function? onTap,
    DevEssentialPinCodeDialogConfig? dialogConfig,
    DevEssentialPinTheme pinTheme = const DevEssentialPinTheme.defaults(),
    Brightness? keyboardAppearance,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
    double errorTextSpace = 16,
    bool enablePinAutofill = true,
    int errorAnimationDuration = 500,
    bool showCursor = true,
    Color? cursorColor,
    double cursorWidth = 2,
    double? cursorHeight,
    AutofillContextAction onAutoFillDisposeAction =
        AutofillContextAction.commit,
    bool useExternalAutoFillGroup = false,
    String? hintCharacter,
    TextStyle? hintStyle,
    bool readOnly = false,
    Gradient? textGradient,
    EdgeInsets scrollPadding = const EdgeInsets.all(20),
    TextDirection errorTextDirection = TextDirection.ltr,
    EdgeInsets errorTextMargin = EdgeInsets.zero,
    bool autoUnfocus = true,
  }) : super(
          builder: (field) {
            final state = field as _DevEssentialPinCodeFormFieldState<T>;

            state._setFocusNode(focusNode);

            return Column(
              spacing: 8,
              children: [
                PinCodeTextField(
                  appContext: field.context,
                  onChanged: field.didChange,
                  focusNode: state.focusNode,
                  controller: state._textController,
                  length: length,
                  enabled: field.control.enabled,
                  obscureText: obscureText,
                  obscuringCharacter: obscuringCharacter,
                  obscuringWidget: obscuringWidget,
                  blinkWhenObscuring: blinkWhenObscuring,
                  blinkDuration: blinkDuration,
                  onCompleted: onCompleted,
                  backgroundColor: backgroundColor,
                  mainAxisAlignment: mainAxisAlignment,
                  animationDuration: animationDuration,
                  animationCurve: animationCurve,
                  animationType: animationType,
                  keyboardType: keyboardType,
                  autoFocus: autofocus,
                  onTap: onTap,
                  inputFormatters: inputFormatters,
                  textStyle: textStyle,
                  useHapticFeedback: useHapticFeedback,
                  hapticFeedbackTypes: hapticFeedbackTypes,
                  pastedTextStyle: pastedTextStyle,
                  enableActiveFill: enableActiveFill,
                  textCapitalization: textCapitalization,
                  textInputAction: textInputAction,
                  autoDismissKeyboard: autoDismissKeyboard,
                  autoDisposeControllers: false,
                  onSubmitted: onSubmitted,
                  errorAnimationController: errorAnimationController,
                  beforeTextPaste: beforeTextPaste,
                  dialogConfig: dialogConfig,
                  pinTheme: pinTheme,
                  keyboardAppearance: keyboardAppearance,
                  errorTextSpace: errorTextSpace,
                  enablePinAutofill: enablePinAutofill,
                  errorAnimationDuration: errorAnimationDuration,
                  boxShadows: boxShadows,
                  showCursor: showCursor,
                  cursorColor: cursorColor,
                  cursorWidth: cursorWidth,
                  cursorHeight: cursorHeight,
                  hintCharacter: hintCharacter,
                  hintStyle: hintStyle,
                  onAutoFillDisposeAction: onAutoFillDisposeAction,
                  useExternalAutoFillGroup: useExternalAutoFillGroup,
                  readOnly: readOnly,
                  textGradient: textGradient,
                  scrollPadding: scrollPadding,
                  errorTextDirection: errorTextDirection,
                  errorTextMargin: errorTextMargin,
                  autoUnfocus: autoUnfocus,
                ),
                if (state.errorText != null &&
                    showErrors != null &&
                    showErrors(field.control) == true)
                  Text(
                    customValidationMessages![state.errorText] ?? '',
                    style: const TextStyle(color: Colors.red),
                    textScaler: Dev.textScaler,
                  )
              ],
            );
          },
        );

  @override
  ReactiveFormFieldState<T, String> createState() =>
      _DevEssentialPinCodeFormFieldState<T>();
}

class _DevEssentialPinCodeFormFieldState<T>
    extends ReactiveFormFieldState<T, String> {
  late TextEditingController _textController;
  FocusNode? _focusNode;
  late FocusController _focusController;

  @override
  FocusNode get focusNode => _focusNode ?? _focusController.focusNode;

  @override
  void initState() {
    super.initState();

    final initialValue = value;
    _textController = TextEditingController(
        text: initialValue == null ? '' : initialValue.toString());
  }

  @override
  void subscribeControl() {
    _registerFocusController(FocusController());
    super.subscribeControl();
  }

  @override
  void unsubscribeControl() {
    _unregisterFocusController();
    super.unsubscribeControl();
  }

  @override
  void onControlValueChanged(dynamic value) {
    final effectiveValue = (value == null) ? '' : value.toString();
    _textController.value = _textController.value.copyWith(
      text: effectiveValue,
      selection: TextSelection.collapsed(offset: effectiveValue.length),
      composing: TextRange.empty,
    );

    super.onControlValueChanged(value);
  }

  @override
  ControlValueAccessor<T, String> selectValueAccessor() {
    if (control is FormControl<int>) {
      return IntValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<double>) {
      return DoubleValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<DateTime>) {
      return DateTimeValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<TimeOfDay>) {
      return TimeOfDayValueAccessor() as ControlValueAccessor<T, String>;
    }

    return super.selectValueAccessor();
  }

  void _registerFocusController(FocusController focusController) {
    _focusController = focusController;
    control.registerFocusController(focusController);
  }

  void _unregisterFocusController() {
    control.unregisterFocusController(_focusController);
    _focusController.dispose();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _setFocusNode(FocusNode? focusNode) {
    if (_focusNode != focusNode) {
      _focusNode = focusNode;
      _unregisterFocusController();
      _registerFocusController(FocusController(focusNode: _focusNode));
    }
  }
}
