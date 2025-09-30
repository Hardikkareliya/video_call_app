class PaginatedPageData {
  PaginatedPageData({
    this.page,
  });

  int? page;

  factory PaginatedPageData.empty() => PaginatedPageData(page: null);

  factory PaginatedPageData.fromPage(int page) => PaginatedPageData(page: page);

  /// Creates pagination data based on current page and total pages
  static Map<String, PaginatedPageData> createPagination({
    required int currentPage,
    required int totalPages,
  }) {
    return {
      'nextPage': currentPage < totalPages 
          ? PaginatedPageData.fromPage(currentPage + 1)
          : PaginatedPageData.empty(),
      'previousPage': currentPage > 1 
          ? PaginatedPageData.fromPage(currentPage - 1)
          : PaginatedPageData.empty(),
    };
  }

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'page': page,
    };
  }

  /// Create from JSON for caching
  factory PaginatedPageData.fromJson(Map<String, dynamic> json) {
    return PaginatedPageData(
      page: json['page'],
    );
  }

  @override
  String toString() => '''PaginatedPageData(page: $page)''';
}

class PaginatedListResult<T> {
  PaginatedListResult({
    required this.totalDataCount,
    required this.nextPage,
    required this.previousPage,
    required this.data,
  });

  int totalDataCount;
  PaginatedPageData nextPage;
  PaginatedPageData previousPage;
  List<T> data;

  factory PaginatedListResult.empty() => PaginatedListResult<T>(
        totalDataCount: 0,
        nextPage: PaginatedPageData.empty(),
        previousPage: PaginatedPageData.empty(),
        data: List<T>.empty(growable: true),
      );

  @override
  String toString() =>
      '''PaginatedListResult<$T>(totalDataCount: $totalDataCount, nextPage: $nextPage, previousPage: $previousPage)''';
}
