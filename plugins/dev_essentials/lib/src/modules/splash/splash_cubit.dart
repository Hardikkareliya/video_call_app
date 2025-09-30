part of '../modules.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required SplashConfig? splashConfig,
    required this.buildContext,
  }) : super(SplashState(
          isSplashCompleted: false,
          splashConfig: splashConfig,
          appVersion: '',
        ));

  final BuildContext buildContext;

  @override
  Future<void> close() async {
    await state.splashConfig?.onSplashCloseCallback?.call(buildContext);
    super.close();
  }

  void initSplash() async {
    Dev.print("Splash Started...");
    await state.splashConfig?.onSplashInitCallback?.call(buildContext);
    PackageInfo packageInfo = await Dev.getPackageInfo();
    SplashState newStateBeforSplashStarted = state.copyWith(
      isSplashCompleted: false,
      appVersion: packageInfo.version,
    );
    if (!isClosed) {
      emit(newStateBeforSplashStarted);
      _loadSplash();
    }
  }

  void _loadSplash() async {
    Dev.print("Splash Loading...");

    if (state.splashConfig?.routeAfterSplash != null) {
      String routeWhenSplashComplete =
          await state.splashConfig!.routeAfterSplash(Dev.context);

      if (routeWhenSplashComplete.isNotEmpty) {
        Duration? splashDuration = state.splashConfig?.splashDuration;
        late SplashState newStateAfterSplashCompleted;
        if (splashDuration != null) {
          Dev.print(
              "Splash loading for ${splashDuration.inSeconds} seconds...");
          await Future.delayed(splashDuration, () {
            newStateAfterSplashCompleted =
                state.copyWith(isSplashCompleted: true);
          });
        } else {
          Dev.print("Splash loading...");
          newStateAfterSplashCompleted =
              state.copyWith(isSplashCompleted: true);
        }

        Dev.print("Splash Completed...");
        if (!isClosed) {
          emit(newStateAfterSplashCompleted);
        }
        Dev.offAllNamed(routeWhenSplashComplete);
      } else {
        Dev.print('Invalid routeName: $routeWhenSplashComplete');
      }
    }
  }
}
