class CartItemModel {
  String id;
  String foodId;
  int quantity;
  double price;
  Map<String, dynamic> options; // điều chỉnh theo ý muốn của khách hàng
  String note;
  // Thêm thông tin chi tiết về món ăn
  String? foodName;
  String? foodImage;
  String? category;
  double? discountPrice;

  CartItemModel({
    required this.id,
    required this.foodId,
    required this.quantity,
    required this.price,
    required this.options,
    required this.note,
    this.foodName,
    this.foodImage,
    this.category,
    this.discountPrice,
  });

  // Tính giá sau giảm giá (nếu có)
  double get finalPrice {
    return discountPrice != null ? discountPrice! : price;
  }

  // Tính tổng tiền cho item này
  double get totalAmount {
    return finalPrice * quantity;
  }

  factory CartItemModel.fromMap(Map<String, dynamic> data, String id) {
    try {
      // Xử lý các giá trị có thể gây lỗi
      double priceValue = 0.0;
      if (data['price'] != null) {
        if (data['price'] is double) {
          priceValue = data['price'];
        } else if (data['price'] is int) {
          priceValue = (data['price'] as int).toDouble();
        } else if (data['price'] is String) {
          priceValue = double.tryParse(data['price']) ?? 0.0;
        }
      }

      // Xử lý options an toàn
      Map<String, dynamic> optionsMap = {};
      if (data['options'] != null && data['options'] is Map) {
        optionsMap = Map<String, dynamic>.from(data['options']);
      }

      // Xử lý giá khuyến mãi
      double? discountValue;
      if (data['discountPrice'] != null) {
        if (data['discountPrice'] is double) {
          discountValue = data['discountPrice'];
        } else if (data['discountPrice'] is int) {
          discountValue = (data['discountPrice'] as int).toDouble();
        } else if (data['discountPrice'] is String) {
          discountValue = double.tryParse(data['discountPrice']);
        }
      }

      return CartItemModel(
        id: id,
        foodId: data['foodId']?.toString() ?? '',
        quantity: data['quantity'] is int ? data['quantity'] : 1,
        price: priceValue,
        options: optionsMap,
        note: data['note']?.toString() ?? '',
        foodName: data['foodName']?.toString(),
        foodImage: data['foodImage']?.toString(),
        category: data['category']?.toString(),
        discountPrice: discountValue,
      );
    } catch (e) {
      // print('Error parsing CartItemModel: $e');
      // print('Data: $data');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'foodId': foodId,
      'quantity': quantity,
      'price': price,
      'options': options,
      'note': note,
    };

    // Thêm các trường tùy chọn nếu có
    if (foodName != null) map['foodName'] = foodName;
    if (foodImage != null) map['foodImage'] = foodImage;
    if (category != null) map['category'] = category;
    if (discountPrice != null) map['discountPrice'] = discountPrice;

    return map;
  }

  // Để tương thích với code cũ sử dụng toJson
  Map<String, dynamic> toJson() => toMap();

  // Helper method để tạo JSON đơn giản cho hiển thị trong danh sách
  Map<String, dynamic> toListItemMap() {
    return {
      'foodName': foodName ?? 'Unknown Item',
      'foodImage': foodImage,
      'quantity': quantity,
      'totalPrice': totalAmount,
    };
  }
}
