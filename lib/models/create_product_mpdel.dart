class CreateProductMpdel {
  final String message;
  final Product product;
  final String image;

  CreateProductMpdel({
    required this.message,
    required this.product,
    required this.image,
  });

  factory CreateProductMpdel.fromJson(Map<String, dynamic> json) {
    return CreateProductMpdel(
      message: json['maessage'] as String, // Note the typo in the JSON key
      product: Product.fromJson(json['product']),
      image: json['image'] as String,
    );
  }
}

class Product {
  final int id;
  final String productName;
  final String description;
  final double price; // Changed to double
  final int quantity; // Changed to int

  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      productName: json['product_name'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'] as String), // Parsing string to double
      quantity: int.parse(json['quantity'] as String), // Parsing string to int
    );
  }
}
