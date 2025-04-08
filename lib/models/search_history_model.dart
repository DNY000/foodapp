import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoryModel {
  String id;
  String userId;
  String keyword;
  DateTime searchTime;

  SearchHistoryModel({
    required this.id,
    required this.userId,
    required this.keyword,
    required this.searchTime,
  });

  factory SearchHistoryModel.fromMap(Map<String, dynamic> data, String id) {
    return SearchHistoryModel(
      id: id,
      userId: data['userId'] ?? '',
      keyword: data['keyword'] ?? '',
      searchTime: (data['searchTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'keyword': keyword,
      'searchTime': searchTime,
    };
  }
}
