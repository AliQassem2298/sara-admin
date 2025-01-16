
class CreateStoreModel {
  final String message;
  final Store store;
  final String image;
  final String location;

  CreateStoreModel({
     required this.message,
     required this.store,
     required this.image,
     required this.location,
  });

  factory CreateStoreModel.fromJson(Map<String, dynamic> json) {
    return CreateStoreModel(
      message: json['message'] as String,
      store: Store.fromJson(json['store']),
      image: json['image'] as String,
      location: json['location'] as String, 
    );
  }
}

class Store {
  final int id;
  final String storeName;
  final String storeType;

  Store({
     required this.id,
     required this.storeName,
     required this.storeType,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as int,
      storeName: json['store_name'] as String,
      storeType: json['store_type'] as String,
    );
  }
}
