import 'package:flutter/material.dart';
import 'package:foodapp/view/restaurant/single_food_detail.dart';
import 'package:foodapp/viewmodels/food_viewmodel.dart';
import 'package:provider/provider.dart';

class RestaurantFoodsScreen extends StatefulWidget {
  final String restaurantId;
  final List<String> categories;

  const RestaurantFoodsScreen(
      {Key? key, required this.restaurantId, required this.categories})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantFoodsScreenState createState() => _RestaurantFoodsScreenState();
}

class _RestaurantFoodsScreenState extends State<RestaurantFoodsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FoodViewModel>(context, listen: false)
          .fetchFoodsByRestaurant(widget.restaurantId);
    });
    _tabController =
        TabController(length: widget.categories.length, vsync: this);

    if (widget.categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadCategoryFoods(widget.categories[0]);
        }
      });
    }

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && mounted) {
        _loadCategoryFoods(widget.categories[_tabController.index]);
      }
    });
  }

  void _loadCategoryFoods(String category) {
    try {
      context.read<FoodViewModel>().fetchFoodsByCategoryAndRestaurant(
            widget.restaurantId,
            category,
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text('Không có danh mục món ăn'),
        ),
      );
    }

    return Column(
      children: [
        Container(
          height: 48, // Chiều cao cố định cho TabBar
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            indicatorWeight: 2,
            tabs: widget.categories.map((category) {
              return Tab(
                text: category.toUpperCase(),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.categories.map(_buildTabContent).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(String category) {
    return Consumer<FoodViewModel>(
      builder: (context, foodViewModel, child) {
        if (foodViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (foodViewModel.error.isNotEmpty) {
          return Center(child: Text(foodViewModel.error));
        }

        final foods = foodViewModel.categoryFoods[category] ?? [];

        if (foods.isEmpty) {
          return const Center(child: Text("Không có món ăn nào."));
        }

        return ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleFoodDetail(food: food),
                    ));
              },
              child: ListTile(
                leading: Image.asset(food.images[0], fit: BoxFit.cover),
                title: Text(food.name),
                subtitle: Text("\$${food.price.toStringAsFixed(2)}"),
              ),
            );
          },
        );
      },
    );
  }
}
