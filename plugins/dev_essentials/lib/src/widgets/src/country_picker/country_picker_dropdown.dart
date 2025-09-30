part of 'country_picker.dart';

///Provides a customizable [DropdownButton] for all countries
class CountryPickerDropdown extends StatefulWidget {
  const CountryPickerDropdown({
    super.key,
    required this.onValuePicked,
    this.itemFilter,
    this.sortComparator,
    this.priorityList,
    this.itemBuilder,
    this.initialValue,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.selectedItemBuilder,
    this.isDense = false,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.hint,
    this.disabledHint,
    this.isFirstDefaultIfInitialValueNotProvided = true,
    this.dropdownStyleData = const DevEssentialDropdownStyleData(),
    this.customButton,
    this.items,
    this.isShowCountryName=false,
  });

  final bool isShowCountryName;
  /// Filters the available country list
  final ItemFilter? itemFilter;

  /// [Comparator] to be used in sort of country list
  final Comparator<Country>? sortComparator;

  /// List of countries that are placed on top
  final List<Country>? priorityList;

  ///This function will be called to build the child of DropdownMenuItem
  ///If it is not provided, default one will be used which displays
  ///flag image, isoCode and phoneCode in a row.
  ///Check _buildDefaultMenuItem method for details.
  final ItemBuilder? itemBuilder;

  ///It should be one of the ISO ALPHA-2 Code that is provided
  ///in countryList map of countries.dart file.
  final String? initialValue;

  ///This function will be called whenever a Country item is selected.
  final OnValuePicked onValuePicked;

  /// Boolean property to enabled/disable expanded property of DropdownButton
  final bool isExpanded;

  /// See [itemHeight] of [DropdownButton]
  final double? itemHeight;

  /// See [isDense] of [DropdownButton]
  final bool isDense;

  /// See [underline] of [DropdownButton]
  final Widget? underline;

  /// Selected country widget builder to display. See [selectedItemBuilder] of [DropdownButton]
  final MenuItemBuilder? selectedItemBuilder;

  /// See [icon] of [DropdownButton]
  final Widget? icon;

  /// See [iconDisabledColor] of [DropdownButton]
  final Color? iconDisabledColor;

  /// See [iconEnabledColor] of [DropdownButton]
  final Color? iconEnabledColor;

  /// See [iconSize] of [DropdownButton]
  final double iconSize;

  /// See [hint] of [DropdownButton]
  final Widget? hint;

  /// See [disabledHint] of [DropdownButton]
  final Widget? disabledHint;

  /// Set first item in the country list as selected initially
  /// if initialValue is not provided
  final bool isFirstDefaultIfInitialValueNotProvided;

  final DevEssentialDropdownStyleData dropdownStyleData;

  final CustomButtonBuilder? customButton;

  final List<Country>? items;

  @override
  State<CountryPickerDropdown> createState() => _CountryPickerDropdownState();
}

class _CountryPickerDropdownState extends State<CountryPickerDropdown> {
  late List<Country> _countries;
  late Country _selectedCountry;
  late Country _oldSelectedCountry;

  @override
  void initState() {
    _loadCountries();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CountryPickerDropdown oldWidget) {
    if (!listEquals(oldWidget.items, widget.items)) {
      setState(() => _loadCountries());
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadCountries() {
    _countries = (widget.items ?? countryList)
        .where(widget.itemFilter ?? acceptAllCountries)
        .toList();

    if (widget.sortComparator != null) {
      _countries.sort(widget.sortComparator);
    }

    if (widget.priorityList != null) {
      for (var country in widget.priorityList!) {
        _countries.removeWhere((Country c) => country.isoCode == c.isoCode);
      }
      _countries.insertAll(0, widget.priorityList!);
    }

    if (widget.initialValue != null) {
      try {
        _selectedCountry = _countries.firstWhere(
          (country) => country.isoCode == widget.initialValue!.toUpperCase(),
        );
      } catch (error) {
        throw Exception(
            "The initialValue provided is not a supported iso code!");
      }
    } else {
      if (widget.isFirstDefaultIfInitialValueNotProvided &&
          _countries.isNotEmpty) {
        _selectedCountry = _countries[0];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DevEssentialDropdownMenuItem<Country>> items = _countries
        .map((country) => DevEssentialDropdownMenuItem<Country>(
            value: country,
            child: widget.itemBuilder != null
                ? widget.itemBuilder!(country)
                : _buildDefaultMenuItem(country)))
        .toList();

    return DevEssentialDropdownButton<Country>(
      hint: widget.hint,
      disabledHint: widget.disabledHint,
      iconStyleData: DevEssentialDropdownIconStyleData(
        icon: widget.icon ?? const SizedBox.shrink(),
        iconSize: widget.iconSize,
        iconDisabledColor: widget.iconDisabledColor,
        iconEnabledColor: widget.iconEnabledColor,
      ),
      dropdownStyleData: widget.dropdownStyleData.copyWith(
        width: widget.dropdownStyleData.width ?? 200.0,
      ),
      menuItemStyleData: DevEssentialDropdownMenuItemStyleData(
        selectedMenuItemBuilder: widget.selectedItemBuilder,
      ),
      buttonStyleData: const DevEssentialDropdownButtonStyleData(
        padding: EdgeInsets.zero,
      ),
      underline: widget.underline ?? const SizedBox(),
      isDense: widget.isDense,
      isExpanded: widget.isExpanded,
      customButton: widget.customButton?.call(_selectedCountry),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _oldSelectedCountry = _selectedCountry;
            _selectedCountry = value;
            widget.onValuePicked(_selectedCountry, _oldSelectedCountry);
          });
        }
      },
      items: items,
      value: _selectedCountry,
      selectedItemBuilder: widget.selectedItemBuilder != null
          ? (context) {
              return _countries.map((c) => widget.itemBuilder!(c)).toList();
            }
          : null,
    );
  }

  Widget _buildDefaultMenuItem(Country country) {
      TextSpan textSpan = TextSpan(
      text: "(${country.isoCode}) +${country.phoneCode}",
      style: Theme.of(context).textTheme.bodyMedium,
    );

    if(widget.isShowCountryName){
      textSpan = TextSpan(
        text: country.name,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CountryPickerUtils.getDefaultFlagImage(country),
            ),
          ),
          textSpan
        ],
      ),
      textScaler: const TextScaler.linear(1.0),
    );
  }
}
