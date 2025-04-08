import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:foodapp/common/color_extension.dart';
import 'package:foodapp/ultils/local_storage/storage_utilly.dart';
import 'package:go_router/go_router.dart';
import '../../common_widget/round_button.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  bool isFirstTime = true;
  int selectPage = 0;
  final PageController controller = PageController();
  final TLocalStorage storage = TLocalStorage.instance();

  final List<Map<String, String>> infoArr = [
    {
      "title": "Xin chào",
      "sub_title": "Sản phẩm dầu tay",
      "icon": "assets/img/1.png"
    },
    {
      "title": "Tìm kiếm món ăn",
      "sub_title": "Nhớ bật vị trí của bạn\nđể tìm nhà hàng xung quanh",
      "icon": "assets/img/2.png"
    },
    {
      "title": "Món ăn",
      "sub_title": "Tìm kiếm nhiều món ăn nhanh",
      "icon": "assets/img/3.png"
    },
    {
      "title": "Free ship",
      "sub_title": "Bạn sẽ không mất phí ship",
      "icon": "assets/img/4.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    // Đọc trạng thái lần đầu
    isFirstTime = storage.readData<bool>("isFirstTime") ?? true;

    // Nếu không phải lần đầu, chuyển đến trang đăng nhập
    if (!isFirstTime) {
      // Đảm bảo context đã được khởi tạo trước khi chuyển màn hình
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/login');
        }
      });
    }

    controller.addListener(() {
      final page = controller.page?.round() ?? 0;
      if (selectPage != page) {
        setState(() {
          selectPage = page;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.primary,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: infoArr.length,
              itemBuilder: (context, index) {
                final iObj = infoArr[index];

                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: selectPage == index ? 1.0 : 0.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        iObj["icon"]!,
                        width: media.width * 0.6,
                        height: media.width * 0.6,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        iObj["title"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          iObj["sub_title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RoundButton(
                      title: "Login",
                      onPressed: () {
                        // Lưu trạng thái đã xem onboarding
                        storage.saveData("isFirstTime", false);

                        // Sử dụng Go Router cho điều hướng nhất quán
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(infoArr.length, (index) {
                        final isSelected = index == selectPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: isSelected ? 16 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.white38,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
