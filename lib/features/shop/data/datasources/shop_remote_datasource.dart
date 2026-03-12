import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/shop_model.dart';

abstract class ShopRemoteDataSource {
  Future<List<ShopModel>> getShops({
    String? category,
    int limit = 20,
    int offset = 0,
  });
  Future<ShopModel> getShopDetail(String id);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  ShopRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<List<ShopModel>> getShops({
    String? category,
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await _apiClient.get(
      ApiEndpoints.shopsList,
      queryParams: {
        if (category != null) 'category': category,
        'limit': limit,
        'offset': offset,
      },
    );
    final shops = data is List
        ? data as List<dynamic>
        : (data['shops'] as List<dynamic>? ?? <dynamic>[]);
    return shops
        .map((json) => ShopModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ShopModel> getShopDetail(String id) async {
    final path =
        ApiEndpoints.replacePathParam(ApiEndpoints.shopsDetail, 'shop_id', id);
    final data = await _apiClient.get(path);
    return ShopModel.fromJson(data);
  }
}
