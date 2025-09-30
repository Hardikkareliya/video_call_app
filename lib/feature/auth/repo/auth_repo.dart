import 'package:dev_essentials/dev_essentials.dart';

import '../../../core/utils/endpoints.dart';

class AuthRepo {
  AuthRepo();

  DevEssentialNetworkClient get _client => DevEssentialNetworkClient(
    baseUrl: Endpoints.baseUrl,
    globalHeaders: {'x-api-key': 'reqres-free-v1'},
  );

  Future<DevEssentialNetworkDataRespone> login(
    Map<String, dynamic> credential,
  ) async {
    DevEssentialNetworkDataRespone response = await _client.post(
      url: Endpoints.login,
      data: credential,
    );
    if (response.isSuccess) {
      return Future.value(response);
    } else {
      return Future.error(response.error ?? 'Something Went Wrong');
    }
  }
}
