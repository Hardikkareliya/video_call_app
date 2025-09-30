import 'package:dev_essentials/dev_essentials.dart';

import '../utils/endpoints.dart';
import '../utils/paginated_response.dart';
import '../../feature/users/models/user_model.dart';

class UserRepo {
  DevEssentialNetworkClient get _client => DevEssentialNetworkClient(
    baseUrl: Endpoints.baseUrl,
    globalHeaders: {'x-api-key': 'reqres-free-v1'},
  );

  Future<PaginatedListResult<UserModel>> getUsers({required int page}) async {
    final Map<String, dynamic> queryParams = {'page': page};

    final response = await _client.get(
      url: Endpoints.users,
      queryParameters: queryParams,
    );

    final PaginatedListResult<UserModel> usersList =
        PaginatedListResult<UserModel>.empty();

    print('Users List-->${response}');

    if (response.isSuccess) {
      Map<String, dynamic> data = (response.data as Map<String, dynamic>);
      usersList.totalDataCount = data['total'] ?? 0;

      // Handle pagination based on the actual API response structure
      int currentPage = data['page'] ?? 1;
      int totalPages = data['total_pages'] ?? 1;

      // Create pagination data using the centralized logic
      final paginationData = PaginatedPageData.createPagination(
        currentPage: currentPage,
        totalPages: totalPages,
      );

      usersList.nextPage = paginationData['nextPage'] == null
          ? PaginatedPageData.empty()
          : paginationData['nextPage']!;
      usersList.previousPage = paginationData['previousPage'] == null
          ? PaginatedPageData.empty()
          : paginationData['previousPage']!;
      usersList.totalDataCount = data['total'];

      usersList.data = (data['data'] as List)
          .map((jsonItem) => UserModel.fromJson(jsonItem))
          .toList();
    }
    return usersList;
  }
}
