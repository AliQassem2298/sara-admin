// ignore_for_file: missing_required_param

import 'package:admin_sara/helper/api.dart';
import 'package:admin_sara/models/show_products_by_store_id_model.dart';

class ShowProductsByStoreIdService {
  Future<ShowProductsByStoreIdModel> showProductByStoreId(
      {required int storeId}) async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/show_store_by_admin/$storeId',
    );
    return ShowProductsByStoreIdModel.fromJson(data);
  }
}
