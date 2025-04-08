import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodapp/core/simple_data.dart';

class DataImportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseService _firebaseService = FirebaseService();

  // Helper method để tạo document trực tiếp từ map data

  Future<void> importAllData() async {
    try {
      // Import users
      await _importCollection(
        name: 'người dùng',
        collection: 'users',
        dataGetter: SampleData.getUsers,
      );

      // Import categories
      await _importCollection(
        name: 'danh mục',
        collection: 'categories',
        dataGetter: SampleData.getCategories,
      );

      // Import restaurants
      await _importCollection(
        name: 'nhà hàng',
        collection: 'restaurants',
        dataGetter: SampleData.getRestaurants,
      );

      // Import foods
      await _importCollection(
        name: 'món ăn',
        collection: 'foods',
        dataGetter: SampleData.getFoods,
      );

      // Import addresses
      await _importCollection(
        name: 'địa chỉ',
        collection: 'addresses',
        dataGetter: SampleData.getAddresses,
      );

      // Import shippers
      await _importCollection(
        name: 'shipper',
        collection: 'shippers',
        dataGetter: SampleData.getShippers,
      );

      // Import orders
      await _importCollection(
        name: 'đơn hàng',
        collection: 'orders',
        dataGetter: SampleData.getOrders,
      );

      // Import payments
      await _importCollection(
        name: 'thanh toán',
        collection: 'payments',
        dataGetter: SampleData.getPayments,
      );

      // Import reviews
      await _importCollection(
        name: 'đánh giá',
        collection: 'reviews',
        dataGetter: SampleData.getReviews,
      );

      // Import promotions
      await _importCollection(
        name: 'khuyến mãi',
        collection: 'promotions',
        dataGetter: SampleData.getPromotions,
      );

      // Import notifications
      await _importCollection(
        name: 'thông báo',
        collection: 'notifications',
        dataGetter: SampleData.getNotifications,
      );

      // Import ratings
      await _importCollection(
        name: 'đánh giá shipper',
        collection: 'ratings',
        dataGetter: SampleData.getRatings,
      );

      // Import search history
      await _importCollection(
        name: 'lịch sử tìm kiếm',
        collection: 'search_history',
        dataGetter: SampleData.getSearchHistory,
      );

      // Import favorites
      await _importCollection(
        name: 'yêu thích',
        collection: 'favorites',
        dataGetter: SampleData.getFavorites,
      );

      // Import carts
      await _importCollection(
        name: 'giỏ hàng',
        collection: 'carts',
        dataGetter: SampleData.getCarts,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Helper method để import một collection
  Future<void> _importCollection({
    required String name,
    required String collection,
    required List<Map<String, dynamic>> Function() dataGetter,
  }) async {
    try {
      final items = dataGetter();
      int successCount = 0;
      int failCount = 0;

      if (kDebugMode) {
        print(
            'Đã nhập $successCount/$items.length dữ liệu $name thành công. Thất bại: $failCount');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi xử lý danh sách $name: $e');
      }
    }
  }

  // Phương thức xóa tất cả dữ liệu
  Future<void> clearAllData() async {
    try {
      // Danh sách tất cả các collection cần xóa
      final collections = [
        'users',
        'restaurants',
        'foods',
        'orders',
        'categories',
        'promotions',
        'reviews',
        'shippers',
        'notifications',
        'addresses',
        'payments',
        'ratings',
        'search_history',
        'favorites',
        'carts'
      ];

      for (var collection in collections) {
        var snapshot = await _firestore.collection(collection).get();

        // Batch delete để tối ưu hiệu suất
        var batch = _firestore.batch();
        int count = 0;

        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
          count++;

          // Firestore giới hạn 500 operations trong một batch
          if (count >= 400) {
            await batch.commit();

            batch = _firestore.batch();
            count = 0;
          }
        }

        // Commit batch cuối cùng nếu còn
        if (count > 0) {
          await batch.commit();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Import dữ liệu ngẫu nhiên

  // Các phương thức để nhập từng loại dữ liệu riêng
  Future<void> importUsers() async {
    return _importCollection(
      name: 'người dùng',
      collection: 'users',
      dataGetter: SampleData.getUsers,
    );
  }

  Future<void> importCategories() async {
    return _importCollection(
      name: 'danh mục',
      collection: 'categories',
      dataGetter: SampleData.getCategories,
    );
  }

  Future<void> importRestaurants() async {
    return _importCollection(
      name: 'nhà hàng',
      collection: 'restaurants',
      dataGetter: SampleData.getRestaurants,
    );
  }

  Future<void> importFoods() async {
    try {
      final foods = SampleData.getFoods();
      final batch = _firestore.batch();

      for (var food in foods) {
        final docRef = _firestore.collection('foods').doc(food['id']);
        batch.set(docRef, food);
      }

      await batch.commit();
      if (kDebugMode) {
        print('Đã import ${foods.length} món ăn thành công');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi import món ăn: $e');
      }
      rethrow;
    }
  }

  Future<void> importOrders() async {
    return _importCollection(
      name: 'đơn hàng',
      collection: 'orders',
      dataGetter: SampleData.getOrders,
    );
  }

  Future<void> importAddresses() async {
    return _importCollection(
      name: 'địa chỉ',
      collection: 'addresses',
      dataGetter: SampleData.getAddresses,
    );
  }

  Future<void> importCarts() async {
    return _importCollection(
      name: 'giỏ hàng',
      collection: 'carts',
      dataGetter: SampleData.getCarts,
    );
  }
}
