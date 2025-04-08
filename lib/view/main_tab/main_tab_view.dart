import 'package:flutter/material.dart';
import 'package:foodapp/common/color_extension.dart';
import 'package:foodapp/common_widget/shimmer/shimmer_main_tab.dart';
import 'package:foodapp/view/notifications/notification_view.dart';
import 'package:foodapp/view/order/order_view.dart';
import 'package:foodapp/view/profile/my_profile_view.dart';
import 'dart:ui';
import 'dart:async';

import '../farvorites/farvorite_view.dart';
import '../home/home_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with TickerProviderStateMixin {
  TabController? controller;

  // Các completer để quản lý trạng thái tải của từng tab
  final List<Completer<bool>> _dataLoadingCompleters = List.generate(
    5,
    (_) => Completer<bool>(),
  );

  // Các future để theo dõi trạng thái tải của tab hiện tại
  late Future<bool> _currentTabDataLoaded;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);

    // Thiết lập tab ban đầu
    _currentTabDataLoaded = _dataLoadingCompleters[0].future;

    // Khởi động tải dữ liệu cho tab đầu tiên
    _loadDataForCurrentTab();

    controller?.addListener(() {
      if (controller!.indexIsChanging) {
        // Khi chuyển tab, cập nhật future hiện tại
        setState(() {
          _currentTabDataLoaded =
              _dataLoadingCompleters[controller!.index].future;
        });

        // Bắt đầu tải dữ liệu cho tab mới
        _loadDataForCurrentTab();
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _loadDataForCurrentTab() {
    final currentTabIndex = controller!.index;

    // Chỉ tải dữ liệu nếu chưa được hoàn thành
    if (!_dataLoadingCompleters[currentTabIndex].isCompleted) {
      // Mô phỏng việc tải dữ liệu từ API
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted && !_dataLoadingCompleters[currentTabIndex].isCompleted) {
          // Đánh dấu là đã tải xong dữ liệu
          _dataLoadingCompleters[currentTabIndex].complete(true);

          if (controller!.index == currentTabIndex) {
            setState(() {
              // Cập nhật UI nếu tab hiện tại là tab đang tải
            });
          }
        }
      });
    }
  }

  // Reset trạng thái tải (hữu ích khi cần refresh dữ liệu)
  void _resetDataLoading([int? tabIndex]) {
    if (tabIndex != null) {
      // Reset một tab cụ thể
      if (_dataLoadingCompleters[tabIndex].isCompleted) {
        _dataLoadingCompleters[tabIndex] = Completer<bool>();
      }
    } else {
      // Reset tất cả các tab
      for (int i = 0; i < _dataLoadingCompleters.length; i++) {
        if (_dataLoadingCompleters[i].isCompleted) {
          _dataLoadingCompleters[i] = Completer<bool>();
        }
      }
    }

    // Cập nhật tab hiện tại
    setState(() {
      _currentTabDataLoaded = _dataLoadingCompleters[controller!.index].future;
    });

    // Tải lại dữ liệu
    _loadDataForCurrentTab();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _currentTabDataLoaded,
      builder: (context, snapshot) {
        // Khi đang tải hoặc chưa có dữ liệu, hiển thị shimmer phù hợp
        if (!snapshot.hasData || snapshot.data != true) {
          return ShimmerMainTabView(
            initialIndex: controller?.index ?? 0,
            loadingDuration: const Duration(milliseconds: 1500),
          );
        }

        // Nếu đã tải xong, hiển thị nội dung thật
        return Scaffold(
          body: TabBarView(controller: controller, children: const [
            HomeView(),
            OrderView(),
            FavoritesView(),
            TopFoodieView(),
            MyProfileView()
          ]),
          bottomNavigationBar: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                ),
                child: TabBar(
                  controller: controller,
                  labelColor: Colors.orange,
                  labelPadding: EdgeInsets.zero,
                  unselectedLabelColor: TColor.gray,
                  labelStyle: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700),
                  indicatorColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  tabs: [
                    Tab(
                      icon: Image.asset(
                        "assets/img/home_tab.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                        color: controller?.index == 0
                            ? Colors.orange
                            : TColor.gray,
                      ),
                      text: "Trang chủ",
                    ),
                    Tab(
                      icon: Image.asset(
                        "assets/img/discovery_tab.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                        color: controller?.index == 1
                            ? Colors.orange
                            : TColor.gray,
                      ),
                      text: "Đơn hàng",
                    ),
                    Tab(
                      icon: Image.asset(
                        "assets/img/bookmark_tab.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                        color: controller?.index == 2
                            ? Colors.orange
                            : TColor.gray,
                      ),
                      text: "Yêu thích",
                    ),
                    Tab(
                      icon: Icon(
                        Icons.notification_add,
                        color: controller?.index == 3
                            ? Colors.orange
                            : TColor.gray,
                      ),
                      text: "Thông báo",
                    ),
                    Tab(
                      icon: Image.asset(
                        "assets/img/my_profile_tab.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                        color: controller?.index == 4
                            ? Colors.orange
                            : TColor.gray,
                      ),
                      text: "Tài khoản",
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          // Thêm nút refresh (tuỳ chọn)
          floatingActionButton: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.orange.withOpacity(0.8),
            child: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _resetDataLoading(controller!.index),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
