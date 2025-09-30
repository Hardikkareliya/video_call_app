import 'package:intl/intl.dart';
import './src/locale.dart'
    if (dart.library.html) './src/locale_html.dart'
    if (dart.library.io) './src/locale_io.dart';

abstract class CurrencyFormatter {
  static const Map<int, String> _letters = {
    1000000000000: 'T',
    1000000000: 'B',
    1000000: 'M',
    1000: 'K'
  };

  static String format(
    amount,
    CurrencyFormat settings, {
    bool compact = false,
    int decimal = 2,
    showThousandSeparator = true,
    enforceDecimals = false,
    showFormattedLetter = true,
  }) {
    amount = double.parse('$amount');
    late String number;
    String letter = '';

    if (compact) {
      for (int i = 0; i < _letters.length; i++) {
        if (amount.abs() >= _letters.keys.elementAt(i)) {
          letter = _letters.values.elementAt(i);
          amount /= _letters.keys.elementAt(i);
          break;
        }
      }
      number = amount.toStringAsPrecision(3);
      number = number.replaceAll('.', settings.decimalSeparator);
    } else {
      number = amount.toStringAsFixed(decimal);
      if (!enforceDecimals &&
          double.parse(number) == double.parse(number).round()) {
        number = double.parse(number).round().toString();
      }
      number = number.replaceAll('.', settings.decimalSeparator);
      if (showThousandSeparator) {
        String oldNum = number.split(settings.decimalSeparator)[0];
        number = number.contains(settings.decimalSeparator)
            ? settings.decimalSeparator +
                number.split(settings.decimalSeparator)[1]
            : '';
        for (int i = 0; i < oldNum.length; i++) {
          number = oldNum[oldNum.length - i - 1] + number;
          if ((i + 1) % 3 == 0 &&
              i < oldNum.length - (oldNum.startsWith('-') ? 2 : 1)) {
            number = settings.thousandSeparator + number;
          }
        }
      }
    }
    switch (settings.symbolSide) {
      case SymbolSide.left:
        return '${settings.symbol}${settings.symbolSeparator}$number${showFormattedLetter ? letter : ""}';
      case SymbolSide.right:
        return '$number${showFormattedLetter ? letter : ""}${settings.symbolSeparator}${settings.symbol}';
      default:
        return '$number${showFormattedLetter ? letter : ""}';
    }
  }

  static num parse(String input, CurrencyFormat settings) {
    String txt = input
        .replaceFirst(settings.thousandSeparator, '')
        .replaceFirst(settings.decimalSeparator, '.')
        .replaceFirst(settings.symbol, '')
        .replaceFirst(settings.symbolSeparator, '')
        .trim();

    int multiplicator = 1;
    for (int mult in _letters.keys) {
      final String letter = _letters[mult]!;
      if (txt.endsWith(letter)) {
        txt = txt.replaceFirst(letter, '');
        multiplicator = mult;
        break;
      }
    }

    return num.parse(txt) * multiplicator;
  }

  static const List<CurrencyFormat> majorsList = [
    CurrencyFormat.usd,
    CurrencyFormat.eur,
    CurrencyFormat.jpy,
    CurrencyFormat.gbp,
    CurrencyFormat.chf,
    CurrencyFormat.cny,
    CurrencyFormat.sek,
    CurrencyFormat.krw,
    CurrencyFormat.inr,
    CurrencyFormat.rub,
    CurrencyFormat.zar,
    CurrencyFormat.tryx,
    CurrencyFormat.pln,
    CurrencyFormat.thb,
    CurrencyFormat.idr,
    CurrencyFormat.huf,
    CurrencyFormat.czk,
    CurrencyFormat.ils,
    CurrencyFormat.php,
    CurrencyFormat.myr,
    CurrencyFormat.ron
  ];
}

class CurrencyFormat {
  final String? code;

  final String symbol;

  final SymbolSide symbolSide;

  final String? _thousandSeparator;

  final String? _decimalSeparator;

  final String symbolSeparator;

  const CurrencyFormat({
    required this.symbol,
    this.code,
    this.symbolSide = SymbolSide.left,
    String? thousandSeparator,
    String? decimalSeparator,
    this.symbolSeparator = ' ',
  })  : _thousandSeparator = thousandSeparator,
        _decimalSeparator = decimalSeparator;

  String get thousandSeparator =>
      _thousandSeparator ?? (symbolSide == SymbolSide.left ? ',' : '.');

  String get decimalSeparator =>
      _decimalSeparator ?? (symbolSide == SymbolSide.left ? '.' : ',');

  CurrencyFormat copyWith({
    String? code,
    String? symbol,
    SymbolSide? symbolSide,
    String? thousandSeparator,
    String? decimalSeparator,
    String? symbolSeparator,
  }) =>
      CurrencyFormat(
        code: code ?? this.code,
        symbol: symbol ?? this.symbol,
        symbolSide: symbolSide ?? this.symbolSide,
        thousandSeparator: thousandSeparator ?? this.thousandSeparator,
        decimalSeparator: decimalSeparator ?? this.decimalSeparator,
        symbolSeparator: symbolSeparator ?? this.symbolSeparator,
      );

  static CurrencyFormat? fromSymbol(
    String symbol, [
    List<CurrencyFormat> currencies = CurrencyFormatter.majorsList,
  ]) {
    if (currencies.any((c) => c.symbol == symbol)) {
      return currencies.firstWhere((c) => c.symbol == symbol);
    }
    return null;
  }

  static CurrencyFormat? fromCode(
    String code, [
    List<CurrencyFormat> currencies = CurrencyFormatter.majorsList,
  ]) {
    if (currencies.any((c) => c.code?.toLowerCase() == code.toLowerCase())) {
      return currencies
          .firstWhere((c) => c.code?.toLowerCase() == code.toLowerCase());
    }
    return null;
  }

  static CurrencyFormat? fromLocale([
    String? locale,
    List<CurrencyFormat> currencies = CurrencyFormatter.majorsList,
  ]) =>
      fromSymbol(
        NumberFormat.simpleCurrency(locale: locale ?? localeName)
            .currencySymbol,
      );

  static CurrencyFormat? get local => fromSymbol(localSymbol);

  static String get localSymbol =>
      NumberFormat.simpleCurrency(locale: localeName).currencySymbol;

  static const CurrencyFormat usd =
      CurrencyFormat(code: 'usd', symbol: '\$', symbolSide: SymbolSide.left);

  static const CurrencyFormat eur =
      CurrencyFormat(code: 'eur', symbol: '€', symbolSide: SymbolSide.right);

  static const CurrencyFormat jpy =
      CurrencyFormat(code: 'jpy', symbol: '¥', symbolSide: SymbolSide.left);

  static const CurrencyFormat gbp =
      CurrencyFormat(code: 'gbp', symbol: '£', symbolSide: SymbolSide.left);

  static const CurrencyFormat chf =
      CurrencyFormat(code: 'chf', symbol: 'fr', symbolSide: SymbolSide.right);

  static const CurrencyFormat cny =
      CurrencyFormat(code: 'cny', symbol: '元', symbolSide: SymbolSide.left);

  static const CurrencyFormat sek =
      CurrencyFormat(code: 'sek', symbol: 'kr', symbolSide: SymbolSide.right);

  static const CurrencyFormat krw =
      CurrencyFormat(code: 'krw', symbol: '₩', symbolSide: SymbolSide.left);

  static const CurrencyFormat inr =
      CurrencyFormat(code: 'inr', symbol: '₹', symbolSide: SymbolSide.left);

  static const CurrencyFormat rub =
      CurrencyFormat(code: 'rub', symbol: '₽', symbolSide: SymbolSide.right);

  static const CurrencyFormat zar =
      CurrencyFormat(code: 'zar', symbol: 'R', symbolSide: SymbolSide.left);

  static const CurrencyFormat tryx =
      CurrencyFormat(code: 'tryx', symbol: '₺', symbolSide: SymbolSide.left);

  static const CurrencyFormat pln =
      CurrencyFormat(code: 'pln', symbol: 'zł', symbolSide: SymbolSide.right);

  static const CurrencyFormat thb =
      CurrencyFormat(code: 'thb', symbol: '฿', symbolSide: SymbolSide.left);

  static const CurrencyFormat idr =
      CurrencyFormat(code: 'idr', symbol: 'Rp', symbolSide: SymbolSide.left);

  static const CurrencyFormat huf =
      CurrencyFormat(code: 'huf', symbol: 'Ft', symbolSide: SymbolSide.right);

  static const CurrencyFormat czk =
      CurrencyFormat(code: 'czk', symbol: 'Kč', symbolSide: SymbolSide.right);

  static const CurrencyFormat ils =
      CurrencyFormat(code: 'ils', symbol: '₪', symbolSide: SymbolSide.left);

  static const CurrencyFormat php =
      CurrencyFormat(code: 'php', symbol: '₱', symbolSide: SymbolSide.left);

  static const CurrencyFormat myr =
      CurrencyFormat(code: 'myr', symbol: 'RM', symbolSide: SymbolSide.left);

  static const CurrencyFormat ron =
      CurrencyFormat(code: 'ron', symbol: 'L', symbolSide: SymbolSide.right);

  @override
  String toString() =>
      'CurrencyFormat<${CurrencyFormatter.format(9999.99, this)}>';

  @override
  operator ==(other) =>
      other is CurrencyFormat &&
      other.symbol == symbol &&
      other.symbolSide == symbolSide &&
      other.thousandSeparator == thousandSeparator &&
      other.decimalSeparator == decimalSeparator &&
      other.symbolSeparator == symbolSeparator;

  @override
  int get hashCode =>
      symbol.hashCode ^
      symbolSide.hashCode ^
      thousandSeparator.hashCode ^
      decimalSeparator.hashCode ^
      symbolSeparator.hashCode;
}

enum SymbolSide { left, right, none }
