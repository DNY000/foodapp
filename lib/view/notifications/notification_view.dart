import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/selection_button.dart';
import '../../common_widget/top_foodies_user_row.dart';

class TopFoodieView extends StatefulWidget {
  const TopFoodieView({super.key});

  @override
  State<TopFoodieView> createState() => _TopFoodieViewState();
}

class _TopFoodieViewState extends State<TopFoodieView> {
  var selectTab = 0;

  List<Map<String, dynamic>> notificationList = [
    {
      "title": "[CT, HP, HC] Ưu đãi xịn từ thẻ Hi ShopeeFood",
      "image": "assets/img/u1.png",
      "time": "07/04/2025 15:00",
      "details": [
        {"icon": "🌟", "text": "Giảm 50.000Đ cho lần đầu liên kết thẻ"},
        {"icon": "🎁", "text": "Giảm 50.000Đ đặt món ShopeeFood"},
        {"icon": "🛒", "text": "Giảm 50.000Đ đi chợ ShopeeFood Mart"},
        {"icon": "😊", "text": "Đặc quyền tặng riêng bạn, đừng bỏ lỡ!"},
      ]
    },
    {
      "title": "[HCMC, HN] DEAL ĂN XẾ: GIẢM 30%",
      "image": "assets/img/u2.png",
      "time": "07/04/2025 13:30",
      "details": [
        {"icon": "🥛", "text": "Trà sữa, bánh tráng, dimsum, milo..."},
        {"icon": "👋", "text": "Chiều nhâm nhi, đặt nhanh kẻo hết."},
      ]
    },
    {
      "title": "[HN, HCMC] GIẢM 199.000Đ mời bạn ăn trưa!",
      "image": "assets/img/u1.png",
      "time": "07/04/2025 10:30",
      "details": [
        {"icon": "⚡", "text": "Khi nhập mã SIEUTIEC199K"},
        {"icon": "🍜", "text": "Bánh canh, bún chả, cơm gà..."},
        {"icon": "💛", "text": "Đặt ShopeeFood, ăn lễ thành thơi!"},
      ]
    },
    {
      "title": "[HCMC, HN] GIẢM 20.000Đ, mừng Giỗ Tổ🍉",
      "image": "assets/img/u2.png",
      "time": "07/04/2025 08:00",
      "details": [
        {"icon": "☀️", "text": "Khi nhập mã SIEUTIEC20"},
        {"icon": "⚡", "text": "Giảm 20.000Đ đơn từ 50.000Đ"},
        {"icon": "🍜", "text": "Bún bò, bánh mì, cà phê muối,..."},
        {"icon": "👋", "text": "Ăn sáng cùng ShopeeFood nhé!"},
      ]
    },
    {
      "title": "[HCMC, HN] Ăn ngon còn GIẢM 70.000Đ🔥",
      "image": "assets/img/u1.png",
      "time": "06/04/2025 16:55",
      "details": [
        {"icon": "⚡", "text": "Khi nhập mã SIEUTIEC70"},
        {"icon": "🍱", "text": "Cơm sườn, mì cay, kimbap,..."},
        {"icon": "👍", "text": "Rất nhiều món rẻ ngon đang chờ"},
        {"icon": "😊", "text": "Đặt món ngon, ăn lễ lớn nào!"},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Text(
          "Thông báo",
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: notificationList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notification = notificationList[index];
          return NotificationItem(notification: notification);
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationItem({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              notification["image"],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.orange.withOpacity(0.2),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.orange,
                    size: 30,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Nội dung thông báo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề thông báo
                Text(
                  notification["title"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Chi tiết thông báo
                ...List.generate(
                  notification["details"].length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification["details"][index]["icon"],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            notification["details"][index]["text"],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Thời gian
                const SizedBox(height: 4),
                Text(
                  notification["time"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
