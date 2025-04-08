import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/models/favorite_model.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FavoriteFoodModel>> getFavorites() async {
    try {
      final snapshot = await _firestore.collection("favorites").get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FavoriteFoodModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách yêu thích: $e');
    }
  }

  Future<FavoriteFoodModel> getFavoriteById(String id) async {
    try {
      final snapshot = await _firestore.collection("favorites").doc(id).get();
      return FavoriteFoodModel.fromMap(snapshot.data() ?? {}, snapshot.id);
    } catch (e) {
      throw Exception('Không thể lấy yêu thích theo id: $e');
    }
  }

  Future<List<FavoriteFoodModel>> getFavoritesByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection("favorites")
          .where("userId", isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FavoriteFoodModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Không thể lấy yêu thích theo userId: $e');
    }
  }

  Future<void> createFavorite(FavoriteFoodModel favorite) async {
    try {
      await _firestore.collection("favorites").doc().set(favorite.toMap());
    } catch (e) {
      throw Exception('Không thể tạo yêu thích: $e');
    }
  }

  // Thêm món ăn vào danh sách yêu thích và trả về ID
  Future<String> addFavorite(FavoriteFoodModel favorite) async {
    try {
      final docRef =
          await _firestore.collection("favorites").add(favorite.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Không thể thêm vào yêu thích: $e');
    }
  }

  // Xóa món ăn khỏi danh sách yêu thích
  Future<void> removeFavorite(String favoriteId) async {
    try {
      await _firestore.collection("favorites").doc(favoriteId).delete();
    } catch (e) {
      throw Exception('Không thể xóa khỏi yêu thích: $e');
    }
  }
}
