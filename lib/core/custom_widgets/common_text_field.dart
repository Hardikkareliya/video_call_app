import 'package:dev_essentials/dev_essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';

typedef FocusListenerCallback = void Function(FocusNode focusNode);

class CommonTextField<T> extends StatelessWidget {
  CommonTextField({
    super.key,
    required this.formControlName,
    this.onEditingComplete,
    this.onChanged,
    this.validationMessages,
    String? labelText,
    this.hintText,
    this.showLabelText = true,
    this.showHintText = false,
    this.isRequired = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.borderColor = Colors.black,
    this.onTap,
    this.onClearPressed,
    this.onTapOutside,
    this.userborderColor,
    this.isPadding = true,
    this.obscureText = false,
    this.focusListener,
    this.focusNode,
    this.prefixWidget,
    this.borderRadius,
    this.labelTextStyle,
    this.suffixWidget,
    this.fillColor = AppColors.white,

    this.hintTextStyle,
  }) : _labelText = labelText ?? hintText ?? formControlName.capitalize!;

  final String formControlName;
  final void Function(DevEssentialFormControl<T> control)? onEditingComplete;
  final void Function(DevEssentialFormControl<T> control)? onChanged;
  final Map<String, String Function(Object error)>? validationMessages;
  final String _labelText;
  final String? hintText;
  final bool showLabelText;
  final bool obscureText;
  final bool showHintText;
  final bool isRequired;
  final bool isPadding;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Color borderColor;
  final Color? userborderColor;
  final void Function(DevEssentialFormControl<T> control)? onTap;
  final VoidCallback? onClearPressed;
  final TapRegionCallback? onTapOutside;
  final FocusNode? focusNode;
  final FocusListenerCallback? focusListener;
  final Widget? prefixWidget;
  final double? borderRadius;
  final TextStyle? labelTextStyle;
  final Widget? suffixWidget;
  final Color? fillColor;
  final TextStyle? hintTextStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabelText)
          Padding(
            padding: EdgeInsets.only(left: 0, bottom: 8.0),
            child: Text.rich(
              TextSpan(
                text: _labelText,
                children: [
                  if (isRequired)
                    TextSpan(
                      text: '*',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontFamily: 'Poppins',
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              style:
                  labelTextStyle ??
                  Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        DevEssentialReactiveFormTextfield<T>(
          obscureText: obscureText,
          focusNode: focusNode,
          focusListener: focusListener,
          formControlName: formControlName,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
          onTap: onTap,
          onTapOutside: onTapOutside,
          contentPadding: isPadding
              ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0)
              : EdgeInsets.zero,
          fillColor: fillColor,
          filled: true,
          showHintText: showHintText,
          validationMessages: validationMessages,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          hintText: showHintText ? (hintText ?? _labelText) : null,

          hintStyle:
              hintTextStyle ??
              Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 14,
                color: const Color(0xff000000).withOpacity(.35),
                fontWeight: FontWeight.w400,
              ),

          suffix:
              suffixWidget ??
              (onClearPressed != null
                  ? IconButton(
                      onPressed: onClearPressed,
                      icon: const Icon(Icons.close, color: AppColors.black),
                    )
                  : null),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.almostBlack,
            fontSize: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            borderSide: BorderSide(color: userborderColor ?? AppColors.white10),
          ),
        ),
      ],
    );
  }
}
