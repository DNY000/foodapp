import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// lay don hang theo ngay
  Future<List<OrderModel>> getOrders({int limit = -1}) async {
    try {
      Query query = _firestore.collection("orders");

      if (limit > 0) {
        DateTime fromDate = DateTime.now().subtract(Duration(days: limit));
        query = query.where("createdAt",
            isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate));
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách đơn hàng: $e');
    }
  }

// lay don hang ban cha

  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection("orders")
          .where("userId", isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy đơn hàng theo userId: $e');
    }
  }

  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection("orders").doc().set(order.toMap());
    } catch (e) {
      throw Exception('Không thể tạo đơn hàng: $e');
    }
  }

// lay don hang pho biên
  Future<List<OrderModel>> getOrdersByRestaurantId(String restaurantId) async {
    try {
      final snapshot = await _firestore
          .collection("orders")
          .where("restaurantId", isEqualTo: restaurantId)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy đơn hàng theo restaurantId: $e');
    }
  }

  // Thêm phương thức mới để lấy thống kê món ăn phổ biến
  Future<Map<String, int>> getPopularFoodStats(String restaurantId) async {
    try {
      // 1. Lấy tất cả đơn hàng đã hoàn thành của nhà hàng
      final snapshot = await _firestore
          .collection('orders')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('status', isEqualTo: 'delivered')
          .get();

      // 2. Map để đếm số lượng đã bán của mỗi món
      Map<String, int> foodSoldCounts = {};

      // 3. Duyệt qua từng đơn hàng và đếm số lượng
      for (var doc in snapshot.docs) {
        final orderData = doc.data();
        final items = orderData['items'] as List<dynamic>;

        for (var item in items) {
          final foodId = item['foodId'] as String;
          final quantity = item['quantity'] as int? ?? 1;
          foodSoldCounts[foodId] = (foodSoldCounts[foodId] ?? 0) + quantity;
        }
      }

      return foodSoldCounts;
    } catch (e) {
      throw Exception('Không thể lấy thống kê món ăn: $e');
    }
  }

  // Lấy danh sách món ăn phổ biến với số lượng đã bán
  Future<List<Map<String, dynamic>>> getPopularFoods(
      String restaurantId) async {
    try {
      // 1. Lấy thống kê số lượng bán
      final foodStats = await getPopularFoodStats(restaurantId);

      // 2. Sắp xếp theo số lượng bán
      var entries = foodStats.entries.toList();
      entries.sort((a, b) => b.value.compareTo(a.value));

      // 3. Lấy top 10 món bán chạy nhất
      var topFoods = entries.take(10);

      // 4. Tạo danh sách kết quả với thông tin món ăn và số lượng đã bán
      List<Map<String, dynamic>> result = [];
      for (var entry in topFoods) {
        final foodDoc =
            await _firestore.collection('foods').doc(entry.key).get();
        if (foodDoc.exists) {
          final foodData = foodDoc.data()!;
          result.add({
            'food': foodData,
            'soldQuantity': entry.value,
          });
        }
      }

      return result;
    } catch (e) {
      throw Exception('Không thể lấy danh sách món ăn phổ biến: $e');
    }
  }

  // Thêm phương thức mới vào OrderRepository
  Future<List<Map<String, dynamic>>> getTopSellingFoodsLastWeek() async {
    try {
      // 1. Lấy thời điểm 7 ngày trước
      final DateTime sevenDaysAgo =
          DateTime.now().subtract(const Duration(days: 7));

      // 2. Chỉ where theo thời gian
      final snapshot = await _firestore
          .collection('orders')
          .where('orderTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
          .get();

      // 3. Map để đếm số lượng bán của mỗi món ăn
      Map<String, Map<String, dynamic>> foodStats = {};

      // 4. Duyệt qua từng đơn hàng và thống kê
      for (var doc in snapshot.docs) {
        final order = OrderModel.fromMap(doc.data(), doc.id);

        // Kiểm tra status ở đây thay vì trong query
        if (order.status != 'delivered') continue;

        // Duyệt qua từng món trong đơn hàng
        for (var item in order.items) {
          if (!foodStats.containsKey(item.foodId)) {
            foodStats[item.foodId] = {
              'quantity': 0,
              'totalRevenue': 0.0,
              'name': item.foodName,
              'price': item.price,
            };
          }

          foodStats[item.foodId]!['quantity'] =
              (foodStats[item.foodId]!['quantity'] as int) + item.quantity;
          foodStats[item.foodId]!['totalRevenue'] =
              (foodStats[item.foodId]!['totalRevenue'] as double) +
                  (item.price * item.quantity);
        }
      }

      // 5. Chuyển map thành list và sắp xếp theo số lượng bán
      var sortedFoods = foodStats.entries
          .map((entry) => {
                'foodId': entry.key,
                'name': entry.value['name'],
                'quantity': entry.value['quantity'],
                'totalRevenue': entry.value['totalRevenue'],
                'price': entry.value['price'],
              })
          .toList();

      // Sắp xếp theo số lượng bán giảm dần
      sortedFoods.sort(
          (a, b) => (b['quantity'] as int).compareTo(a['quantity'] as int));

      // 6. Lấy thông tin chi tiết của các món ăn từ collection foods
      List<Map<String, dynamic>> result = [];
      for (var food in sortedFoods) {
        try {
          final foodDoc = await _firestore
              .collection('foods')
              .doc(food['foodId'] as String)
              .get();
          if (foodDoc.exists) {
            final foodData = foodDoc.data()!;
            result.add({
              ...food,
              'description': foodData['description'],
              'category': foodData['category'],
              'images': foodData['images'],
              'rating': foodData['rating'],
            });
          }
        } catch (e) {
          rethrow;
        }
      }

      // 7. Trả về top 10 món bán chạy nhất
      return result.take(10).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách món ăn bán chạy: $e');
    }
  }
}
