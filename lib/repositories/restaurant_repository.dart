import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/models/restaurant_model.dart';

class RestaurantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// lay danh sach restaurant
  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final snapshot = await _firestore.collection("restaurants").get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return RestaurantModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách nhà hàng: $e');
    }
  }

  // lay restaurant theo id
  Future<RestaurantModel> getRestaurantById(String id) async {
    try {
      final snapshot = await _firestore.collection("restaurants").doc(id).get();
      return RestaurantModel.fromMap(snapshot.data() ?? {}, snapshot.id);
    } catch (e) {
      throw Exception('Không thể lấy nhà hàng theo id: $e');
    }
  }

  // lay restaurant theo danh mục
  Future<List<RestaurantModel>> getRestaurantsByCategory(
      String category) async {
    try {
      final snapshot = await _firestore
          .collection("restaurants")
          .where("category", isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return RestaurantModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy nhà hàng theo danh mục: $e');
    }
  }

  //lay restaurant theo khoang cách

  // Thêm phương thức để cập nhật registrationDate cho tất cả restaurants

  // Thêm phương thức lấy nhà hàng mới
  Future<List<RestaurantModel>> getNewRestaurants() async {
    try {
      final snapshot = await _firestore
          .collection("restaurants")
          .orderBy("registrationDate",
              descending: true) // Sắp xếp theo ngày đăng ký mới nhất
          .limit(10) // Giới hạn 10 nhà hàng mới nhất
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return RestaurantModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách nhà hàng mới: $e');
    }
  }

  Future<List<RestaurantModel>> getNearbyRestaurants() async {
    try {
      final snapshot = await _firestore.collection("restaurants").get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return RestaurantModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách nhà hàng: $e');
    }
  }
}
