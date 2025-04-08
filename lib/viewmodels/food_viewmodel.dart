import 'package:flutter/material.dart';
import 'package:foodapp/models/food_model.dart';
import 'package:foodapp/repositories/food_repository.dart';

class FoodViewModel extends ChangeNotifier {
  final FoodRepository _foodRepository = FoodRepository();
  List<FoodModel> _foods = [];
  List<FoodModel> _fetchFoodsForYou = [];
  List<FoodModel> _allFoods = []; // Thêm danh sách món ăn bán chạy
  bool _isLoading = false;
  String _error = '';
  Map<String, List<FoodModel>> _categoryFoods = {};
  Map<String, List<FoodModel>> get categoryFoods => _categoryFoods;
  List<FoodModel> _fetchFoodsByRate = [];
  List<FoodModel> get fetchFoodsByRate => _fetchFoodsByRate;

  // Getters
  List<FoodModel> get allFoods => _allFoods;
  List<FoodModel> get foods => _foods;
  List<FoodModel> get fetchFoodsForYou => _fetchFoodsForYou;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Phương thức lấy món ăn bán chạy
  Future<void> fetchFoodsYouMaybeLike() async {
    try {
      _isLoading = true;
      notifyListeners();

      _fetchFoodsForYou = await _foodRepository.getFoods(4);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // lay danh sach tat ca cac mon an cua nha hang
  Future<void> fetchFoodsByRestaurant(String restaurantId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Lấy tất cả món ăn của nhà hàng
      final foods = await _foodRepository.getFoodsByRestaurant(restaurantId);

      // Gom nhóm theo category
      _categoryFoods.clear();
      for (var food in foods) {
        if (!_categoryFoods.containsKey(food.category)) {
          _categoryFoods[food.category] = [];
        }
        _categoryFoods[food.category]!.add(food);
      }

      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // lay danh sach cac mon an theo category va nha hang
  Future<void> fetchFoodsByCategoryAndRestaurant(
      String restaurantId, String category) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Gọi hàm từ repository để lấy danh sách món ăn
      final foods = await _foodRepository.getFoodsByCategoryAndRestaurant(
        restaurantId,
        category,
      );

      // Lưu vào map theo category
      _categoryFoods[category] = foods;
      _error = '';
    } catch (e) {
      print('Lỗi khi lấy món ăn: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFoodsByCategory(String category) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Nếu đã có dữ liệu trong cache, không cần fetch lại
      if (_categoryFoods.containsKey(category) &&
          _categoryFoods[category]!.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final foods = await _foodRepository.getFoodsByCategory(category);

      _categoryFoods[category] = foods;
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Phương thức để clear cache nếu cần
  void clearCache() {
    _categoryFoods.clear();
    notifyListeners();
  }

  List<FoodModel> getCategoryFoods(String categoryId) {
    return _categoryFoods[categoryId] ?? [];
  }

  Future<void> getAllFoods() async {
    try {
      _isLoading = true;
      notifyListeners();
      _allFoods = await _foodRepository.getFoods(10);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      throw _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFoodByRate() async {
    try {
      _isLoading = true;
      notifyListeners();
      _fetchFoodsByRate = await _foodRepository.getFoodByRate();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
