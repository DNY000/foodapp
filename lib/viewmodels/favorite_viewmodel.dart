import 'package:flutter/material.dart';
import 'package:foodapp/models/favorite_model.dart';
import 'package:foodapp/models/food_model.dart';
import 'package:foodapp/repositories/favorite_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();
  List<FavoriteFoodModel> _favorites = [];
  List<FavoriteFoodModel> get favorites => _favorites;
  bool _isLoading = false;
  String _error = '';
  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchFavorites() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _error = 'Vui lòng đăng nhập để xem danh sách yêu thích';
        _favorites = [];
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();
      _favorites = await _favoriteRepository.getFavoritesByUserId(userId);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _favorites = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kiểm tra xem món ăn có trong danh sách yêu thích hay không
  bool isFoodFavorite(FoodModel food) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;

    return _favorites.any((fav) =>
        fav.itemId == food.id &&
        fav.userId == userId &&
        fav.itemType == 'food');
  }

  // Thêm/xóa món ăn khỏi danh sách yêu thích
  Future<void> toggleFavorite(FoodModel food) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _error = 'Vui lòng đăng nhập để thêm vào danh sách yêu thích';
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();

      // Kiểm tra xem món ăn đã có trong yêu thích chưa
      final existingIndex = _favorites.indexWhere((fav) =>
          fav.itemId == food.id &&
          fav.userId == userId &&
          fav.itemType == 'food');

      if (existingIndex >= 0) {
        // Nếu đã có, xóa khỏi danh sách yêu thích
        final favoriteToRemove = _favorites[existingIndex];
        await _favoriteRepository.removeFavorite(favoriteToRemove.id);
        _favorites.removeAt(existingIndex);
        _isFavorite = false;
      } else {
        // Nếu chưa có, thêm vào danh sách yêu thích
        final newFavorite = FavoriteFoodModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          itemId: food.id,
          itemType: 'food',
          createdAt: DateTime.now(),
        );

        final favoriteId = await _favoriteRepository.addFavorite(newFavorite);
        newFavorite.id = favoriteId;
        _favorites.add(newFavorite);
        _isFavorite = true;
      }

      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
