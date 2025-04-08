import 'package:flutter/material.dart';
import 'package:foodapp/common/color_extension.dart';
import 'package:foodapp/common_widget/tabbar/list_food_by_category.dart';
import 'package:foodapp/models/category_model.dart';

class CategoryGridItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryGridItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final screenWidth = MediaQuery.of(context).size.width;

    // Tính toán kích thước icon dựa trên màn hình
    final iconSize = screenWidth * 0.12; // 12% của chiều rộng màn hình
    final fontSize = screenWidth * 0.028; // 2.8% của chiều rộng màn hình

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListFoodByCategory(
              category: category.id,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconSize * 1.3,
              height: iconSize * 1.2,
              decoration: BoxDecoration(
                color: TColor.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  category.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.restaurant,
                      size: iconSize * 0.6,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              constraints: BoxConstraints(
                maxWidth: iconSize * 2, // Giới hạn chiều rộng text
              ),
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Hiển thị số lượng món ăn nếu có
          ],
        ),
      ),
    );
  }
}
