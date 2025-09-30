part of '../dropdown.dart';

class DevEssentialDropdownButtonStyleData {
  const DevEssentialDropdownButtonStyleData({
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.elevation,
    this.overlayColor,
  });

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final int? elevation;

  final WidgetStateProperty<Color?>? overlayColor;
}

class DevEssentialDropdownIconStyleData {
  const DevEssentialDropdownIconStyleData({
    this.icon = const Icon(Icons.arrow_drop_down),
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24,
    this.openMenuIcon,
  });

  final Widget icon;

  final Color? iconDisabledColor;

  final Color? iconEnabledColor;

  final double iconSize;

  final Widget? openMenuIcon;
}

class DevEssentialDropdownStyleData {
  const DevEssentialDropdownStyleData({
    this.maxHeight,
    this.width,
    this.padding,
    this.scrollPadding,
    this.decoration,
    this.elevation = 8,
    this.direction = DropdownDirection.textDirection,
    this.offset = Offset.zero,
    this.isOverButton = false,
    this.useSafeArea = true,
    this.useRootNavigator = false,
    this.scrollbarTheme,
    this.openInterval = const Interval(0.25, 0.5),
  });

  final double? maxHeight;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? scrollPadding;

  final BoxDecoration? decoration;

  final int elevation;

  final DropdownDirection direction;

  final Offset offset;

  final bool isOverButton;

  final bool useSafeArea;

  final bool useRootNavigator;

  final ScrollbarThemeData? scrollbarTheme;

  final Interval openInterval;

  DevEssentialDropdownStyleData copyWith({
    double? maxHeight,
    double? width,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? scrollPadding,
    BoxDecoration? decoration,
    int? elevation,
    DropdownDirection? direction,
    Offset? offset,
    bool? isOverButton,
    bool? useSafeArea,
    bool? useRootNavigator,
    ScrollbarThemeData? scrollbarTheme,
    Interval? openInterval,
  }) =>
      DevEssentialDropdownStyleData(
        maxHeight: maxHeight ?? this.maxHeight,
        width: width ?? this.width,
        padding: padding ?? this.padding,
        scrollPadding: scrollPadding ?? this.scrollPadding,
        decoration: decoration ?? this.decoration,
        elevation: elevation ?? this.elevation,
        direction: direction ?? this.direction,
        offset: offset ?? this.offset,
        isOverButton: isOverButton ?? this.isOverButton,
        useSafeArea: useSafeArea ?? this.useSafeArea,
        useRootNavigator: useRootNavigator ?? this.useRootNavigator,
        scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
        openInterval: openInterval ?? this.openInterval,
      );
}

class DevEssentialDropdownMenuItemStyleData {
  const DevEssentialDropdownMenuItemStyleData({
    this.height = _kMenuItemHeight,
    this.customHeights,
    this.padding,
    this.overlayColor,
    this.selectedMenuItemBuilder,
    this.menuItemBuilder,
  });

  final double height;

  final List<double>? customHeights;

  final EdgeInsetsGeometry? padding;

  final WidgetStateProperty<Color?>? overlayColor;

  final MenuItemBuilder? selectedMenuItemBuilder;
  final MenuItemBuilder? menuItemBuilder;
}

class DevEssentialDropdownSearchData<T> {
  const DevEssentialDropdownSearchData({
    this.searchController,
    this.searchInnerWidget,
    this.searchInnerWidgetHeight,
    this.searchMatchFn,
  }) : assert(
          (searchInnerWidget == null) == (searchInnerWidgetHeight == null),
          'searchInnerWidgetHeight should not be null when using searchInnerWidget\n'
          'This is necessary to properly determine menu limits and scroll offset',
        );

  final TextEditingController? searchController;

  final Widget? searchInnerWidget;

  final double? searchInnerWidgetHeight;

  final SearchMatchFn<T>? searchMatchFn;
}
