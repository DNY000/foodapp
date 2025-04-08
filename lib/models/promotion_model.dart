import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionModel {
  String id;
  String code;
  String description;
  String discountType; // 'percentage' or 'fixed'
  double discountValue;
  double minOrderAmount;
  DateTime startDate;
  DateTime endDate;
  int usageLimit;
  int currentUsage;
  bool isActive;

  PromotionModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    required this.startDate,
    required this.endDate,
    required this.usageLimit,
    this.currentUsage = 0,
    this.isActive = true,
  });

  factory PromotionModel.fromMap(Map<String, dynamic> data, String id) {
    return PromotionModel(
      id: id,
      code: data['code'] ?? '',
      description: data['description'] ?? '',
      discountType: data['discountType'] ?? 'percentage',
      discountValue: (data['discountValue'] ?? 0).toDouble(),
      minOrderAmount: (data['minOrderAmount'] ?? 0).toDouble(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      usageLimit: data['usageLimit'] ?? 0,
      currentUsage: data['currentUsage'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      'startDate': startDate,
      'endDate': endDate,
      'usageLimit': usageLimit,
      'currentUsage': currentUsage,
      'isActive': isActive,
    };
  }
}
