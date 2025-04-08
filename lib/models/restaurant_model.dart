import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final Map<String, dynamic> location;
  final String openTime;
  final String closeTime;
  final double rating;
  final List<String> categories;
  final List<String> images;
  final String status;
  final double minOrderAmount;
  final Timestamp registrationDate;
  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.location,
    required this.openTime,
    required this.closeTime,
    required this.rating,
    required this.categories,
    required this.images,
    required this.status,
    required this.minOrderAmount,
    required this.registrationDate,
  });

  DateTime get registrationDateTime => registrationDate.toDate();

  String get formattedRegistrationDate {
    final date = registrationDate.toDate();
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map, String id) {
    List<String> parseCategories(dynamic categories) {
      if (categories == null) return [];
      if (categories is List) {
        return List<String>.from(categories.map((cat) => cat.toString()));
      }
      return [];
    }

    List<String> parseImages(dynamic images) {
      if (images == null) return [];
      if (images is List) {
        return List<String>.from(images.map((img) => img.toString()));
      }
      return [];
    }

    // Timestamp? openTimeTimestamp;
    // if (map['openTimeTimestamp'] is Timestamp) {
    //   openTimeTimestamp = map['openTimeTimestamp'];
    // }

    // Timestamp? closeTimeTimestamp;
    // if (map['closeTimeTimestamp'] is Timestamp) {
    //   closeTimeTimestamp = map['closeTimeTimestamp'];
    // }

    Timestamp registrationDate;
    if (map['registrationDate'] is Timestamp) {
      registrationDate = map['registrationDate'];
    } else {
      registrationDate = Timestamp.now();
    }

    return RestaurantModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      address: map['address'] ?? '',
      location: map['location'] ?? {'latitude': 0.0, 'longitude': 0.0},
      openTime: map['openTime'] ?? '08:00',
      closeTime: map['closeTime'] ?? '22:00',
      rating: (map['rating'] ?? 0.0).toDouble(),
      categories: parseCategories(map['categories']),
      images: parseImages(map['images']),
      status: map['status'] ?? 'closed',
      minOrderAmount: (map['minOrderAmount'] ?? 0.0).toDouble(),
      registrationDate: registrationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'location': location,
      'openTime': openTime,
      'closeTime': closeTime,
      'rating': rating,
      'categories': categories,
      'images': images,
      'status': status,
      'minOrderAmount': minOrderAmount,
      'registrationDate': registrationDate,
    };
  }

  bool isNewlyRegistered() {
    final now = DateTime.now();
    final registrationDateTime = registrationDate.toDate();
    final difference = now.difference(registrationDateTime);
    return difference.inDays <= 7;
  }
}
