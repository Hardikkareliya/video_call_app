part of '../../widgets.dart';

class DevEssentialReactiveMultiSelectionDropdownField<T>
    extends ReactiveFormField<List<T>, List<T>> {
  DevEssentialReactiveMultiSelectionDropdownField({
    super.key,
    super.formControlName,
    super.formControl,
    super.validationMessages,
    super.valueAccessor,
    super.showErrors,
    List<T> items = const [],
    FocusNode? focusNode,
    CustomDropdownDecoration? customDropdownDecoration,
    Widget Function(
      BuildContext context,
      T item,
      bool isSelected,
      VoidCallback onItemSelect,
    )? listItemBuilder,
    Widget Function(
      BuildContext context,
      List<T> selectedItems,
      bool enabled,
    )? selectedItemsBuilder,
    String? hintText,
    bool readOnly = false,
  }) : super(
          builder: (ReactiveFormFieldState<List<T>, List<T>> field) {
            final state = field
                as _DevEssentialReactiveMultiSelectionDropdownFieldState<
                    List<T>, List<T>>;

            state._setFocusNode(focusNode);

            return IgnorePointer(
              ignoring: readOnly,
              child: CustomDropdown<T>.multiSelect(
                items: items,
                initialItems: field.value ?? [],
                onListChanged: (List<T> value) => field.didChange(
                  value.isEmpty ? null : value,
                ),
                listItemBuilder: listItemBuilder,
                headerListBuilder: selectedItemsBuilder,
                hintText: hintText,
                decoration: customDropdownDecoration ??
                    CustomDropdownDecoration(
                      closedSuffixIcon: Icon(
                        DevEssentialPlatform.isIOS
                            ? CupertinoIcons.chevron_down
                            : Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                      expandedSuffixIcon: Icon(
                        DevEssentialPlatform.isIOS
                            ? CupertinoIcons.chevron_up
                            : Icons.arrow_drop_up,
                        size: 24.0,
                      ),
                    ),
              ),
            );
          },
        );

  @override
  ReactiveFormFieldState<List<T>, List<T>> createState() =>
      _DevEssentialReactiveMultiSelectionDropdownFieldState<List<T>, List<T>>();
}

class _DevEssentialReactiveMultiSelectionDropdownFieldState<T, V>
    extends ReactiveFormFieldState<T, V> {
  FocusNode? _focusNode;
  late FocusController _focusController;

  @override
  FocusNode get focusNode => _focusNode ?? _focusController.focusNode;

  @override
  void subscribeControl() {
    _registerFocusController(FocusController());
    super.subscribeControl();
  }

  @override
  void unsubscribeControl() {
    _unregisterFocusController();
    super.unsubscribeControl();
  }

  void _registerFocusController(FocusController focusController) {
    _focusController = focusController;
    control.registerFocusController(focusController);
  }

  void _unregisterFocusController() {
    control.unregisterFocusController(_focusController);
    _focusController.dispose();
  }

  void _setFocusNode(FocusNode? focusNode) {
    if (_focusNode != focusNode) {
      _focusNode = focusNode;
      _unregisterFocusController();
      _registerFocusController(FocusController(focusNode: _focusNode));
    }
  }
}



//
//     PopupPropsMultiSelection<V> popupProps =
//         const PopupPropsMultiSelection.menu(),
//     DropdownSearchOnFind<V>? asyncItems,
//     DropdownSearchBuilderMultiSelection<V>? dropdownBuilder,
//     bool showClearButton = false,
//     DropdownSearchFilterFn<V>? filterFn,
//     DropdownSearchItemAsString<V>? itemAsString,
//     DropdownSearchCompareFn<V>? compareFn,
//     ClearButtonProps clearButtonProps = const ClearButtonProps(),
//     DropdownButtonProps dropdownButtonProps = const DropdownButtonProps(),
//     BeforeChangeMultiSelection<V?>? onBeforeChange,
//     TextAlign? dropdownSearchTextAlign,
//     TextAlignVertical? dropdownSearchTextAlignVertical,

//     FormFieldSetter<List<V>>? onSaved,
//     TextStyle? dropdownSearchTextStyle,
//     DropDownDecoratorProps dropdownDecoratorProps =
//         const DropDownDecoratorProps(),
//     BeforePopupOpeningMultiSelection<V>? onBeforePopupOpening,
//   }

//             final effectiveDecoration = (dropdownDecoratorProps
//                         .dropdownSearchDecoration ??
//                     const InputDecoration())
//                 .applyDefaults(Theme.of(field.context).inputDecorationTheme);


//             return DropdownSearch<V>.multiSelection(
//               onChanged: (value) =>
//                   field.didChange(value.isEmpty ? null : value),
//               popupProps: popupProps,
//               selectedItems: field.value ?? [],
//               items: items,
//               asyncItems: asyncItems,
//               dropdownBuilder: dropdownBuilder,
//               enabled: field.control.enabled,
//               filterFn: filterFn,
//               itemAsString: itemAsString,
//               compareFn: compareFn,
//               dropdownDecoratorProps: DropDownDecoratorProps(
//                 dropdownSearchDecoration:
//                     effectiveDecoration.copyWith(errorText: field.errorText),
//                 baseStyle: dropdownDecoratorProps.baseStyle,
//                 textAlign: dropdownDecoratorProps.textAlign,
//                 textAlignVertical: dropdownDecoratorProps.textAlignVertical,
//               ),
//               clearButtonProps: clearButtonProps,
//               dropdownButtonProps: dropdownButtonProps,
//               onBeforeChange: onBeforeChange,
//               onSaved: onSaved,
//               onBeforePopupOpening: onBeforePopupOpening,
//             );