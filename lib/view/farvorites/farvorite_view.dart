import 'package:flutter/material.dart';
import 'package:foodapp/view/order/filter_view.dart';
import 'package:provider/provider.dart';
import '../../common/color_extension.dart';
import '../../common_widget/line_textfield.dart';
import '../../common_widget/popup_layout.dart';
import '../../models/food_model.dart';
import '../../viewmodels/favorite_viewmodel.dart';
import '../../viewmodels/food_viewmodel.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  TextEditingController txtSearch = TextEditingController();
  List<FoodModel> favoriteItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  Future<void> _loadFavorites() async {
    final favoriteViewModel =
        Provider.of<FavoriteViewModel>(context, listen: false);
    final foodViewModel = Provider.of<FoodViewModel>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    try {
      // Tải danh sách món ăn TRƯỚC
      print("Đang tải danh sách món ăn...");
      await foodViewModel.getAllFoods();
      print("Đã tải ${foodViewModel.foods.length} món ăn");

      // Sau đó tải danh sách yêu thích
      await favoriteViewModel.fetchFavorites();

      // Debug logs
      print("Favorites count: ${favoriteViewModel.favorites.length}");
      print("Foods count: ${foodViewModel.foods.length}");
      print(
          "Foods: ${foodViewModel.foods.map((food) => '${food.id}: ${food.name}').join(', ')}");

      // Lọc món ăn dựa trên danh sách yêu thích
      final favoriteFoods = favoriteViewModel.favorites;
      final foodList = foodViewModel.foods.isEmpty
          ? foodViewModel.allFoods
          : foodViewModel.foods;

      List<FoodModel> items = [];

      for (var favorite in favoriteFoods) {
        print(
            "Processing favorite: ${favorite.itemId} - Type: ${favorite.itemType}");
        if (favorite.itemType == 'food') {
          final food = foodList.firstWhere(
            (food) => food.id == favorite.itemId,
            orElse: () {
              print("Food not found: ${favorite.itemId}");
              return FoodModel(
                id: '',
                name: 'Unknown',
                description: '',
                price: 0,
                category: '',
                images: ['assets/img/placeholder.png'],
                restaurantId: '',
                preparationTime: 0,
                isAvailable: false,
                rating: 0,
                options: [],
                ingredients: [],
              );
            },
          );

          if (food.id.isNotEmpty) {
            print("Adding food to favorites list: ${food.name}");
            items.add(food);
          }
        }
      }

      setState(() {
        favoriteItems = items;
        isLoading = false;
      });

      print("Final favorites items count: ${favoriteItems.length}");
    } catch (e) {
      print("Error loading favorites: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              pinned: true,
              floating: false,
              centerTitle: false,
              leadingWidth: 0,
              title: Row(
                children: [
                  Image.asset(
                    "assets/img/bookmark_icon.png",
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Món ăn yêu thích",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: TColor.text,
                        fontSize: 28,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              pinned: false,
              floating: true,
              primary: false,
              expandedHeight: 50,
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RoundTextField(
                  controller: txtSearch,
                  hitText: "Tìm kiếm món ăn yêu thích...",
                  leftIcon: Icon(Icons.search, color: TColor.gray),
                ),
              ),
            ),
          ];
        },
        body: Consumer<FavoriteViewModel>(
            builder: (context, favoriteViewModel, child) {
          if (favoriteViewModel.isLoading || isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (favoriteItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: TColor.primary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    "Bạn chưa có món ăn yêu thích nào",
                    style: TextStyle(
                        color: TColor.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "Nhấn vào biểu tượng trái tim trên màn hình chi tiết món ăn để thêm vào danh sách yêu thích",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.gray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/main_tab');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Khám phá món ăn ngay",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (favoriteViewModel.error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Lỗi: ${favoriteViewModel.error}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              ListView.builder(
                  padding: const EdgeInsets.only(top: 40),
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final food = favoriteItems[index];
                    return FavoriteFoodItem(
                      food: food,
                      onRemoved: () {
                        // Xóa khỏi danh sách yêu thích
                        favoriteViewModel.toggleFavorite(food);
                        setState(() {
                          favoriteItems.removeAt(index);
                        });
                      },
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, PopupLayout(child: const FilterView()));
                      },
                      child: Text(
                        "Lọc",
                        style: TextStyle(
                            color: TColor.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class FavoriteFoodItem extends StatelessWidget {
  final FoodModel food;
  final VoidCallback onRemoved;

  const FavoriteFoodItem({
    super.key,
    required this.food,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.asset(
              food.images.first,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey.shade400,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${food.price.toStringAsFixed(0)}đ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TColor.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: onRemoved,
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
