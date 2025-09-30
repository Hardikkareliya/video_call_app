part of '../widgets.dart';

typedef DevEssentialLoadingButtonType = LoadingButtonType;

class DevEssentialLoadingButton extends HookWidget {
  const DevEssentialLoadingButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.color,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.radius = 8,
    this.buttonTextstyle,
    this.loadingWidget,
    this.type = DevEssentialLoadingButtonType.Elevated,
    this.borderSide = BorderSide.none,
    this.padding,
    this.hideBackgroundDuringLoading = true,
    TextStyle? buttonTextStyle,
  }) : child = null;

  const DevEssentialLoadingButton.custom({
    super.key,
    required this.child,
    required this.onPressed,
    this.color,
    this.borderColor,
    this.width,
    this.height,
    this.radius = 8,
    this.loadingWidget,
    this.type = DevEssentialLoadingButtonType.Elevated,
    this.borderSide = BorderSide.none,
    this.padding,
    this.hideBackgroundDuringLoading = true,
  })  : buttonText = null,
        buttonTextstyle = null,
        textColor = null;

  final String? buttonText;
  final Widget? child;
  final Future<void> Function() onPressed;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double radius;
  final TextStyle? buttonTextstyle;
  final Widget? loadingWidget;
  final LoadingButtonType type;
  final BorderSide borderSide;
  final EdgeInsetsGeometry? padding;
  final bool hideBackgroundDuringLoading;

  @override
  Widget build(BuildContext context) {
    final Color defaultButtonColor =
        color ?? Theme.of(context).colorScheme.primary;
    final Color? defaultTextColor = textColor;
    final ValueNotifier<Color> buttonColor =
        useState<Color>(defaultButtonColor);

    useEffect(() {
      buttonColor.value = defaultButtonColor;
      return null;
    }, [defaultButtonColor]);

    return LoadingButton(
      defaultWidget: child ??
          Text(
            buttonText!,
            style: buttonTextstyle?.copyWith(color: defaultTextColor),
          ),
      loadingWidget: loadingWidget ?? LoadingIndicator(color: defaultTextColor),
      color: buttonColor.value,
      borderRadius: radius,
      height: height ?? kMinInteractiveDimension,
      width: width,
      onPressed: () async {
        if (hideBackgroundDuringLoading) {
          buttonColor.value = Colors.transparent;
          await onPressed().whenComplete(
            () => buttonColor.value = defaultButtonColor,
          );
        } else {
          await onPressed();
        }
      },
      type: type,
      borderSide: borderSide.copyWith(
        color: borderColor ?? defaultButtonColor,
      ),
      padding: padding,
      textcolor: textColor,
    );
  }
}
