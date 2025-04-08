import 'package:flutter/material.dart';
import 'package:foodapp/common/color_extension.dart';
import 'package:provider/provider.dart';
import '../viewmodel/signup_viewmodel.dart';
import '../../../common_widget/line_textfield.dart';
import '../../../common_widget/round_button.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final viewModel = Provider.of<SignUpViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: viewModel.formKey,
            child: SizedBox(
              width: media.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: TColor.primary,
                      ),
                    ),
                  ),
                  Text(
                    "Welcome to\nCapi Restaurant",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: media.width * 0.02),
                  Text(
                    "Sign up to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: media.width * 0.07),

                  // First Name field
                  TextFormField(
                    controller: viewModel.txtFirstName,
                    decoration: InputDecoration(
                      labelText: 'Họ',
                      hintText: 'Nhập họ của bạn',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: viewModel.validateName,
                  ),
                  const SizedBox(height: 16),

                  // Last Name field
                  TextFormField(
                    controller: viewModel.txtLastName,
                    decoration: InputDecoration(
                      labelText: 'Tên',
                      hintText: 'Nhập tên của bạn',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: viewModel.validateName,
                  ),
                  const SizedBox(height: 16),

                  // Email TextField
                  LineTextField(
                    controller: viewModel.txtEmail,
                    hitText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: viewModel.validateEmail,
                  ),
                  SizedBox(height: media.width * 0.07),

                  // Mobile TextField
                  // LineTextField(
                  //   controller: viewModel.txtMobile,
                  //   hitText: "Mobile Number",
                  //   keyboardType: TextInputType.phone,
                  //   validator: viewModel.validatePhone,
                  // ),
                  SizedBox(height: media.width * 0.07),

                  // Password TextField
                  LineTextField(
                    controller: viewModel.txtPassword,
                    obscureText: true,
                    hitText: "Password",
                    validator: viewModel.validatePassword,
                  ),
                  SizedBox(height: media.width * 0.07),

                  // Confirm Password TextField
                  LineTextField(
                    controller: viewModel.txtConfirmPassword,
                    obscureText: true,
                    hitText: "Confirm Password",
                    validator: viewModel.validateConfirmPassword,
                  ),
                  SizedBox(height: media.width * 0.07),

                  // Error Message
                  if (viewModel.error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        viewModel.error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  SizedBox(height: media.width * 0.03),

                  // Signup Button
                  RoundButton(
                    title: viewModel.isLoading ? "Đang xử lý..." : "Signup",
                    onPressed: () async {
                      if (!viewModel.isLoading) {
                        // Kiểm tra loading state
                        if (viewModel.formKey.currentState!.validate()) {
                          await viewModel.signUpWithEmailAndPassword();
                          if (viewModel.error.isEmpty && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đăng ký thành công!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                    type: RoundButtonType.primary,
                  ),

                  SizedBox(height: media.width * 0.07),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Đã có tài khoản? ",
                        style: TextStyle(
                          color: TColor.gray,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
