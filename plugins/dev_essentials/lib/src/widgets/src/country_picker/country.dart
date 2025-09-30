part of 'country_picker.dart';

class Country {
  final String name;
  final String nameAr;
  final String isoCode;
  final String? iso3Code;
  final String phoneCode;

  Country({
    required this.name,
    required this.nameAr,
    required this.isoCode,
    this.iso3Code,
    required this.phoneCode,
  });

  factory Country.fromMap(Map<String, String> map) => Country(
        name: map['name']!,
        nameAr: map['nameAr']!,
        isoCode: map['isoCode']!,
        iso3Code: map['iso3Code'],
        phoneCode: map['phoneCode']!,
      );

  @override
  String toString() =>
      'name=>$name, nameAr=>$nameAr, isoCode=>$isoCode, iso3Code=>$iso3Code, phoneCode=>$phoneCode';
}
