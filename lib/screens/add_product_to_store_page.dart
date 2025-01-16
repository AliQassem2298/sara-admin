// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:admin_sara/helper/api.dart';
import 'package:flutter/material.dart';
import 'package:admin_sara/models/show_all_products_model.dart';
import 'package:admin_sara/services/show_all_products_service.dart';
import 'package:admin_sara/services/add_product_to_store_service.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AddProductToStorePage extends StatefulWidget {
  final int storeId;

  const AddProductToStorePage({super.key, required this.storeId});

  @override
  State<AddProductToStorePage> createState() => _AddProductToStorePageState();
}

class _AddProductToStorePageState extends State<AddProductToStorePage> {
  late Future<ShowAllProductsModel> _productsFuture;
  int? _selectedProductId;
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = ShowAllProductsService().showAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product to Store'),
      ),
      body: FutureBuilder<ShowAllProductsModel>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load products: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.products.isEmpty) {
            return const Center(child: Text('No products available.'));
          } else {
            List<Product> products = snapshot.data!.products;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        leading: Image.network(
                          '$baseUrlImage/${product.images.first.imageUrl}',
                          width: 50,
                          height: 75,
                        ),
                        title: Text(product.productName),
                        subtitle: Text('Price: \$${product.price}'),
                        trailing: Radio<int>(
                          value: product.id,
                          groupValue: _selectedProductId,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedProductId = value;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {}); // تحديث الواجهة عند تغيير الكمية
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _selectedProductId == null ||
                            _quantityController.text.isEmpty
                        ? null
                        : () async {
                            final quantity =
                                int.tryParse(_quantityController.text);
                            if (quantity == null || quantity <= 0) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //       content:
                              //           Text('Please enter a valid quantity.')),
                              // );

                              Get.snackbar(
                                  'Sorry', 'Please enter a valid quantity.');
                              return;
                            }

                            final productService = AddProductToStoreService();
                            try {
                              await productService.addProductToStore(
                                storeId: widget.storeId,
                                productId: _selectedProductId!,
                                amount: quantity,
                              );
                              Navigator.pop(context, true); // Return success
                            } catch (e) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //       content: Text('Failed to add product: $e')),
                              // );
                              print(e);
                              Get.snackbar(
                                  'Sorry', 'Failed to add product: $e');
                            }
                          },
                    child: const Text('Add Product to Store'),
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
