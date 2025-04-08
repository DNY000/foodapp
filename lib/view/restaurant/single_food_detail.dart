import 'package:flutter/material.dart';
import 'package:foodapp/common_widget/add_cart_button.dart';
import 'package:foodapp/models/food_model.dart';
import 'package:foodapp/view/restaurant/review_user.dart';
import 'package:foodapp/viewmodels/favorite_viewmodel.dart';
import 'package:provider/provider.dart';

class SingleFoodDetail extends StatefulWidget {
  final FoodModel food;
  const SingleFoodDetail({super.key, required this.food});

  @override
  State<SingleFoodDetail> createState() => _SingleFoodDetailState();
}

class _SingleFoodDetailState extends State<SingleFoodDetail> {
  @override
  void initState() {
    super.initState();
    // Tải danh sách yêu thích khi màn hình được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final favoriteViewModel =
          Provider.of<FavoriteViewModel>(context, listen: false);
      favoriteViewModel.fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Thêm SafeArea để tránh overlap với status bar
        child: Column(
          children: [
            SizedBox(
              height: media * 0.6, // Đảm bảo chiều cao đồng nhất
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand, // Đảm bảo Stack lấp đầy không gian
                children: [
                  Image.asset(
                    widget.food.images[0],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Material(
                      // Wrap với Material để xử lý tap events
                      color: Colors.transparent,
                      child: InkWell(
                        // Sử dụng InkWell thay vì GestureDetector
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Consumer<FavoriteViewModel>(
                        builder: (context, favoriteViewModel, child) {
                          final isFavorite =
                              favoriteViewModel.isFoodFavorite(widget.food);
                          return IconButton(
                            icon: isFavorite
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 14,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                            onPressed: () {
                              print(
                                  "Toggle favorite button pressed for food: ${widget.food.name} (${widget.food.id})");
                              favoriteViewModel.toggleFavorite(widget.food);
                              print(
                                  "Favorite toggled, isFavorite: ${favoriteViewModel.isFoodFavorite(widget.food)}");
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    widget.food.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    widget.food.ingredients.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Đã bán: 100',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 15,
                        width: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Lượt xem: 100',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 15,
                        width: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Số lượng còn',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.food.price.toString()}đ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      AddCartButton(onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
            const Expanded(
              child: ReviewUser(),
            ),
          ],
        ),
      ),
    );
  }
}
