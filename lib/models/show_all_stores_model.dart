class ShowAllStoreModel {
  final List<Store> stores;

  ShowAllStoreModel({required this.stores});

  factory ShowAllStoreModel.fromJson(List<dynamic> json) {
    List<Store> storeList =
        json.map((storeJson) => Store.fromJson(storeJson)).toList();
    return ShowAllStoreModel(stores: storeList);
  }
}

class Store {
  final int id;
  final String storeName;
  final String imageUrl;

  Store({
    required this.id,
    required this.storeName,
    required this.imageUrl,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as int,
      storeName: json['store_name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }
}
