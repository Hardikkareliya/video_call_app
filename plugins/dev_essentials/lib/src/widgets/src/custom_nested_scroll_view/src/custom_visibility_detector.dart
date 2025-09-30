part of '../custom_nested_scroll_view.dart';

class CustomVisibilityDetector extends StatefulWidget {
  const CustomVisibilityDetector({
    super.key,
    required this.child,
    required this.uniqueKey,
  });

  final Widget child;
  final Key uniqueKey;
  @override
  State<CustomVisibilityDetector> createState() =>
      _CustomVisibilityDetectorState();

  static VisibilityInfo? of(BuildContext context) {
    return context
        .findAncestorStateOfType<_CustomVisibilityDetectorState>()
        ?._visibilityInfo;
  }
}

class _CustomVisibilityDetectorState extends State<CustomVisibilityDetector> {
  VisibilityInfo? _visibilityInfo;
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.uniqueKey,
      child: widget.child,
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
        _visibilityInfo = visibilityInfo;
      },
    );
  }
}
