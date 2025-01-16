import 'dart:io';

import 'package:admin_sara/helper/api.dart';
import 'package:admin_sara/models/create_store_model.dart';

class CreateStoreService {
  Future<CreateStoreModel> createProduct({
    required String storeName,
    required String storeType,
    required String address,
    required File profilePicture,
  }) async {
    Map<String, dynamic> data = await Api().postMultipart(
      url: '$baseUrl/create_store',
      fields: {
        'store_name': storeName,
        'store_type': storeType,
        'address': address,
      },
      imageFile: profilePicture,
    );
    return CreateStoreModel.fromJson(data);
  }
}
