part of '../custom_nested_scroll_view.dart';

class CustomNestedScrollView extends StatefulWidget {
  const CustomNestedScrollView({
    super.key,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics,
    required this.headerSliverBuilder,
    required this.body,
    this.dragStartBehavior = DragStartBehavior.start,
    this.floatHeaderSlivers = false,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    this.pinnedHeaderSliverHeightBuilder,
    this.onlyOneScrollInBody = false,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  final NestedScrollViewPinnedHeaderSliverHeightBuilder?
      pinnedHeaderSliverHeightBuilder;

  final bool onlyOneScrollInBody;

  final ScrollController? controller;

  final Axis scrollDirection;

  final bool reverse;

  final ScrollPhysics? physics;

  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;

  final Widget body;

  final DragStartBehavior dragStartBehavior;

  final bool floatHeaderSlivers;

  final Clip clipBehavior;

  final String? restorationId;

  final ScrollBehavior? scrollBehavior;

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  static SliverOverlapAbsorberHandle sliverOverlapAbsorberHandleFor(
      BuildContext context) {
    final _InheritedNestedScrollView? target = context
        .dependOnInheritedWidgetOfExactType<_InheritedNestedScrollView>();
    assert(
      target != null,
      'NestedScrollView.sliverOverlapAbsorberHandleFor must be called with a context that contains a NestedScrollView.',
    );
    return target!.state._absorberHandle;
  }

  List<Widget> _buildSlivers(BuildContext context,
      ScrollController innerController, bool bodyIsScrolled) {
    return <Widget>[
      ...headerSliverBuilder(context, bodyIsScrolled),
      _CustomSliverFillRemainingWithScrollable(
        child: PrimaryScrollController(
          automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
          controller: innerController,
          child: body,
        ),
      ),
    ];
  }

  @override
  CustomNestedScrollViewState createState() => CustomNestedScrollViewState();
}

class CustomNestedScrollViewState extends State<CustomNestedScrollView> {
  final SliverOverlapAbsorberHandle _absorberHandle =
      SliverOverlapAbsorberHandle();

  ScrollController get innerController => _coordinator!._innerController;

  ScrollController get outerController => _coordinator!._outerController;

  Iterable<ScrollPosition> get innerPositions => _coordinator!._innerPositions;

  _CustomNestedScrollCoordinator? _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator = _CustomNestedScrollCoordinator(
      this,
      widget.controller,
      _handleHasScrolledBodyChanged,
      widget.floatHeaderSlivers,
      widget.pinnedHeaderSliverHeightBuilder,
      widget.onlyOneScrollInBody,
      widget.scrollDirection,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _coordinator!.setParent(widget.controller);
  }

  @override
  void didUpdateWidget(CustomNestedScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _coordinator!.setParent(widget.controller);
    }
  }

  @override
  void dispose() {
    _coordinator!.dispose();
    _coordinator = null;
    _absorberHandle.dispose();
    super.dispose();
  }

  bool? _lastHasScrolledBody;

  void _handleHasScrolledBodyChanged() {
    if (!mounted) {
      return;
    }
    final bool newHasScrolledBody = _coordinator!.hasScrolledBody;
    if (_lastHasScrolledBody != newHasScrolledBody) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollPhysics scrollPhysics =
        widget.physics?.applyTo(const ClampingScrollPhysics()) ??
            widget.scrollBehavior
                ?.getScrollPhysics(context)
                .applyTo(const ClampingScrollPhysics()) ??
            const ClampingScrollPhysics();

    return _InheritedNestedScrollView(
      state: this,
      child: Builder(
        builder: (BuildContext context) {
          _lastHasScrolledBody = _coordinator!.hasScrolledBody;
          return _NestedScrollViewCustomScrollView(
            dragStartBehavior: widget.dragStartBehavior,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            physics: scrollPhysics,
            scrollBehavior: widget.scrollBehavior ??
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            controller: _coordinator!._outerController,
            slivers: widget._buildSlivers(
              context,
              _coordinator!._innerController,
              _lastHasScrolledBody!,
            ),
            handle: _absorberHandle,
            clipBehavior: widget.clipBehavior,
            restorationId: widget.restorationId,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
          );
        },
      ),
    );
  }
}

class _NestedScrollViewCustomScrollView extends CustomScrollView {
  const _NestedScrollViewCustomScrollView({
    required super.scrollDirection,
    required super.reverse,
    required super.physics,
    required super.scrollBehavior,
    required super.controller,
    required super.slivers,
    required this.handle,
    required super.clipBehavior,
    super.dragStartBehavior,
    super.restorationId,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  final SliverOverlapAbsorberHandle handle;

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    assert(!shrinkWrap);
    return NestedScrollViewViewport(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      handle: handle,
      clipBehavior: clipBehavior,
    );
  }
}

class _InheritedNestedScrollView extends InheritedWidget {
  const _InheritedNestedScrollView({
    required this.state,
    required super.child,
  });

  final CustomNestedScrollViewState state;

  @override
  bool updateShouldNotify(_InheritedNestedScrollView old) => state != old.state;
}

class _NestedScrollMetrics extends FixedScrollMetrics {
  _NestedScrollMetrics({
    required super.minScrollExtent,
    required super.maxScrollExtent,
    required super.pixels,
    required super.viewportDimension,
    required super.axisDirection,
    required super.devicePixelRatio,
    required this.minRange,
    required this.maxRange,
    required this.correctionOffset,
  });

  @override
  _NestedScrollMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? devicePixelRatio,
    double? minRange,
    double? maxRange,
    double? correctionOffset,
  }) {
    return _NestedScrollMetrics(
      minScrollExtent: minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      minRange: minRange ?? this.minRange,
      maxRange: maxRange ?? this.maxRange,
      correctionOffset: correctionOffset ?? this.correctionOffset,
    );
  }

  final double minRange;

  final double maxRange;

  final double correctionOffset;
}

typedef _NestedScrollActivityGetter = ScrollActivity Function(
    _NestedScrollPosition position);

class _NestedScrollCoordinator
    implements ScrollActivityDelegate, ScrollHoldController {
  _NestedScrollCoordinator(
    this._state,
    this._parent,
    this._onHasScrolledBodyChanged,
    this._floatHeaderSlivers,
  ) {
    final double initialScrollOffset = _parent?.initialScrollOffset ?? 0.0;
    _outerController = _NestedScrollController(
      this,
      initialScrollOffset: initialScrollOffset,
      debugLabel: 'outer',
    );
    _innerController = _NestedScrollController(
      this,
      debugLabel: 'inner',
    );
  }

  final CustomNestedScrollViewState _state;
  ScrollController? _parent;
  final VoidCallback _onHasScrolledBodyChanged;
  final bool _floatHeaderSlivers;

  late _NestedScrollController _outerController;
  late _NestedScrollController _innerController;

  _NestedScrollPosition? get _outerPosition {
    if (!_outerController.hasClients) {
      return null;
    }
    return _outerController.nestedPositions.single;
  }

  Iterable<_NestedScrollPosition> get _innerPositions {
    return _innerController.nestedPositions;
  }

  bool get canScrollBody {
    final _NestedScrollPosition? outer = _outerPosition;
    if (outer == null) {
      return true;
    }
    return outer.haveDimensions && outer.extentAfter == 0.0;
  }

  bool get hasScrolledBody {
    for (final _NestedScrollPosition position in _innerPositions) {
      if (!position.hasContentDimensions || !position.hasPixels) {
        continue;
      } else if (position.pixels > position.minScrollExtent) {
        return true;
      }
    }
    return false;
  }

  void updateShadow() {
    _onHasScrolledBodyChanged();
  }

  ScrollDirection get userScrollDirection => _userScrollDirection;
  ScrollDirection _userScrollDirection = ScrollDirection.idle;

  void updateUserScrollDirection(ScrollDirection value) {
    if (userScrollDirection == value) {
      return;
    }
    _userScrollDirection = value;
    _outerPosition!.didUpdateScrollDirection(value);
    for (final _NestedScrollPosition position in _innerPositions) {
      position.didUpdateScrollDirection(value);
    }
  }

  ScrollDragController? _currentDrag;

  void beginActivity(ScrollActivity newOuterActivity,
      _NestedScrollActivityGetter innerActivityGetter) {
    _outerPosition!.beginActivity(newOuterActivity);
    bool scrolling = newOuterActivity.isScrolling;
    for (final _NestedScrollPosition position in _innerPositions) {
      final ScrollActivity newInnerActivity = innerActivityGetter(position);
      position.beginActivity(newInnerActivity);
      scrolling = scrolling && newInnerActivity.isScrolling;
    }
    _currentDrag?.dispose();
    _currentDrag = null;
    if (!scrolling) {
      updateUserScrollDirection(ScrollDirection.idle);
    }
  }

  @override
  AxisDirection get axisDirection => _outerPosition!.axisDirection;

  static IdleScrollActivity _createIdleScrollActivity(
      _NestedScrollPosition position) {
    return IdleScrollActivity(position);
  }

  @override
  void goIdle() {
    beginActivity(
      _createIdleScrollActivity(_outerPosition!),
      _createIdleScrollActivity,
    );
  }

  @override
  void goBallistic(double velocity) {
    beginActivity(
      createOuterBallisticScrollActivity(velocity),
      (_NestedScrollPosition position) {
        return createInnerBallisticScrollActivity(
          position,
          velocity,
        );
      },
    );
  }

  ScrollActivity createOuterBallisticScrollActivity(double velocity) {
    _NestedScrollPosition? innerPosition;
    if (velocity != 0.0) {
      for (final _NestedScrollPosition position in _innerPositions) {
        if (innerPosition != null) {
          if (velocity > 0.0) {
            if (innerPosition.pixels < position.pixels) {
              continue;
            }
          } else {
            assert(velocity < 0.0);
            if (innerPosition.pixels > position.pixels) {
              continue;
            }
          }
        }
        innerPosition = position;
      }
    }

    if (innerPosition == null) {
      return _outerPosition!.createBallisticScrollActivity(
        _outerPosition!.physics.createBallisticSimulation(
          _outerPosition!,
          velocity,
        ),
        mode: _NestedBallisticScrollActivityMode.independent,
      );
    }

    final _NestedScrollMetrics metrics = _getMetrics(innerPosition, velocity);

    return _outerPosition!.createBallisticScrollActivity(
      _outerPosition!.physics.createBallisticSimulation(metrics, velocity),
      mode: _NestedBallisticScrollActivityMode.outer,
      metrics: metrics,
    );
  }

  @protected
  ScrollActivity createInnerBallisticScrollActivity(
      _NestedScrollPosition position, double velocity) {
    return position.createBallisticScrollActivity(
      position.physics.createBallisticSimulation(
        _getMetrics(position, velocity),
        velocity,
      ),
      mode: _NestedBallisticScrollActivityMode.inner,
    );
  }

  _NestedScrollMetrics _getMetrics(
      _NestedScrollPosition innerPosition, double velocity) {
    double pixels, minRange, maxRange, correctionOffset;
    double extra = 0.0;
    if (innerPosition.pixels == innerPosition.minScrollExtent) {
      pixels = clampDouble(
        _outerPosition!.pixels,
        _outerPosition!.minScrollExtent,
        _outerPosition!.maxScrollExtent,
      );
      minRange = _outerPosition!.minScrollExtent;
      maxRange = _outerPosition!.maxScrollExtent;
      assert(minRange <= maxRange);
      correctionOffset = 0.0;
    } else {
      assert(innerPosition.pixels != innerPosition.minScrollExtent);
      if (innerPosition.pixels < innerPosition.minScrollExtent) {
        pixels = innerPosition.pixels -
            innerPosition.minScrollExtent +
            _outerPosition!.minScrollExtent;
      } else {
        assert(innerPosition.pixels > innerPosition.minScrollExtent);
        pixels = innerPosition.pixels -
            innerPosition.minScrollExtent +
            _outerPosition!.maxScrollExtent;
      }
      if ((velocity > 0.0) &&
          (innerPosition.pixels > innerPosition.minScrollExtent)) {
        extra = _outerPosition!.maxScrollExtent - _outerPosition!.pixels;
        assert(extra >= 0.0);
        minRange = pixels;
        maxRange = pixels + extra;
        assert(minRange <= maxRange);
        correctionOffset = _outerPosition!.pixels - pixels;
      } else if ((velocity < 0.0) &&
          (innerPosition.pixels < innerPosition.minScrollExtent)) {
        extra = _outerPosition!.pixels - _outerPosition!.minScrollExtent;
        assert(extra >= 0.0);
        minRange = pixels - extra;
        maxRange = pixels;
        assert(minRange <= maxRange);
        correctionOffset = _outerPosition!.pixels - pixels;
      } else {
        if (velocity > 0.0) {
          extra = _outerPosition!.minScrollExtent - _outerPosition!.pixels;
        } else if (velocity < 0.0) {
          extra = _outerPosition!.pixels -
              (_outerPosition!.maxScrollExtent -
                  _outerPosition!.minScrollExtent);
        }
        assert(extra <= 0.0);
        minRange = _outerPosition!.minScrollExtent;
        maxRange = _outerPosition!.maxScrollExtent + extra;
        assert(minRange <= maxRange);
        correctionOffset = 0.0;
      }
    }
    return _NestedScrollMetrics(
      minScrollExtent: _outerPosition!.minScrollExtent,
      maxScrollExtent: _outerPosition!.maxScrollExtent +
          innerPosition.maxScrollExtent -
          innerPosition.minScrollExtent +
          extra,
      pixels: pixels,
      viewportDimension: _outerPosition!.viewportDimension,
      axisDirection: _outerPosition!.axisDirection,
      minRange: minRange,
      maxRange: maxRange,
      correctionOffset: correctionOffset,
      devicePixelRatio: _outerPosition!.devicePixelRatio,
    );
  }

  double unnestOffset(double value, _NestedScrollPosition source) {
    if (source == _outerPosition) {
      return clampDouble(
        value,
        _outerPosition!.minScrollExtent,
        _outerPosition!.maxScrollExtent,
      );
    }
    if (value < source.minScrollExtent) {
      return value - source.minScrollExtent + _outerPosition!.minScrollExtent;
    }
    return value - source.minScrollExtent + _outerPosition!.maxScrollExtent;
  }

  double nestOffset(double value, _NestedScrollPosition target) {
    if (target == _outerPosition) {
      return clampDouble(
        value,
        _outerPosition!.minScrollExtent,
        _outerPosition!.maxScrollExtent,
      );
    }
    if (value < _outerPosition!.minScrollExtent) {
      return value - _outerPosition!.minScrollExtent + target.minScrollExtent;
    }
    if (value > _outerPosition!.maxScrollExtent) {
      return value - _outerPosition!.maxScrollExtent + target.minScrollExtent;
    }
    return target.minScrollExtent;
  }

  void updateCanDrag() {
    if (!_outerPosition!.haveDimensions) {
      return;
    }
    bool innerCanDrag = false;
    for (final _NestedScrollPosition position in _innerPositions) {
      if (!position.haveDimensions) {
        return;
      }
      innerCanDrag =
          innerCanDrag || position.physics.shouldAcceptUserOffset(position);
    }
    _outerPosition!.updateCanDrag(innerCanDrag);
  }

  Future<void> animateTo(
    double to, {
    required Duration duration,
    required Curve curve,
  }) async {
    final DrivenScrollActivity outerActivity =
        _outerPosition!.createDrivenScrollActivity(
      nestOffset(to, _outerPosition!),
      duration,
      curve,
    );
    final List<Future<void>> resultFutures = <Future<void>>[outerActivity.done];
    beginActivity(
      outerActivity,
      (_NestedScrollPosition position) {
        final DrivenScrollActivity innerActivity =
            position.createDrivenScrollActivity(
          nestOffset(to, position),
          duration,
          curve,
        );
        resultFutures.add(innerActivity.done);
        return innerActivity;
      },
    );
    await Future.wait<void>(resultFutures);
  }

  void jumpTo(double to) {
    goIdle();
    _outerPosition!.localJumpTo(nestOffset(to, _outerPosition!));
    for (final _NestedScrollPosition position in _innerPositions) {
      position.localJumpTo(nestOffset(to, position));
    }
    goBallistic(0.0);
  }

  void pointerScroll(double delta) {
    if (delta == 0.0) {
      goBallistic(0.0);
      return;
    }

    goIdle();
    updateUserScrollDirection(
      delta < 0.0 ? ScrollDirection.forward : ScrollDirection.reverse,
    );

    _outerPosition!.isScrollingNotifier.value = true;
    _outerPosition!.didStartScroll();
    for (final _NestedScrollPosition position in _innerPositions) {
      position.isScrollingNotifier.value = true;
      position.didStartScroll();
    }

    if (_innerPositions.isEmpty) {
      _outerPosition!.applyClampedPointerSignalUpdate(delta);
    } else if (delta > 0.0) {
      double outerDelta = delta;
      for (final _NestedScrollPosition position in _innerPositions) {
        if (position.pixels < 0.0) {
          final double potentialOuterDelta =
              position.applyClampedPointerSignalUpdate(delta);

          outerDelta = math.max(outerDelta, potentialOuterDelta);
        }
      }
      if (outerDelta.notZero) {
        final double innerDelta =
            _outerPosition!.applyClampedPointerSignalUpdate(
          outerDelta,
        );
        if (innerDelta.notZero) {
          for (final _NestedScrollPosition position in _innerPositions) {
            position.applyClampedPointerSignalUpdate(innerDelta);
          }
        }
      }
    } else {
      double innerDelta = delta;

      if (_floatHeaderSlivers) {
        innerDelta = _outerPosition!.applyClampedPointerSignalUpdate(delta);
      }

      if (innerDelta.notZero) {
        double outerDelta = 0.0;
        for (final _NestedScrollPosition position in _innerPositions) {
          final double overscroll =
              position.applyClampedPointerSignalUpdate(innerDelta);
          outerDelta = math.min(outerDelta, overscroll);
        }
        if (outerDelta.notZero) {
          _outerPosition!.applyClampedPointerSignalUpdate(outerDelta);
        }
      }
    }

    _outerPosition!.didEndScroll();
    for (final _NestedScrollPosition position in _innerPositions) {
      position.didEndScroll();
    }
    goBallistic(0.0);
  }

  @override
  double setPixels(double newPixels) {
    assert(false);
    return 0.0;
  }

  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    beginActivity(
      HoldScrollActivity(
        delegate: _outerPosition!,
        onHoldCanceled: holdCancelCallback,
      ),
      (_NestedScrollPosition position) =>
          HoldScrollActivity(delegate: position),
    );
    return this;
  }

  @override
  void cancel() {
    goBallistic(0.0);
  }

  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    final ScrollDragController drag = ScrollDragController(
      delegate: this,
      details: details,
      onDragCanceled: dragCancelCallback,
    );
    beginActivity(
      DragScrollActivity(_outerPosition!, drag),
      (_NestedScrollPosition position) => DragScrollActivity(position, drag),
    );
    assert(_currentDrag == null);
    _currentDrag = drag;
    return drag;
  }

  @override
  void applyUserOffset(double delta) {
    updateUserScrollDirection(
      delta > 0.0 ? ScrollDirection.forward : ScrollDirection.reverse,
    );
    assert(delta != 0.0);
    if (_innerPositions.isEmpty) {
      _outerPosition!.applyFullDragUpdate(delta);
    } else if (delta < 0.0) {
      double outerDelta = delta;
      for (final _NestedScrollPosition position in _innerPositions) {
        if (position.pixels < 0.0) {
          final double potentialOuterDelta =
              position.applyClampedDragUpdate(delta);

          outerDelta = math.max(outerDelta, potentialOuterDelta);
        }
      }
      if (outerDelta.notZero) {
        final double innerDelta = _outerPosition!.applyClampedDragUpdate(
          outerDelta,
        );
        if (innerDelta.notZero) {
          for (final _NestedScrollPosition position in _innerPositions) {
            position.applyFullDragUpdate(innerDelta);
          }
        }
      }
    } else {
      double innerDelta = delta;

      if (_floatHeaderSlivers) {
        innerDelta = _outerPosition!.applyClampedDragUpdate(delta);
      }

      if (innerDelta.notZero) {
        double outerDelta = 0.0;
        final List<double> overscrolls = <double>[];
        final List<_NestedScrollPosition> innerPositions =
            _innerPositions.toList();
        for (final _NestedScrollPosition position in innerPositions) {
          final double overscroll = position.applyClampedDragUpdate(innerDelta);
          outerDelta = math.max(outerDelta, overscroll);
          overscrolls.add(overscroll);
        }
        if (outerDelta.notZero) {
          outerDelta -= _outerPosition!.applyClampedDragUpdate(outerDelta);
        }

        for (int i = 0; i < innerPositions.length; ++i) {
          final double remainingDelta = overscrolls[i] - outerDelta;
          if (remainingDelta > 0.0) {
            innerPositions[i].applyFullDragUpdate(remainingDelta);
          }
        }
      }
    }
  }

  void setParent(ScrollController? value) {
    _parent = value;
    updateParent();
  }

  void updateParent() {
    _outerPosition?.setParent(
      _parent ?? PrimaryScrollController.maybeOf(_state.context),
    );
  }

  @mustCallSuper
  void dispose() {
    _currentDrag?.dispose();
    _currentDrag = null;
    _outerController.dispose();
    _innerController.dispose();
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, '_NestedScrollCoordinator')}(outer=$_outerController; inner=$_innerController)';
}

class _NestedScrollController extends ScrollController {
  _NestedScrollController(
    this.coordinator, {
    super.initialScrollOffset,
    super.debugLabel,
  });

  final _NestedScrollCoordinator coordinator;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _NestedScrollPosition(
      coordinator: coordinator,
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  @override
  void attach(ScrollPosition position) {
    assert(position is _NestedScrollPosition);
    super.attach(position);
    coordinator.updateParent();
    coordinator.updateCanDrag();
    position.addListener(_scheduleUpdateShadow);
    _scheduleUpdateShadow();
  }

  @override
  void detach(ScrollPosition position) {
    assert(position is _NestedScrollPosition);
    (position as _NestedScrollPosition).setParent(null);
    position.removeListener(_scheduleUpdateShadow);
    super.detach(position);
    _scheduleUpdateShadow();
  }

  void _scheduleUpdateShadow() {
    SchedulerBinding.instance.addPostFrameCallback(
      (Duration timeStamp) {
        coordinator.updateShadow();
      },
    );
  }

  Iterable<_NestedScrollPosition> get nestedPositions {
    return Iterable.castFrom<ScrollPosition, _NestedScrollPosition>(positions);
  }
}

class _NestedScrollPosition extends ScrollPosition
    implements ScrollActivityDelegate {
  _NestedScrollPosition({
    required super.physics,
    required super.context,
    double initialPixels = 0.0,
    super.oldPosition,
    super.debugLabel,
    required this.coordinator,
  }) {
    if (!hasPixels) {
      correctPixels(initialPixels);
    }
    if (activity == null) {
      goIdle();
    }
    assert(activity != null);
    saveScrollOffset();
  }

  final _NestedScrollCoordinator coordinator;

  TickerProvider get vsync => context.vsync;

  ScrollController? _parent;

  void setParent(ScrollController? value) {
    _parent?.detach(this);
    _parent = value;
    _parent?.attach(this);
  }

  @override
  AxisDirection get axisDirection => context.axisDirection;

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);
    activity!.updateDelegate(this);
  }

  @override
  void restoreScrollOffset() {
    if (coordinator.canScrollBody) {
      super.restoreScrollOffset();
    }
  }

  double applyClampedDragUpdate(double delta) {
    assert(delta != 0.0);

    final double min =
        delta < 0.0 ? -double.infinity : math.min(minScrollExtent, pixels);

    final double max = delta > 0.0
        ? double.infinity
        : pixels < 0.0
            ? 0.0
            : math.max(maxScrollExtent, pixels);
    final double oldPixels = pixels;
    final double newPixels = clampDouble(pixels - delta, min, max);
    final double clampedDelta = newPixels - pixels;
    if (clampedDelta == 0.0) {
      return delta;
    }
    final double overscroll = physics.applyBoundaryConditions(this, newPixels);
    final double actualNewPixels = newPixels - overscroll;
    final double offset = actualNewPixels - oldPixels;
    if (offset != 0.0) {
      forcePixels(actualNewPixels);
      didUpdateScrollPositionBy(offset);
    }
    return delta + offset;
  }

  double applyFullDragUpdate(double delta) {
    assert(delta != 0.0);
    final double oldPixels = pixels;

    final double newPixels = pixels -
        physics.applyPhysicsToUserOffset(
          this,
          delta,
        );
    if (oldPixels == newPixels) {
      return 0.0;
    }

    final double overscroll = physics.applyBoundaryConditions(this, newPixels);
    final double actualNewPixels = newPixels - overscroll;
    if (actualNewPixels != oldPixels) {
      forcePixels(actualNewPixels);
      didUpdateScrollPositionBy(actualNewPixels - oldPixels);
    }
    if (overscroll != 0.0) {
      didOverscrollBy(overscroll);
      return overscroll;
    }
    return 0.0;
  }

  double applyClampedPointerSignalUpdate(double delta) {
    assert(delta != 0.0);

    final double min =
        delta > 0.0 ? -double.infinity : math.min(minScrollExtent, pixels);

    final double max =
        delta < 0.0 ? double.infinity : math.max(maxScrollExtent, pixels);
    final double newPixels = clampDouble(pixels + delta, min, max);
    final double clampedDelta = newPixels - pixels;
    if (clampedDelta == 0.0) {
      return delta;
    }
    forcePixels(newPixels);
    didUpdateScrollPositionBy(clampedDelta);
    return delta - clampedDelta;
  }

  @override
  ScrollDirection get userScrollDirection => coordinator.userScrollDirection;

  DrivenScrollActivity createDrivenScrollActivity(
      double to, Duration duration, Curve curve) {
    return DrivenScrollActivity(
      this,
      from: pixels,
      to: to,
      duration: duration,
      curve: curve,
      vsync: vsync,
    );
  }

  @override
  double applyUserOffset(double delta) {
    assert(false);
    return 0.0;
  }

  @override
  void goIdle() {
    beginActivity(IdleScrollActivity(this));
    coordinator.updateUserScrollDirection(ScrollDirection.idle);
  }

  @override
  void goBallistic(double velocity) {
    Simulation? simulation;
    if (velocity != 0.0 || outOfRange) {
      simulation = physics.createBallisticSimulation(this, velocity);
    }
    beginActivity(createBallisticScrollActivity(
      simulation,
      mode: _NestedBallisticScrollActivityMode.independent,
    ));
  }

  ScrollActivity createBallisticScrollActivity(
    Simulation? simulation, {
    required _NestedBallisticScrollActivityMode mode,
    _NestedScrollMetrics? metrics,
  }) {
    if (simulation == null) {
      return IdleScrollActivity(this);
    }
    switch (mode) {
      case _NestedBallisticScrollActivityMode.outer:
        assert(metrics != null);
        if (metrics!.minRange == metrics.maxRange) {
          return IdleScrollActivity(this);
        }
        return _NestedOuterBallisticScrollActivity(
          coordinator,
          this,
          metrics,
          simulation,
          context.vsync,
          activity?.shouldIgnorePointer ?? true,
        );
      case _NestedBallisticScrollActivityMode.inner:
        return _ExtendedNestedInnerBallisticScrollActivity(
          coordinator,
          this,
          simulation,
          context.vsync,
          activity?.shouldIgnorePointer ?? true,
        );
      case _NestedBallisticScrollActivityMode.independent:
        return BallisticScrollActivity(this, simulation, context.vsync,
            activity?.shouldIgnorePointer ?? true);
    }
  }

  @override
  Future<void> animateTo(
    double to, {
    required Duration duration,
    required Curve curve,
  }) {
    return coordinator.animateTo(
      coordinator.unnestOffset(to, this),
      duration: duration,
      curve: curve,
    );
  }

  @override
  void jumpTo(double value) {
    return coordinator.jumpTo(coordinator.unnestOffset(value, this));
  }

  @override
  void pointerScroll(double delta) {
    return coordinator.pointerScroll(delta);
  }

  @override
  void jumpToWithoutSettling(double value) {
    assert(false);
  }

  void localJumpTo(double value) {
    if (pixels != value) {
      final double oldPixels = pixels;
      forcePixels(value);
      didStartScroll();
      didUpdateScrollPositionBy(pixels - oldPixels);
      didEndScroll();
    }
  }

  @override
  void applyNewDimensions() {
    super.applyNewDimensions();
    coordinator.updateCanDrag();
  }

  void updateCanDrag(bool innerCanDrag) {
    context.setCanDrag(
      physics.shouldAcceptUserOffset(this) || innerCanDrag,
    );
  }

  @override
  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    return coordinator.hold(holdCancelCallback);
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    return coordinator.drag(details, dragCancelCallback);
  }
}

enum _NestedBallisticScrollActivityMode { outer, inner, independent }

class _NestedInnerBallisticScrollActivity extends BallisticScrollActivity {
  _NestedInnerBallisticScrollActivity(
    this.coordinator,
    _NestedScrollPosition position,
    Simulation simulation,
    TickerProvider vsync,
    bool shouldIgnorePointer,
  ) : super(position, simulation, vsync, shouldIgnorePointer);

  final _NestedScrollCoordinator coordinator;

  @override
  _NestedScrollPosition get delegate => super.delegate as _NestedScrollPosition;

  @override
  void resetActivity() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  bool applyMoveTo(double value) {
    return super.applyMoveTo(coordinator.nestOffset(value, delegate));
  }
}

class _NestedOuterBallisticScrollActivity extends BallisticScrollActivity {
  _NestedOuterBallisticScrollActivity(
    this.coordinator,
    _NestedScrollPosition position,
    this.metrics,
    Simulation simulation,
    TickerProvider vsync,
    bool shouldIgnorePointer,
  )   : assert(metrics.minRange != metrics.maxRange),
        assert(metrics.maxRange > metrics.minRange),
        super(position, simulation, vsync, shouldIgnorePointer);

  final _NestedScrollCoordinator coordinator;
  final _NestedScrollMetrics metrics;

  @override
  _NestedScrollPosition get delegate => super.delegate as _NestedScrollPosition;

  @override
  void resetActivity() {
    delegate.beginActivity(
      coordinator.createOuterBallisticScrollActivity(velocity),
    );
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(
      coordinator.createOuterBallisticScrollActivity(velocity),
    );
  }

  @override
  bool applyMoveTo(double value) {
    bool done = false;
    if (velocity > 0.0) {
      if (value < metrics.minRange) {
        return true;
      }
      if (value > metrics.maxRange) {
        value = metrics.maxRange;
        done = true;
      }
    } else if (velocity < 0.0) {
      if (value > metrics.maxRange) {
        return true;
      }
      if (value < metrics.minRange) {
        value = metrics.minRange;
        done = true;
      }
    } else {
      value = clampDouble(value, metrics.minRange, metrics.maxRange);
      done = true;
    }
    final bool result = super.applyMoveTo(value + metrics.correctionOffset);
    assert(result);
    return !done;
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, '_NestedOuterBallisticScrollActivity')}(${metrics.minRange} .. ${metrics.maxRange}; correcting by ${metrics.correctionOffset})';
  }
}
