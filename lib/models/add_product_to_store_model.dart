class AddProductToStoreModel {
  final List<Product> products;

  AddProductToStoreModel({required this.products});

  factory AddProductToStoreModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> productData =
        json['product'] ?? []; // Handle null or missing 'product' key
    return AddProductToStoreModel(
        products: productData.map((e) => Product.fromJson(e)).toList());
  }
}

class Product {
  final int id;
  final String productName;
  final dynamic price;
  final String description;
  final int quantity;
  final DateTime? deletedAt;
  final Pivot pivot;

  Product({
    required this.id,
    required this.productName,
    required this.price,
    required this.description,
    required this.quantity,
    this.deletedAt,
    required this.pivot,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    DateTime? deletedAt;
    if (json['deleted_at'] != null) {
      deletedAt = DateTime.parse(json['deleted_at']);
    }
    return Product(
      id: json['id'] as int,
      productName: json['product_name'] as String,
      price: json['price'],
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      deletedAt: deletedAt,
      pivot: Pivot.fromJson(json['pivot']),
    );
  }
}

class Pivot {
  final int storeId;
  final int productId;
  final int amount;

  Pivot({
    required this.storeId,
    required this.productId,
    required this.amount,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      storeId: json['store_id'] as int,
      productId: json['product_id'] as int,
      amount: json['amount'] as int,
    );
  }
}
