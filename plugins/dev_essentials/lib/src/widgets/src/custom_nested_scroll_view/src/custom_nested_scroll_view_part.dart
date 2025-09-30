part of '../custom_nested_scroll_view.dart';

typedef NestedScrollViewPinnedHeaderSliverHeightBuilder = double Function();

class _CustomNestedScrollCoordinator extends _NestedScrollCoordinator {
  _CustomNestedScrollCoordinator(
    super.state,
    super.parent,
    super.onHasScrolledBodyChanged,
    super.floatHeaderSlivers,
    this.pinnedHeaderSliverHeightBuilder,
    this.onlyOneScrollInBody,
    this.scrollDirection,
  ) {
    final double initialScrollOffset = _parent?.initialScrollOffset ?? 0.0;
    _outerController = _CustomNestedScrollController(
      this,
      initialScrollOffset: initialScrollOffset,
      debugLabel: 'outer',
    );
    _innerController = _CustomNestedScrollController(
      this,
      initialScrollOffset: 0.0,
      debugLabel: 'inner',
    );
  }

  final NestedScrollViewPinnedHeaderSliverHeightBuilder?
      pinnedHeaderSliverHeightBuilder;

  final bool onlyOneScrollInBody;

  final Axis scrollDirection;

  @override
  _CustomNestedScrollController get _innerController =>
      super._innerController as _CustomNestedScrollController;

  Axis get bodyScrollDirection =>
      scrollDirection == Axis.vertical ? Axis.horizontal : Axis.vertical;

  @override
  Iterable<_CustomNestedScrollPosition> get _innerPositions {
    if (_innerController.nestedPositions.length > 1 && onlyOneScrollInBody) {
      final Iterable<_CustomNestedScrollPosition> actived = _innerController
          .nestedPositions
          .where((_CustomNestedScrollPosition element) => element.isActived);
      if (actived.isEmpty) {
        for (final _CustomNestedScrollPosition scrollPosition
            in _innerController.nestedPositions) {
          try {
            if (!(scrollPosition.context as ScrollableState).mounted) {
              continue;
            }
            final RenderObject? renderObject =
                scrollPosition.context.storageContext.findRenderObject();
            if (renderObject == null || !renderObject.attached) {
              continue;
            }

            final VisibilityInfo? visibilityInfo = CustomVisibilityDetector.of(
                scrollPosition.context.storageContext);
            if (visibilityInfo != null && visibilityInfo.visibleFraction == 1) {
              if (kDebugMode) {
                print('${visibilityInfo.key} is visible');
              }
              return <_CustomNestedScrollPosition>[scrollPosition];
            }

            if (renderObjectIsVisible(renderObject, bodyScrollDirection)) {
              return <_CustomNestedScrollPosition>[scrollPosition];
            }
          } catch (e) {
            continue;
          }
        }
        return _innerController.nestedPositions;
      }

      return actived;
    } else {
      return _innerController.nestedPositions;
    }
  }

  bool childIsVisible(
    RenderObject parent,
    RenderObject renderObject,
  ) {
    bool visible = false;

    parent.visitChildrenForSemantics((RenderObject child) {
      if (renderObject == child) {
        visible = true;
      } else {
        visible = childIsVisible(child, renderObject);
      }
    });
    return visible;
  }

  bool renderObjectIsVisible(RenderObject renderObject, Axis axis) {
    final RenderViewport? parent = findParentRenderViewport(renderObject);
    if (parent != null && parent.axis == axis) {
      for (final RenderSliver childrenInPaint
          in parent.childrenInHitTestOrder) {
        return childIsVisible(childrenInPaint, renderObject) &&
            renderObjectIsVisible(parent, axis);
      }
    }
    return true;
  }

  RenderViewport? findParentRenderViewport(RenderObject? object) {
    if (object == null) {
      return null;
    }
    object = object.parent;
    while (object != null) {
      if (object is _ExtendedRenderSliverFillRemainingWithScrollable) {
        return null;
      }
      if (object is RenderViewport) {
        return object;
      }
      object = object.parent;
    }
    return null;
  }

  @override
  void updateCanDrag({_NestedScrollPosition? position}) {
    double maxInnerExtent = 0.0;

    if (onlyOneScrollInBody &&
        position != null &&
        position.debugLabel == 'inner') {
      if (position.haveDimensions) {
        maxInnerExtent = math.max(
          maxInnerExtent,
          position.maxScrollExtent - position.minScrollExtent,
        );

        position.updateCanDrag(maxInnerExtent >
                (position.viewportDimension - position.maxScrollExtent) ||
            position.minScrollExtent != position.maxScrollExtent);
      }
    }
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
}

class _CustomNestedScrollController extends _NestedScrollController {
  _CustomNestedScrollController(
    _CustomNestedScrollCoordinator super.coordinator, {
    super.initialScrollOffset,
    super.debugLabel,
  });
  @override
  _CustomNestedScrollCoordinator get coordinator =>
      super.coordinator as _CustomNestedScrollCoordinator;

  @override
  Iterable<_CustomNestedScrollPosition> get nestedPositions =>
      kDebugMode ? _debugNestedPositions : _releaseNestedPositions;

  Iterable<_CustomNestedScrollPosition> get _debugNestedPositions {
    return Iterable.castFrom<ScrollPosition, _CustomNestedScrollPosition>(
        positions);
  }

  Iterable<_CustomNestedScrollPosition> get _releaseNestedPositions sync* {
    yield* Iterable.castFrom<ScrollPosition, _CustomNestedScrollPosition>(
        positions);
  }

  @override
  void attach(ScrollPosition position) {
    assert(position is _NestedScrollPosition);
    super.attach(position);
    coordinator.updateParent();
    coordinator.updateCanDrag(position: position as _NestedScrollPosition);
    position.addListener(_scheduleUpdateShadow);
    _scheduleUpdateShadow();
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _CustomNestedScrollPosition(
      coordinator: coordinator,
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}

class _CustomNestedScrollPosition extends _NestedScrollPosition {
  _CustomNestedScrollPosition({
    required super.physics,
    required super.context,
    super.initialPixels,
    super.oldPosition,
    super.debugLabel,
    required _CustomNestedScrollCoordinator super.coordinator,
  });
  @override
  _CustomNestedScrollCoordinator get coordinator =>
      super.coordinator as _CustomNestedScrollCoordinator;

  @override
  void applyNewDimensions() {
    super.applyNewDimensions();
    coordinator.updateCanDrag(position: this);
  }

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    if (debugLabel == 'outer' &&
        coordinator.pinnedHeaderSliverHeightBuilder != null) {
      maxScrollExtent =
          maxScrollExtent - coordinator.pinnedHeaderSliverHeightBuilder!();
      maxScrollExtent = math.max(0.0, maxScrollExtent);
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent);
  }

  bool _isActived = false;
  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    _isActived = true;
    return coordinator.drag(details, () {
      dragCancelCallback();
      _isActived = false;
    });
  }

  bool get isActived {
    return _isActived;
  }
}

class _CustomSliverFillRemainingWithScrollable
    extends SingleChildRenderObjectWidget {
  const _CustomSliverFillRemainingWithScrollable({
    super.child,
  });

  @override
  _ExtendedRenderSliverFillRemainingWithScrollable createRenderObject(
          BuildContext context) =>
      _ExtendedRenderSliverFillRemainingWithScrollable();
}

class _ExtendedRenderSliverFillRemainingWithScrollable
    extends RenderSliverFillRemainingWithScrollable {}

extension DoubleEx on double {
  bool get notZero => abs() > precisionErrorTolerance;
  bool get isZero => abs() < precisionErrorTolerance;
}

class _ExtendedNestedInnerBallisticScrollActivity
    extends _NestedInnerBallisticScrollActivity {
  _ExtendedNestedInnerBallisticScrollActivity(
    super.coordinator,
    super.position,
    super.simulation,
    super.vsync,
    super.shouldIgnorePointer,
  );
  @override
  bool applyMoveTo(double value) {
    return delegate.setPixels(coordinator.nestOffset(value, delegate)).isZero;
  }
}
