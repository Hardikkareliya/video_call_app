import 'package:dev_essentials/dev_essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/theme/app_theme.dart';

part 'hook.dart';

typedef CommonButtonType = DevEssentialLoadingButtonType;

class CommonButton extends HookWidget {
  const CommonButton({
    super.key,
    required this.text,
    this.textStyle,
    this.width,
    this.height,
    required this.onPressed,
    this.radius = 100,

    this.type = CommonButtonType.Elevated,
    this.color,
    this.textColor,
    this.borderColor,
    this.fitWidth = true,
    this.padding,
  }) : textSpacing = null;

  const CommonButton.loading({
    super.key,
    required this.text,
    this.textStyle,
    this.width,
    this.height,
    required this.onPressed,
    this.radius = 8,
    bool animate = true,
    this.type = CommonButtonType.Elevated,
    this.color,
    this.textColor,
    this.borderColor,
    this.fitWidth = true,
    this.padding,
  }) : textSpacing = null;

  final String text;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final Future<void> Function() onPressed;
  final double radius;

  final CommonButtonType type;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final bool fitWidth;
  final double? textSpacing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry buttonPadding =
        padding ??
        ButtonStyleButton.scaledPadding(
          const EdgeInsets.symmetric(horizontal: 16),
          const EdgeInsets.symmetric(horizontal: 16),
          const EdgeInsets.symmetric(horizontal: 16),
          Dev.deviceTextScaleFactor,
        );

    final _CommonButtonHookState buttonState = _useCommonButtonHook(
      width: width ?? double.maxFinite,
      height: height ?? kMinInteractiveDimension,

      buttonColor: color ?? AppColors.black,
      buttonText: text,
      textColor: textColor,
      textstyle: (textStyle ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
        fontWeight: textStyle?.fontWeight ?? FontWeight.w500,
      ),
      buttonType: type,
      fitWidth: fitWidth,

      padding: buttonPadding,
    );

    return DevEssentialLoadingButton(
      type: type,
      width: buttonState._width,
      height: buttonState._height,
      onPressed: onPressed,
      color: buttonState._buttonColor,
      borderColor: borderColor ?? buttonState._buttonColor,
      borderSide: Divider.createBorderSide(context).copyWith(width: 1.0),
      radius: radius,
      padding: buttonPadding,
      buttonText: buttonState._buttonTextSpan.text,
      buttonTextStyle: buttonState._buttonTextSpan.style?.copyWith(
        color: buttonState._textColor,
      ),
    );
  }
}
