import 'package:flutter/material.dart';
import 'package:foodapp/viewmodels/category_viewmodel.dart';
import 'package:foodapp/viewmodels/food_viewmodel.dart';

class ListFoodByCategory extends StatefulWidget {
  final String category;
  const ListFoodByCategory({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _ListFoodByCategoryState createState() => _ListFoodByCategoryState();
}

class _ListFoodByCategoryState extends State<ListFoodByCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FoodViewModel _foodViewModel = FoodViewModel();
  final CategoryViewModel _categoryViewModel = CategoryViewModel();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _categoryViewModel.loadCategories();

    // Khởi tạo TabController sau khi đã load categories
    setState(() {
      // +1 cho tab "Tất cả"
      _tabController = TabController(
        length: _categoryViewModel.categories.length + 1,
        vsync: this,
      );
    });

    // Đảm bảo category được chuyển sang chữ hoa để khớp với data
    final category = widget.category.toUpperCase();
    await _foodViewModel.fetchFoodsByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục '),
      ),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: _categoryViewModel,
            builder: (context, _) {
              if (_categoryViewModel.isLoading) {
                return const SizedBox(
                  height: 48,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (_categoryViewModel.categories.isEmpty) {
                return const SizedBox(
                  height: 48,
                  child: Center(child: Text('Không có danh mục')),
                );
              }

              return TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
                tabs: [
                  const Tab(text: 'Tất cả'),
                  ..._categoryViewModel.categories
                      .map((category) => Tab(text: category.name))
                      .toList(),
                ],
                onTap: (index) {
                  if (index == 0) {
                    // Tất cả món ăn
                    _foodViewModel
                        .fetchFoodsByCategory(widget.category.toUpperCase());
                  } else {
                    // Món ăn theo category đã chọn
                    final selectedCategory =
                        _categoryViewModel.categories[index - 1];
                    _foodViewModel.fetchFoodsByCategory(selectedCategory.id);
                  }
                },
              );
            },
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: _foodViewModel,
              builder: (context, child) {
                if (_foodViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_foodViewModel.error.isNotEmpty) {
                  return Center(child: Text('Lỗi: ${_foodViewModel.error}'));
                }

                final foods = _foodViewModel
                        .categoryFoods[widget.category.toUpperCase()] ??
                    [];

                if (foods.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_meals, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Không có món ăn nào trong danh mục này',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab Tất cả
                    _buildFoodList(foods),
                    // Tabs theo categories
                    ..._categoryViewModel.categories.map((category) {
                      final filteredFoods = foods
                          .where((food) => food.category == category.id)
                          .toList();

                      return _buildFoodList(filteredFoods);
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(List<dynamic> foods) {
    if (foods.isEmpty) {
      return const Center(
        child: Text('Không có món ăn nào trong danh mục này'),
      );
    }

    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: food.images.isNotEmpty
                ? Image.network(
                    food.images.first,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.fastfood);
                    },
                  )
                : const Icon(Icons.fastfood),
            title: Text(food.name),
            subtitle: Text(
              food.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              '${food.price.toStringAsFixed(0)}đ',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
