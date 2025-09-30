part of 'common_button.dart';

_CommonButtonHookState _useCommonButtonHook({
  required double width,
  required double height,
  required String buttonText,
  required TextStyle? textstyle,
  required DevEssentialLoadingButtonType buttonType,
  required Color buttonColor,
  required Color? textColor,
  required bool fitWidth,
  required EdgeInsetsGeometry padding,
}) =>
    use(_CommonButtonHook(
      width: width,
      height: height,
      text: buttonText,
      textstyle: textstyle,
      buttonType: buttonType,
      buttonColor: buttonColor,
      fitWidth: fitWidth,
      padding: padding,
      textColor: textColor,
    ));

class _CommonButtonHook extends Hook<_CommonButtonHookState> {
  const _CommonButtonHook({
    required this.width,
    required this.height,
    required this.text,
    required this.textstyle,
    required this.buttonType,
    required this.buttonColor,
    required this.fitWidth,
    required this.padding,
    required this.textColor,
  });

  final double width;
  final double height;
  final String text;
  final TextStyle? textstyle;
  final DevEssentialLoadingButtonType buttonType;
  final Color buttonColor;
  final bool fitWidth;
  final EdgeInsetsGeometry padding;
  final Color? textColor;

  @override
  HookState<_CommonButtonHookState, Hook<_CommonButtonHookState>>
      createState() => _CommonButtonHookState();
}

class _CommonButtonHookState
    extends HookState<_CommonButtonHookState, _CommonButtonHook> {
  late double _width;
  late double _height;

  late TextSpan _buttonTextSpan;
  late TextPainter _buttonTextPainter;

  late Color _buttonColor;
  late Color _textColor;

  @override
  void initHook() {
    _setButtonState();
    super.initHook();
  }

  @override
  void didUpdateHook(_CommonButtonHook oldHook) {
    if (oldHook.buttonColor != hook.buttonColor ||
        oldHook.buttonType != hook.buttonType ||
        oldHook.height != hook.height ||
        oldHook.width != hook.width ||
        oldHook.text != hook.text ||
        oldHook.textstyle != hook.textstyle ||
        oldHook.fitWidth != hook.fitWidth ||
        oldHook.padding != hook.padding ||
        oldHook.textColor != hook.textColor) {
      _setButtonState();
    }
    super.didUpdateHook(oldHook);
  }

  void _setButtonState() {
    _width = hook.width;
    _height = hook.height;

    _buttonColor = hook.buttonColor;

    switch (hook.buttonType) {
      case DevEssentialLoadingButtonType.Outline:
        _textColor = hook.textColor ?? _buttonColor;
        break;
      default:
        _textColor = hook.textColor ?? AppColors.white;
    }

    _buttonTextSpan = TextSpan(
      text: hook.text,
      style: hook.textstyle?.copyWith(
        color: _textColor,
      ),
    );

    _buttonTextPainter = TextPainter(
      text: _buttonTextSpan,
      textDirection: TextDirection.ltr,
    );

    _buttonTextPainter.layout(
      minWidth: 0,
      maxWidth: _width,
    );

    _calculateHeight();

    if (!hook.fitWidth) {
      _calculateWidth();
    }

    setState(() {});
  }

  void _calculateHeight() {
    _height = _buttonTextPainter.size.height + hook.padding.vertical;
    _height *= 2;
  }

  void _calculateWidth() {
    _width = _buttonTextPainter.size.width + hook.padding.horizontal;


  }

  @override
  _CommonButtonHookState build(BuildContext context) => this;
}
