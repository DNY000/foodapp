import 'package:flutter/material.dart';
import 'package:foodapp/models/order_model.dart';
import 'package:foodapp/repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  List<OrderModel> _orders = [];
  List<Map<String, dynamic>> _topSellingFoods = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<OrderModel> get orders => _orders;
  List<Map<String, dynamic>> get topSellingFoods => _topSellingFoods;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchOrders() async {
    try {
      _isLoading = true;
      notifyListeners();
      _orders = await _orderRepository.getOrders();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm phương thức mới để lấy món ăn bán chạy trong 7 ngày
  Future<void> fetchTopSellingFoodsLastWeek() async {
    try {
      _isLoading = true;
      notifyListeners();

      _topSellingFoods = await _orderRepository.getTopSellingFoodsLastWeek();
      _error = '';
    } catch (e) {
      _error = 'Không thể lấy danh sách món ăn bán chạy: ${e.toString()}';
      _topSellingFoods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm phương thức để lọc món ăn bán chạy theo danh mục
  List<Map<String, dynamic>> getTopSellingFoodsByCategory(String category) {
    return _topSellingFoods
        .where((food) => food['category'] == category)
        .toList();
  }

  // Thêm phương thức để lấy tổng doanh thu của các món ăn bán chạy
  double getTotalRevenue() {
    return _topSellingFoods.fold(
        0, (sum, food) => sum + (food['totalRevenue'] as double));
  }

  // Thêm phương thức để lấy tổng số lượng món đã bán
  int getTotalQuantitySold() {
    return _topSellingFoods.fold(
        0, (sum, food) => sum + (food['quantity'] as int));
  }
}
