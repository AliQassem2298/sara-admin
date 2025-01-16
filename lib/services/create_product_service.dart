// ignore_for_file: missing_required_param

import 'dart:io';

import 'package:admin_sara/helper/api.dart';
import 'package:admin_sara/models/create_product_mpdel.dart';

class CreateProductService {
  Future<CreateProductMpdel> createProduct({
    required String productName,
    required String description,
    required String price,
    required String quantity,
    required File profilePicture,
  }) async {
    Map<String, dynamic> data = await Api().postMultipart(
      url: '$baseUrl/create_products',
      fields: {
        'product_name': productName,
        'description': description,
        'price': price,
        'quantity': quantity,
      },
      imageFile: profilePicture,
    );
    return CreateProductMpdel.fromJson(data);
  }
}
