import 'package:admin_sara/helper/api.dart';
import 'package:flutter/material.dart';
import 'package:admin_sara/models/show_products_by_store_id_model.dart';
import 'package:admin_sara/services/show_products_by_store_id_service.dart';

class ProductsByStorePage extends StatefulWidget {
  final int storeId;

  const ProductsByStorePage({super.key, required this.storeId});

  @override
  State<ProductsByStorePage> createState() => _ProductsByStorePageState();
}

class _ProductsByStorePageState extends State<ProductsByStorePage> {
  late Future<ShowProductsByStoreIdModel> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = ShowProductsByStoreIdService()
          .showProductByStoreId(storeId: widget.storeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products by Store'),
      ),
      body: FutureBuilder<ShowProductsByStoreIdModel>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load products: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.products.isEmpty) {
            return const Center(
                child: Text('No products available for this store.'));
          } else {
            final store = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.storeName,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        store.storeType,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Image.network(
                        '$baseUrlImage/${store.imageUrl}',
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${store.address}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: store.products.length,
                    itemBuilder: (context, index) {
                      final product = store.products[index];
                      return ListTile(
                        leading: Image.network(
                          '$baseUrlImage/${product.imageUrl}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.productName),
                        subtitle: Text(
                            'Price: \$${product.price} - Quantity: ${product.amount}'),
                        trailing: Text('ID: ${product.id}'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
