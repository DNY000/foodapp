import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/common_widget/grid/grid_view.dart';
import 'package:foodapp/models/category_model.dart';
import 'package:foodapp/view/home/widgets/category_gird_view.dart';
import 'package:foodapp/viewmodels/category_viewmodel.dart';
import 'package:provider/provider.dart';

class ListCategory extends StatelessWidget {
  const ListCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeContainer = MediaQuery.of(context).size.width * 0.45;
    return Container(
      // margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Danh mục",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Consumer<CategoryViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.error != null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Error: ${viewModel.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: () => viewModel.loadCategories(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (viewModel.categories.isEmpty) {
                return const Center(
                  child: Text('No categories available'),
                );
              }

              return SizedBox(
                height: sizeContainer,
                child: TGrid<CategoryModel>(
                  items: viewModel.categories,
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  shrinkWrap: true,
                  scrollable: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (category) =>
                      CategoryGridItem(category: category),
                  onTap: (category) {
                    if (kDebugMode) {
                      print('Selected category: ${category.name}');
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
