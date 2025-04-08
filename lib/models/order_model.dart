import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/models/cart_item_model.dart';

class OrderModel {
  String id;
  String customerId;
  String restaurantId;
  String? shipperId;
  List<CartItemModel> items;
  String deliveryAddress;
  double deliveryFee;
  double discount;
  double totalPrice;
  String paymentMethod;
  String note;
  DateTime orderTime;
  DateTime? estimatedDeliveryTime;
  DateTime? actualDeliveryTime;
  String
      status; // 'pending', 'confirmed', 'preparing', 'on_the_way', 'delivered', 'cancelled'
  String? cancelReason;

  // Thông tin về nhà hàng
  String? restaurantName;
  String? restaurantImage;
  String? restaurantAddress;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    this.shipperId,
    required this.items,
    required this.deliveryAddress,
    required this.deliveryFee,
    required this.discount,
    required this.totalPrice,
    required this.paymentMethod,
    required this.note,
    required this.orderTime,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    required this.status,
    this.cancelReason,
    this.restaurantName,
    this.restaurantImage,
    this.restaurantAddress,
  });

  // Tính tổng tiền hàng (chưa bao gồm phí giao hàng, giảm giá)
  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.totalAmount);
  }

  factory OrderModel.fromMap(Map<String, dynamic> data, String id) {
    try {
      // Xử lý danh sách items - sử dụng trực tiếp CartItemModel
      List<CartItemModel> orderItems = [];
      if (data['items'] != null && data['items'] is List) {
        orderItems = (data['items'] as List)
            .where((item) => item is Map<String, dynamic>)
            .map((item) => CartItemModel.fromMap(item, ''))
            .toList();
      }

      // Xử lý các thời gian
      DateTime orderTimeDate;
      if (data['orderTime'] is Timestamp) {
        orderTimeDate = (data['orderTime'] as Timestamp).toDate();
      } else if (data['orderTime'] is String) {
        orderTimeDate = DateTime.parse(data['orderTime']);
      } else {
        orderTimeDate = DateTime.now();
      }

      DateTime? estimatedTime;
      if (data['estimatedDeliveryTime'] != null) {
        if (data['estimatedDeliveryTime'] is Timestamp) {
          estimatedTime = (data['estimatedDeliveryTime'] as Timestamp).toDate();
        } else if (data['estimatedDeliveryTime'] is String) {
          estimatedTime = DateTime.parse(data['estimatedDeliveryTime']);
        }
      }

      DateTime? actualTime;
      if (data['actualDeliveryTime'] != null) {
        if (data['actualDeliveryTime'] is Timestamp) {
          actualTime = (data['actualDeliveryTime'] as Timestamp).toDate();
        } else if (data['actualDeliveryTime'] is String) {
          actualTime = DateTime.parse(data['actualDeliveryTime']);
        }
      }

      // Xử lý các giá trị số
      double deliveryFeeValue = 0.0;
      if (data['deliveryFee'] != null) {
        if (data['deliveryFee'] is double) {
          deliveryFeeValue = data['deliveryFee'];
        } else if (data['deliveryFee'] is int) {
          deliveryFeeValue = (data['deliveryFee'] as int).toDouble();
        } else if (data['deliveryFee'] is String) {
          deliveryFeeValue = double.tryParse(data['deliveryFee']) ?? 0.0;
        }
      }

      double discountValue = 0.0;
      if (data['discount'] != null) {
        if (data['discount'] is double) {
          discountValue = data['discount'];
        } else if (data['discount'] is int) {
          discountValue = (data['discount'] as int).toDouble();
        } else if (data['discount'] is String) {
          discountValue = double.tryParse(data['discount']) ?? 0.0;
        }
      }

      double totalPriceValue = 0.0;
      if (data['totalPrice'] != null) {
        if (data['totalPrice'] is double) {
          totalPriceValue = data['totalPrice'];
        } else if (data['totalPrice'] is int) {
          totalPriceValue = (data['totalPrice'] as int).toDouble();
        } else if (data['totalPrice'] is String) {
          totalPriceValue = double.tryParse(data['totalPrice']) ?? 0.0;
        }
      }

      return OrderModel(
        id: id,
        customerId: data['customerId']?.toString() ?? '',
        restaurantId: data['restaurantId']?.toString() ?? '',
        shipperId: data['shipperId']?.toString(),
        items: orderItems,
        deliveryAddress: data['deliveryAddress']?.toString() ?? '',
        deliveryFee: deliveryFeeValue,
        discount: discountValue,
        totalPrice: totalPriceValue,
        paymentMethod: data['paymentMethod']?.toString() ?? 'cash',
        note: data['note']?.toString() ?? '',
        orderTime: orderTimeDate,
        estimatedDeliveryTime: estimatedTime,
        actualDeliveryTime: actualTime,
        status: data['status']?.toString() ?? 'pending',
        cancelReason: data['cancelReason']?.toString(),
        restaurantName: data['restaurantName']?.toString(),
        restaurantImage: data['restaurantImage']?.toString(),
        restaurantAddress: data['restaurantAddress']?.toString(),
      );
    } catch (e) {
      print('Error parsing OrderModel: $e');
      print('Data: $data');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'customerId': customerId,
      'restaurantId': restaurantId,
      'items': items.map((item) => item.toJson()).toList(),
      'deliveryAddress': deliveryAddress,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'note': note,
      'orderTime': Timestamp.fromDate(orderTime),
      'status': status,
      'subtotal': subtotal,
    };

    // Thêm các trường tùy chọn nếu có
    if (shipperId != null) map['shipperId'] = shipperId;
    if (estimatedDeliveryTime != null) {
      map['estimatedDeliveryTime'] = Timestamp.fromDate(estimatedDeliveryTime!);
    }
    if (actualDeliveryTime != null) {
      map['actualDeliveryTime'] = Timestamp.fromDate(actualDeliveryTime!);
    }
    if (cancelReason != null) map['cancelReason'] = cancelReason;
    if (restaurantName != null) map['restaurantName'] = restaurantName;
    if (restaurantImage != null) map['restaurantImage'] = restaurantImage;
    if (restaurantAddress != null) map['restaurantAddress'] = restaurantAddress;

    return map;
  }

  // Helper method để hiển thị tóm tắt trong danh sách đơn hàng
  Map<String, dynamic> toListItemMap() {
    var firstItem = items.isNotEmpty ? items.first : null;
    String itemsDescription = firstItem != null
        ? "${firstItem.foodName ?? 'Món ăn'} ${items.length > 1 ? 'và ${items.length - 1} món khác' : ''}"
        : "Không có món ăn";

    return {
      'id': id,
      'orderTime': orderTime,
      'status': status,
      'totalPrice': totalPrice,
      'restaurantName': restaurantName ?? '',
      'restaurantImage': restaurantImage,
      'itemsDescription': itemsDescription,
      'itemCount': items.length,
    };
  }

  // Helper method để hiển thị chi tiết đơn hàng
  Map<String, dynamic> toDetailMap() {
    return {
      'id': id,
      'orderTime': orderTime,
      'status': status,
      'restaurantName': restaurantName,
      'restaurantImage': restaurantImage,
      'restaurantAddress': restaurantAddress,
      'deliveryAddress': deliveryAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'itemCount': items.length,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'totalPrice': totalPrice,
      'note': note,
      'paymentMethod': paymentMethod,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'actualDeliveryTime': actualDeliveryTime,
    };
  }

  // Kiểm tra trạng thái đơn hàng
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get isInProgress => !isDelivered && !isCancelled;
}
