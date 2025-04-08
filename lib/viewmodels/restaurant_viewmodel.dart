import 'package:flutter/material.dart';
import 'package:foodapp/models/restaurant_model.dart';
import 'package:foodapp/repositories/restaurant_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:foodapp/repositories/food_repository.dart';
import 'package:foodapp/models/food_model.dart';
import 'package:foodapp/repositories/order_repository.dart';

class RestaurantViewModel extends ChangeNotifier {
  final RestaurantRepository _repository = RestaurantRepository();
  final FoodRepository _foodRepository = FoodRepository();
  final OrderRepository _orderRepository = OrderRepository();
  bool _isLoading = false;
  String _error = '';
  List<RestaurantModel> _restaurants = [];
  RestaurantModel? _restaurant;
  List<RestaurantModel> _nearbyRestaurants = [];
  List<RestaurantModel> _bestSellerRestaurants = [];
  List<RestaurantModel> _topRatedRestaurants = [];
  List<RestaurantModel> _newRestaurants = [];
  double _selectedRadius = 20.0; // Mặc định 10km
  List<Map<String, dynamic>> _popularFoods = [];
  Map<String, List<FoodModel>> _foodsByCategory = {};

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;
  List<RestaurantModel> get restaurants => _restaurants;
  RestaurantModel? get restaurant => _restaurant;
  List<RestaurantModel> get nearbyRestaurants => _nearbyRestaurants;
  List<RestaurantModel> get bestSellerRestaurants => _bestSellerRestaurants;
  List<RestaurantModel> get topRatedRestaurants => _topRatedRestaurants;
  List<RestaurantModel> get newRestaurants => _newRestaurants;
  double get selectedRadius => _selectedRadius;
  List<Map<String, dynamic>> get popularFoods => _popularFoods;
  Map<String, List<FoodModel>> get foodsByCategory => _foodsByCategory;

// danh sach nha hang
  Future<void> fetchRestaurants() async {
    try {
      _isLoading = true;
      notifyListeners();
      _restaurants = await _repository.getRestaurants();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // lấy thông tin nha hang theo id
  Future<void> fetchRestaurantById(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      _restaurant = await _repository.getRestaurantById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantByCategory(String category) async {
    try {
      _isLoading = true;
      notifyListeners();
      _restaurants = await _repository.getRestaurantsByCategory(category);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // lấy danh sach nha hang moi
  Future<void> fetchNewRestaurants() async {
    try {
      _isLoading = true;
      notifyListeners();

      _newRestaurants = await _repository.getNewRestaurants();

      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Phương thức để thay đổi bán kính tìm kiếm
  void updateSearchRadius(double newRadius) {
    _selectedRadius = newRadius;
    notifyListeners();
  }

  // lấy danh sach nha hang gần nhất
  Future<void> fetchNearbyRestaurants(double userLat, double userLng) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Lấy tất cả nhà hàng từ repository
      final allRestaurants = await _repository.getNearbyRestaurants();

      // Lọc và sắp xếp nhà hàng theo khoảng cách
      _nearbyRestaurants = allRestaurants.where((restaurant) {
        final distance = calculateDistance(
          userLat,
          userLng,
          restaurant.location['latitude'] ?? 0.0,
          restaurant.location['longitude'] ?? 0.0,
        );
        return (distance / 1000) <= _selectedRadius;
      }).toList();

      // Sắp xếp theo khoảng cách
      _nearbyRestaurants.sort((a, b) {
        final distanceA = calculateDistance(
          userLat,
          userLng,
          a.location['latitude'] ?? 0.0,
          a.location['longitude'] ?? 0.0,
        );
        final distanceB = calculateDistance(
          userLat,
          userLng,
          b.location['latitude'] ?? 0.0,
          b.location['longitude'] ?? 0.0,
        );
        return distanceA.compareTo(distanceB);
      });

      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm tính khoảng cách
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    );
  }

  // Hàm format khoảng cách để hiển thị
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }

  // Thêm phương thức để lấy món ăn phổ biến
  Future<void> fetchPopularFoods(String restaurantId) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _popularFoods = await _orderRepository.getPopularFoods(restaurantId);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _popularFoods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm phương thức để lấy món ăn theo category
  List<FoodModel> getFoodsByCategory(String category) {
    return _foodsByCategory[category] ?? [];
  }

  // Thêm phương thức để fetch tất cả món ăn của nhà hàng và phân loại theo category
  Future<void> fetchFoodsByRestaurant(String restaurantId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Reset map
      _foodsByCategory.clear();

      // Lấy tất cả món ăn của nhà hàng
      final foods = await _foodRepository.getFoodsByRestaurant(restaurantId);

      // Phân loại món ăn theo category
      for (var food in foods) {
        if (!_foodsByCategory.containsKey(food.category)) {
          _foodsByCategory[food.category] = [];
        }
        _foodsByCategory[food.category]!.add(food);
      }

      _error = '';
    } catch (e) {
      _error = e.toString();
      _foodsByCategory.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy số lượng đã bán của một món ăn
  int getFoodSoldCount(String foodId) {
    try {
      final foodStats = _popularFoods.firstWhere(
        (item) => item['food']['id'] == foodId,
        orElse: () => {'soldQuantity': 0},
      );
      return foodStats['soldQuantity'] as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
