part of '../countdown_timer.dart';

Widget _defaultCountdownBuilder(
  BuildContext context,
  Duration currentRemainingTime,
) {
  return Text('${currentRemainingTime.inSeconds}');
}

typedef CountdownWidgetBuilder = Widget Function(
    BuildContext context, Duration time);

class Countdown extends StatefulWidget {
  ///controller
  final CountdownController countdownController;

  ///custom widget builder
  final CountdownWidgetBuilder builder;

  const Countdown({
    super.key,
    required this.countdownController,
    this.builder = _defaultCountdownBuilder,
  });

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  CountdownWidgetBuilder get builder => widget.builder;

  CountdownController get countdownController => widget.countdownController;

  Duration get time => countdownController.currentDuration;

  @override
  void initState() {
    super.initState();

    countdownController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    countdownController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => builder.call(context, time);
}
