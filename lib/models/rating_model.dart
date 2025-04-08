import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  String id;
  String userId;
  String orderId;
  String shipperId;
  double deliveryRating;
  String deliveryComment;
  DateTime createdAt;

  RatingModel({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.shipperId,
    required this.deliveryRating,
    required this.deliveryComment,
    required this.createdAt,
  });

  factory RatingModel.fromMap(Map<String, dynamic> data, String id) {
    return RatingModel(
      id: id,
      userId: data['userId'] ?? '',
      orderId: data['orderId'] ?? '',
      shipperId: data['shipperId'] ?? '',
      deliveryRating: (data['deliveryRating'] ?? 0).toDouble(),
      deliveryComment: data['deliveryComment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'orderId': orderId,
      'shipperId': shipperId,
      'deliveryRating': deliveryRating,
      'deliveryComment': deliveryComment,
      'createdAt': createdAt,
    };
  }
}
