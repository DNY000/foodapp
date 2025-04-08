import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodapp/common/color_extension.dart';
import 'package:foodapp/common_widget/login/other_login.dart';
import 'package:foodapp/common_widget/line_textfield.dart';
import 'package:foodapp/common_widget/round_button.dart';
import 'package:foodapp/view/authentication/viewmodel/login_viewmodel.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();

    // Gọi autoLogin sau khi frame được build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final viewModel = Provider.of<LoginViewModel>(context, listen: false);

        // Đặt callback điều hướng cho ViewModel
        viewModel.navigationCallback = (String route) {
          if (mounted) {
            context.go(route);
          }
        };

        viewModel.autoLoginUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: viewModel.formKey,
                  child: SizedBox(
                    width: media.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: media.width * 0.07),
                        Text(
                          "Food APP",
                          style: TextStyle(
                            color: TColor.text,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: media.width * 0.02),
                        Text(
                          "Đăng nhập để tiếp tục",
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: media.width * 0.07),
                        LineTextField(
                          controller: viewModel.txtEmail,
                          hitText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: viewModel.validateEmail,
                        ),
                        SizedBox(height: media.width * 0.07),
                        LineTextField(
                          controller: viewModel.txtPassword,
                          hitText: "Mật khẩu",
                          obscureText: true,
                          validator: viewModel.validatePassword,
                        ),
                        SizedBox(height: media.width * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (context.mounted) {
                                  context.push('/forgot-password');
                                }
                              },
                              child: const Text(
                                "Quên mật khẩu?",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: media.width * 0.04),
                        RoundButton(
                          title: viewModel.isLoading
                              ? "Đang xử lý..."
                              : "Đăng nhập",
                          onPressed: () async {
                            if (viewModel.isLoading) return;

                            // Luôn đặt callback điều hướng trước khi đăng nhập
                            viewModel.navigationCallback = (String route) {
                              if (mounted) {
                                context.go(route);
                              }
                            };

                            final success =
                                await viewModel.loginWithEmailAndPassword();

                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đăng nhập thành công!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (viewModel.error.isNotEmpty &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.error),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          type: RoundButtonType.primary,
                        ),
                        SizedBox(height: media.width * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Bạn chưa có tài khoản?",
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (context.mounted) {
                                  context.push('/signup');
                                }
                              },
                              child: const Text(
                                "Đăng ký",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const OtherLogin(color1: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
