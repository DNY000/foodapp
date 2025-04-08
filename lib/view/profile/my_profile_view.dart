import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodapp/view/authentication/viewmodel/login_viewmodel.dart';
import 'package:foodapp/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:foodapp/models/user_model.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common_widget/menu_row.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  bool _isLoading = true;
  UserModel? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Lấy thông tin người dùng từ ViewModel
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);

      // Sử dụng dữ liệu người dùng hiện có nếu đã được tải
      if (userViewModel.user != null) {
        if (mounted) {
          setState(() {
            _userData = userViewModel.user;
            _isLoading = false;
          });
        }
        return;
      }

      // Nếu chưa có dữ liệu, thử lấy từ Firebase
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        // Sử dụng Future.microtask để tránh setState trong build
        await Future.microtask(() async {
          await userViewModel.fetchUser(userId);
          if (mounted) {
            setState(() {
              _userData = userViewModel.user;
              _isLoading = false;
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy userViewModel để kiểm tra lỗi
    final userViewModel = Provider.of<UserViewModel>(context);
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: TColor.primary,
              ),
            )
          : userViewModel.error.isNotEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Lỗi tải thông tin: ",
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: TColor.gray,
                            borderRadius: BorderRadius.circular(50),
                            image: _userData?.avatarUrl != null &&
                                    _userData!.avatarUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(_userData!.avatarUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                        ),
                        Text(
                          _userData?.name ?? "Người dùng",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 1)
                              ]),
                          child: Column(
                            children: [
                              MenuRow(
                                icon: "assets/img/payment.png",
                                title: "Quản lý phương thức thanh toán",
                                onPressed: () {},
                              ),
                              const Divider(
                                color: Colors.black26,
                                height: 1,
                              ),
                              MenuRow(
                                icon: "assets/img/find_friends.png",
                                title: "Tìm bạn bè",
                                onPressed: () {},
                              ),
                              const Divider(
                                color: Colors.black26,
                                height: 1,
                              ),
                              MenuRow(
                                icon: "assets/img/settings.png",
                                title: "Cài đặt",
                                onPressed: () {},
                              ),
                              const Divider(
                                color: Colors.black26,
                                height: 1,
                              ),
                              MenuRow(
                                icon: "assets/img/sign_out.png",
                                title: "Đăng xuất",
                                onPressed: () {
                                  _showLogoutConfirmation(context);
                                },
                              ),
                              const Divider(
                                color: Colors.black26,
                                height: 1,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                _performLogout(context);
              },
              child:
                  const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) async {
    final loginViewModel = context.read<LoginViewModel>();
    bool isNavigating = false;

    try {
      setState(() {
        _isLoading = true;
      });

      // Thiết lập callback điều hướng TRƯỚC khi gọi logout
      loginViewModel.navigationCallback = (String route) {
        if (mounted && !isNavigating) {
          isNavigating = true; // Đánh dấu để tránh điều hướng trùng lặp
          setState(() {
            _isLoading = false;
          });

          if (route == '/login') {
            // Sử dụng GoRouter thay vì Navigator để tránh xung đột
            Future.microtask(() {
              if (context.mounted) {
                context.go('/login');
              }
            });
          }
        }
      };

      // Gọi phương thức đăng xuất từ LoginViewModel
      await loginViewModel.logOut();

      // Nếu callback không được gọi (hiếm khi xảy ra), vẫn đảm bảo tắt loading
      if (mounted && !isNavigating) {
        setState(() {
          _isLoading = false;
        });

        // Đảm bảo điều hướng trong trường hợp callback không được gọi
        Future.microtask(() {
          if (context.mounted) {
            context.go('/login');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi đăng xuất: $e')),
        );
      }
    }
  }
}
