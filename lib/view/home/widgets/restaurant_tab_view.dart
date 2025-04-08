import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodapp/common_widget/grid/food_grid_item.dart';
import 'package:foodapp/models/food_model.dart';
import 'package:foodapp/view/restaurant/restaurant_detail_view.dart';
import 'package:foodapp/view/restaurant/single_food_detail.dart';
import 'package:foodapp/viewmodels/food_viewmodel.dart';
import 'package:foodapp/viewmodels/order_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../common/color_extension.dart';
import '../../../viewmodels/restaurant_viewmodel.dart';
import '../../../core/location_service.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantTabView extends StatefulWidget {
  const RestaurantTabView({super.key});

  @override
  State<RestaurantTabView> createState() => _RestaurantTabViewState();
}

class _RestaurantTabViewState extends State<RestaurantTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      if (mounted) {
        _getCurrentLocation();
        final viewModel = context.read<RestaurantViewModel>();
        viewModel.fetchRestaurants();
        // viewModel.fetchTopRatedRestaurants();
        context.read<OrderViewModel>().fetchTopSellingFoodsLastWeek();
        context.read<FoodViewModel>().getFoodByRate();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation(context);
      if (position != null && mounted) {
        setState(() {
          _currentPosition = position;
        });
        // Fetch restaurants with location
        context.read<RestaurantViewModel>().fetchNearbyRestaurants(
              position.latitude,
              position.longitude,
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể lấy vị trí: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              unselectedLabelColor: TColor.gray,
              tabs: const [
                Tab(
                  icon: Icon(Icons.location_on),
                  text: "Gần tôi",
                ),
                Tab(
                  icon: Icon(Icons.trending_up),
                  text: "Bán chạy",
                ),
                Tab(
                  icon: Icon(Icons.star),
                  text: "Đánh giá",
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNearbyRestaurants(),
            _buildBestSellerRestaurants(),
            _buildTopRatedRestaurants(),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyRestaurants() {
    return Consumer<RestaurantViewModel>(
      builder: (context, viewModel, child) {
        if (_currentPosition == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Vui lòng bật location để xem quán ăn gần bạn'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _getCurrentLocation,
                  child: const Text('Bật Location'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error.isNotEmpty
                      ? Center(child: Text('Lỗi: ${viewModel.error}'))
                      : viewModel.nearbyRestaurants.isEmpty
                          ? const Center(
                              child: Text(
                                'Không tìm thấy nhà hàng nào trong khu vực này',
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(15),
                              itemCount: viewModel.nearbyRestaurants.length,
                              itemBuilder: (context, index) {
                                final restaurant =
                                    viewModel.nearbyRestaurants[index];
                                final distanceInMeters =
                                    viewModel.calculateDistance(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                  restaurant.location['latitude'] ?? 0.0,
                                  restaurant.location['longitude'] ?? 0.0,
                                );
                                final formattedDistance =
                                    viewModel.formatDistance(distanceInMeters);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RestaurantDetailView(
                                                  restaurant: restaurant)),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 0.8,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(8),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          restaurant.images[0],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.restaurant),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        restaurant.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(restaurant.address),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Colors.orange,
                                              ),
                                              Text(
                                                ' ${restaurant.rating}',
                                                style: const TextStyle(
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: Colors.orange,
                                              ),
                                              Text(
                                                ' $formattedDistance',
                                                style: const TextStyle(
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        // TODO: Navigate to restaurant detail
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBestSellerRestaurants() {
    return Consumer<OrderViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error.isNotEmpty) {
          return Center(
            child: Text('Lỗi: ${viewModel.error}'),
          );
        }

        if (viewModel.topSellingFoods.isEmpty) {
          return const Center(
            child: Text('Chưa có món ăn bán chạy'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: viewModel.topSellingFoods.length,
          itemBuilder: (context, index) {
            final food = viewModel.topSellingFoods[index];
            final foodModel = FoodModel.fromMap(food);
            return Card(
              color: Colors.white,
              elevation: 0.8,
              margin: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SingleFoodDetail(food: foodModel)),
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: food['images'] != null &&
                            (food['images'] as List).isNotEmpty
                        ? Image.network(
                            food['images'][0],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.fastfood),
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.fastfood),
                          ),
                  ),
                  title: Text(
                    food['name'] ?? 'Không có tên',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Danh mục: ${food['category'] ?? 'Chưa phân loại'}'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.shopping_cart,
                            size: 16,
                            color: Colors.orange,
                          ),
                          Text(
                            ' Đã bán: ${food['quantity'] ?? 0}',
                            style: const TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.orange,
                          ),
                          Text(
                            ' ${food['rating']?.toStringAsFixed(1) ?? 'N/A'}',
                            style: const TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Doanh thu: ${(food['totalRevenue'] as double).toStringAsFixed(0)}đ',
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopRatedRestaurants() {
    return Consumer<FoodViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error.isNotEmpty) {
          return Center(
            child: Text('Lỗi: ${viewModel.error}'),
          );
        }

        if (viewModel.fetchFoodsByRate.isEmpty) {
          return const Center(
            child: Text('Chưa có nhà hàng được đánh giá'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: viewModel.fetchFoodsByRate.length,
          itemBuilder: (context, index) {
            final food = viewModel.fetchFoodsByRate[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleFoodDetail(food: food)));
              },
              child: Container(
                height: 140,
                child: Card(
                  color: Colors.white,
                  elevation: 0.8,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Image.asset(
                        food.images.first,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Column(
                        children: [
                          Text(food.name),
                          Row(
                            children: [
                              Text(food.rating.toString()),
                              RatingBarIndicator(
                                rating: food.rating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 12,
                                ),
                              )
                            ],
                          ),
                          Text(food.description),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
