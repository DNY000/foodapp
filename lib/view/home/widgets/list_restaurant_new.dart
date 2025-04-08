import 'package:flutter/material.dart';
import 'package:foodapp/common_widget/grid/grid_view.dart';
import 'package:foodapp/common_widget/grid/restaurant_grid_item.dart';
import 'package:foodapp/models/restaurant_model.dart';
import 'package:foodapp/view/restaurant/restaurant_detail_view.dart';
import 'package:foodapp/viewmodels/restaurant_viewmodel.dart';
import 'package:provider/provider.dart';

class ListRestaurantNew extends StatefulWidget {
  const ListRestaurantNew({super.key});

  @override
  State<ListRestaurantNew> createState() => _ListRestaurantNewState();
}

class _ListRestaurantNewState extends State<ListRestaurantNew> {
  @override
  void initState() {
    super.initState();
    // Fetch nhà hàng mới khi widget được khởi tạo
    Future.microtask(
      () {
        if (mounted) {
          context.read<RestaurantViewModel>().fetchNewRestaurants();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeContainer = MediaQuery.of(context).size.width * 0.45;
    return SizedBox(
      height: sizeContainer,
      // width: sizeContainer,
      child: Consumer<RestaurantViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${viewModel.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchNewRestaurants(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.newRestaurants.isEmpty) {
            return const Center(
              child: Text('Không có nhà hàng mới'),
            );
          }

          return TGrid<RestaurantModel>(
            items: viewModel.newRestaurants,
            crossAxisCount: 1,
            childAspectRatio: 1.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            scrollable: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (restaurant) => RestaurantGridItem(
              restaurant: restaurant,
              showNewBadge: true,
            ),
            onTap: (restaurant) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantDetailView(
                      restaurant: restaurant,
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
