import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';

class FoodRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // lay danh sach tat ca cac mon an
  Future<List<FoodModel>> getFoods(int limit) async {
    try {
      final foodsRef = _firestore.collection('foods').limit(limit);
      final snapshot = await foodsRef.get();
      final listFood = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        print("Loaded food: ${doc.id} - ${data['name']}");
        return FoodModel.fromMap(data);
      }).toList();
      return listFood;
    } catch (e) {
      throw Exception('Không thể lấy danh sách món ăn: $e');
    }
  }

  // Thêm phương thức lấy món ăn theo category
  Future<List<FoodModel>> getFoodsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('foods')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return FoodModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách món ăn theo category: $e');
    }
  }

  // Lấy tất cả món ăn của một nhà hàng
  Future<List<FoodModel>> getFoodsByRestaurant(String restaurantId) async {
    try {
      final snapshot = await _firestore
          .collection('foods')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return FoodModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách món ăn của nhà hàng: $e');
    }
  }

  // Lấy món ăn theo category của nhà hàng
  Future<List<FoodModel>> getFoodsByCategoryAndRestaurant(
    String restaurantId,
    String category,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('foods')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return FoodModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách món ăn theo category: $e');
    }
  }

  Future<List<FoodModel>> getFoodByRate() async {
    try {
      final snapshot = await _firestore
          .collection('foods')
          .orderBy('rating', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return FoodModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách món ăn theo rating: $e');
    }
  }
}
