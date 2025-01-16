// ignore_for_file: missing_required_param

import 'package:admin_sara/helper/api.dart';
import 'package:admin_sara/models/show_all_products_model.dart';

class ShowAllProductsService {
  Future<ShowAllProductsModel> showAllProducts() async {
    List<dynamic> data = await Api().get(
      url: '$baseUrl/all_products_by_admin',
    );
    return ShowAllProductsModel.fromJson(data);
  }
}
