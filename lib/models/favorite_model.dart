import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteFoodModel {
  String id;
  String userId;
  String itemId;
  String itemType; // 'food' or 'restaurant'
  DateTime createdAt;

  FavoriteFoodModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.createdAt,
  });

  factory FavoriteFoodModel.fromMap(Map<String, dynamic> data, String id) {
    return FavoriteFoodModel(
      id: id,
      userId: data['userId'] ?? '',
      itemId: data['itemId'] ?? '',
      itemType: data['itemType'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'itemId': itemId,
      'itemType': itemType,
      'createdAt': createdAt,
    };
  }
}
