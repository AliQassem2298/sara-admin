// ignore_for_file: missing_required_param

import 'package:admin_sara/helper/api.dart';
import 'package:admin_sara/models/add_product_to_store_model.dart';

class AddProductToStoreService {
  Future<AddProductToStoreModel> addProductToStore({
    required int storeId,
    required int productId,
    required int amount,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/stores/$storeId/products?product_id=$productId',
      body: {
        'amount': amount,
      },
    );
    return AddProductToStoreModel.fromJson(data);
  }
}
