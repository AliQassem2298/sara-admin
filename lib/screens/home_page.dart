// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:admin_sara/screens/add_product_to_store_page.dart';
import 'package:admin_sara/screens/products_by_store_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:admin_sara/helper/api.dart';
import 'package:admin_sara/models/show_all_products_model.dart';
import 'package:admin_sara/models/show_all_stores_model.dart';
import 'package:admin_sara/services/show_all_products_service.dart';
import 'package:admin_sara/services/show_all_stores_service.dart';
import 'package:admin_sara/services/create_product_service.dart';
import 'package:admin_sara/services/create_store_service.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  late Future<ShowAllStoreModel> _storesFuture;
  late Future<ShowAllProductsModel> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _storesFuture = ShowAllStoresService().showAllStores();
      _productsFuture = ShowAllProductsService().showAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              _showAddDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Stores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: FutureBuilder<ShowAllStoreModel>(
                future: _storesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Store> stores = snapshot.data!.stores;
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: stores.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        return CustomStoreCard(store: stores[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load stores.'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: FutureBuilder<ShowAllProductsModel>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> products = snapshot.data!.products;
                    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return CustomProductCard(
                            onTap: () {
                              // Get.to(() => ProductDetailsPageFromAllProducts(
                              //       product: products[index],
                              //     ));
                            },
                            product: products[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Failed to load products.'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Add Product'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddProductDialog(context);
                },
              ),
              ListTile(
                title: const Text('Add Store'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddStoreDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _productNameController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _priceController = TextEditingController();
    final _quantityController = TextEditingController();
    File? _imageFile;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _productNameController,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _imageFile == null
                      ? ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                _imageFile = File(pickedFile.path);
                              });
                            }
                          },
                          child: const Text('Pick Image'),
                        )
                      : Image.file(_imageFile!, height: 100),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _imageFile != null) {
                        final productService = CreateProductService();
                        try {
                          await productService.createProduct(
                            productName: _productNameController.text,
                            description: _descriptionController.text,
                            price: _priceController.text,
                            quantity: _quantityController.text,
                            profilePicture: _imageFile!,
                          );
                          Navigator.pop(context);
                          _loadData(); // Reload data after adding product
                        } catch (e) {
                          Get.snackbar('Sorry', 'Failed to add product: $e');
                        }
                      } else {
                        Get.snackbar('Sorry',
                            'Please fill all fields and pick an image');
                      }
                    },
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddStoreDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _storeNameController = TextEditingController();
    final _storeTypeController = TextEditingController();
    final _addressController = TextEditingController();
    File? _imageFile;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Store'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _storeNameController,
                    decoration: const InputDecoration(labelText: 'Store Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter store name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _storeTypeController,
                    decoration: const InputDecoration(labelText: 'Store Type'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter store type';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _imageFile == null
                      ? ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                _imageFile = File(pickedFile.path);
                              });
                            }
                          },
                          child: const Text('Pick Image'),
                        )
                      : Image.file(_imageFile!, height: 100),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _imageFile != null) {
                        final storeService = CreateStoreService();
                        try {
                          await storeService.createProduct(
                            storeName: _storeNameController.text,
                            storeType: _storeTypeController.text,
                            address: _addressController.text,
                            profilePicture: _imageFile!,
                          );
                          Navigator.pop(context);
                          _loadData(); // Reload data after adding store
                        } catch (e) {
                          Get.snackbar('Sorry', 'Failed to add store: $e');
                        }
                      } else {
                        Get.snackbar('Sorry',
                            'Please fill all fields and pick an image');
                      }
                    },
                    child: const Text('Add Store'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomStoreCard extends StatelessWidget {
  const CustomStoreCard({
    super.key,
    required this.store,
  });
  final Store store;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // سلوك النقرة الواحدة: فتح صفحة إضافة منتج إلى المتجر
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddProductToStorePage(storeId: store.id),
          ),
        );
      },
      onLongPress: () {
        // سلوك النقرة الطويلة: فتح صفحة عرض المنتجات الخاصة بالمتجر
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsByStorePage(storeId: store.id),
          ),
        );
      },
      child: SizedBox(
        width: 160, // زيادة العرض قليلاً
        height: 180, // زيادة الارتفاع قليلاً
        child: Card(
          elevation: 5, // إضافة ظل للبطاقة
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // حواف مدورة
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12), // حواف مدورة للصورة
                child: Image.network(
                  '$baseUrlImage/${store.imageUrl}',
                  height: 100,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                store.storeName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5, // إضافة ظل للبطاقة
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // حواف مدورة
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // حواف مدورة للصورة
              child: Image.network(
                '$baseUrlImage/${product.images.first.imageUrl}',
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.productName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Price: \$${product.price}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
