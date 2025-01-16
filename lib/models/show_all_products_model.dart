class ShowAllProductsModel {
  final List<Product> products;

  ShowAllProductsModel({required this.products});

  factory ShowAllProductsModel.fromJson(List<dynamic> json) {
    return ShowAllProductsModel(
        products:
            json.map((productJson) => Product.fromJson(productJson)).toList());
  }
}

class Product {
  final int id;
  final String productName;
  final dynamic price;
  final String description;
  final int quantity;
  final DateTime? deletedAt;
  final List<ProductImage> images;
  final List<ProductStore> stores;

  Product({
    required this.id,
    required this.productName,
    required this.price,
    required this.description,
    required this.quantity,
    this.deletedAt,
    required this.images,
    required this.stores,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductImage> imageList = (json['image'] as List<dynamic>)
        .map((imageJson) => ProductImage.fromJson(imageJson))
        .toList();
    List<ProductStore> storeList = (json['stores'] as List<dynamic>)
        .map((storeJson) => ProductStore.fromJson(storeJson))
        .toList();

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
      images: imageList,
      stores: storeList,
    );
  }
}

class ProductImage {
  final int id;
  final String imageUrl;

  ProductImage({required this.id, required this.imageUrl});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
    );
  }
}

class ProductStore {
  final int id;
  final Pivot pivot;

  ProductStore({required this.id, required this.pivot});

  factory ProductStore.fromJson(Map<String, dynamic> json) {
    return ProductStore(
      id: json['id'] as int,
      pivot: Pivot.fromJson(json['pivot']),
    );
  }
}

class Pivot {
  final int productId;
  final int storeId;
  final int amount;

  Pivot({
    required this.productId,
    required this.storeId,
    required this.amount,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      productId: json['product_id'] as int,
      storeId: json['store_id'] as int,
      amount: json['amount'] as int,
    );
  }
}
