import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String id;
  String userId;
  String targetId; // restaurantId or foodId
  String targetType; // 'restaurant' or 'food'
  double rating;
  String comment;
  List<String> images;
  DateTime createdAt;
  int likeCount;
  int reviewCount;
  ReviewModel({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.rating,
    required this.comment,
    required this.images,
    required this.createdAt,
    required this.likeCount,
    required this.reviewCount,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseCreatedAt(dynamic createdAt) {
      if (createdAt is Timestamp) {
        return createdAt.toDate();
      } else if (createdAt is String) {
        return DateTime.parse(createdAt);
      }
      return DateTime.now();
    }

    return ReviewModel(
      id: id,
      userId: map['userId'] ?? '',
      targetId: map['targetId'] ?? '',
      targetType: map['targetType'] ?? '',
      rating: (map['rating'] is double)
          ? map['rating']
          : (map['rating'] is int)
              ? (map['rating'] as int).toDouble()
              : 0.0,
      comment: map['comment'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      createdAt: parseCreatedAt(map['createdAt']),
      likeCount: map['likeCount'] ?? 0,
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'targetId': targetId,
      'targetType': targetType,
      'rating': rating,
      'comment': comment,
      'images': images,
      'createdAt': Timestamp.fromDate(createdAt),
      'likeCount': likeCount,
      'reviewCount': reviewCount,
    };
  }
}
