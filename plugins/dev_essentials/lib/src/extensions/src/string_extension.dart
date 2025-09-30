part of '../extensions.dart';

extension StringExt on String {
  Future<String?> download({
    DownloadProgressCallback? progressCallback,
    String? fileName,
    DevEssentialNetworkToken? token,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    DevEssentialNetworkCancelToken? cancelToken,
    DevEssentialNetworkOptions? options,
  }) async =>
      await DevEssentialUtility.downloadFile(
        this,
        progressCallback: progressCallback,
        fileName: fileName,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );

  String? getMimeType() => lookupMimeType(this);


  bool get isNum => DevEssentialUtility.isNum(this);

  bool get isNumericOnly => DevEssentialUtility.isNumericOnly(this);

  bool get isAlphabetOnly => DevEssentialUtility.isAlphabetOnly(this);

  bool get isBool => DevEssentialUtility.isBool(this);

  bool get isVectorFileName => DevEssentialUtility.isVector(this);

  bool get isImageFileName => DevEssentialUtility.isImage(this);

  bool get isAudioFileName => DevEssentialUtility.isAudio(this);

  bool get isVideoFileName => DevEssentialUtility.isVideo(this);

  bool get isTxtFileName => DevEssentialUtility.isTxt(this);

  bool get isDocumentFileName => DevEssentialUtility.isWord(this);

  bool get isExcelFileName => DevEssentialUtility.isExcel(this);

  bool get isPPTFileName => DevEssentialUtility.isPPT(this);

  bool get isAPKFileName => DevEssentialUtility.isAPK(this);

  bool get isPDFFileName => DevEssentialUtility.isPDF(this);

  bool get isHTMLFileName => DevEssentialUtility.isHTMLFile(this);

  bool get isHTML => DevEssentialUtility.isHTML(this);

  bool get isMarkdown => DevEssentialUtility.isMarkdown(this);

  bool get isURL => DevEssentialUtility.isURL(this);

  bool get isEmail => DevEssentialUtility.isEmail(this);

  bool get isPhoneNumber => DevEssentialUtility.isPhoneNumber(this);

  bool get isDateTime => DevEssentialUtility.isDateTime(this);

  bool get isMD5 => DevEssentialUtility.isMD5(this);

  bool get isSHA1 => DevEssentialUtility.isSHA1(this);

  bool get isSHA256 => DevEssentialUtility.isSHA256(this);

  bool get isBinary => DevEssentialUtility.isBinary(this);

  bool get isIPv4 => DevEssentialUtility.isIPv4(this);

  bool get isIPv6 => DevEssentialUtility.isIPv6(this);

  bool get isHexadecimal => DevEssentialUtility.isHexadecimal(this);

  bool get isPalindrom => DevEssentialUtility.isPalindrom(this);

  bool get isPassport => DevEssentialUtility.isPassport(this);

  bool get isCurrency => DevEssentialUtility.isCurrency(this);

  bool isCaseInsensitiveContains(String b) =>
      DevEssentialUtility.isCaseInsensitiveContains(this, b);

  bool isCaseInsensitiveContainsAny(String b) =>
      DevEssentialUtility.isCaseInsensitiveContainsAny(this, b);

  String? get capitalize => DevEssentialUtility.capitalize(this);

  String? get capitalizeFirst => DevEssentialUtility.capitalizeFirst(this);

  String get removeAllWhitespace =>
      DevEssentialUtility.removeAllWhitespace(this);

  String? get snakeCase => DevEssentialUtility.snakeCase(this);

  String? get camelCase => DevEssentialUtility.camelCase(this);

  String? get paramCase => DevEssentialUtility.paramCase(this);

  String numericOnly({bool firstWordOnly = false}) =>
      DevEssentialUtility.numericOnly(this, firstWordOnly: firstWordOnly);

  Color? get hexToColor => DevEssentialUtility.hexStringToColor(this);
}
