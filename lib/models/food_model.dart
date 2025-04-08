class FoodModel {
  String id;
  String name;
  String description;
  double price;
  double? discountPrice;
  String category;
  List<String> images;
  String restaurantId;
  int preparationTime; // in minutes
  bool isAvailable;
  double rating;
  List<Map<String, dynamic>> options;
  List<String> ingredients; // Thêm dòng này

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.category,
    required this.images,
    required this.restaurantId,
    required this.preparationTime,
    required this.isAvailable,
    required this.rating,
    required this.options,
    required this.ingredients, // Đúng thứ tự
  });

  factory FoodModel.fromMap(Map<String, dynamic> data) {
    return FoodModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discountPrice: (data['discountPrice'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      restaurantId: data['restaurantId'] ?? '',
      preparationTime: data['preparationTime'] ?? 0,
      isAvailable: data['isAvailable'] ?? false,
      rating: (data['rating'] ?? 0).toDouble(),
      options: List<Map<String, dynamic>>.from(data['options'] ?? []),
      ingredients: List<String>.from(data['ingredients'] ?? []), // Fix lỗi
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Cần lưu cả id để lấy lại dễ hơn
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'category': category,
      'images': images,
      'restaurantId': restaurantId,
      'preparationTime': preparationTime,
      'isAvailable': isAvailable,
      'rating': rating,
      'options': options,
      'ingredients': ingredients, // Cần lưu vào Firestore
    };
  }
}
