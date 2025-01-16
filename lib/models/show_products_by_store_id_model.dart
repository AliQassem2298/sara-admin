class ShowProductsByStoreIdModel {
  final String storeName;
  final String storeType;
  final String imageUrl;
  final String address;
  final List<Product2> products;

  ShowProductsByStoreIdModel({
    required this.storeName,
    required this.storeType,
    required this.imageUrl,
    required this.address,
    required this.products,
  });

  factory ShowProductsByStoreIdModel.fromJson(Map<String, dynamic> json) {
    List<Product2> productList = (json['products'] as List<dynamic>)
        .map((productJson) => Product2.fromJson(productJson))
        .toList();

    return ShowProductsByStoreIdModel(
      storeName: json['store_name'] as String,
      storeType: json['store_type'] as String,
      imageUrl: json['image_url'] as String,
      address: json['address'] as String,
      products: productList,
    );
  }
}

class Product2 {
  final int id;
  final String productName;
  final String description;
  final dynamic price;
  final int amount;
  final String imageUrl;

  Product2({
    required this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.amount,
    required this.imageUrl,
  });

  factory Product2.fromJson(Map<String, dynamic> json) {
    return Product2(
      id: json['id'] as int,
      productName: json['product_name'] as String,
      description: json['description'] as String,
      price: json['price'],
      amount: json['amount'] as int,
      imageUrl: json['image_url'] as String,
    );
  }
}
