

// ignore_for_file: missing_required_param

import 'package:admin_sara/helper/api.dart';
import 'package:admin_sara/models/show_all_stores_model.dart';

class ShowAllStoresService {
  Future<ShowAllStoreModel> showAllStores() async {
    List<dynamic> data = await Api().get(
      url: '$baseUrl/all_store_by_admin',
    );
    return ShowAllStoreModel.fromJson(data);
  }
}
