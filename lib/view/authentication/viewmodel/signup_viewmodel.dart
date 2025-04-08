import 'package:flutter/material.dart';
import 'package:foodapp/models/user_model.dart';
import 'package:foodapp/ultils/validators.dart';
import 'package:foodapp/view/authentication/repository/authentication_repository.dart';
import 'package:foodapp/ultils/exception/firebase_auth_exception.dart';
import 'package:foodapp/viewmodels/user_viewmodel.dart';
import 'package:foodapp/common/enum.dart';

class SignUpViewModel extends ChangeNotifier {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();
  final TextEditingController txtMobile = TextEditingController();
  final TextEditingController txtFirstName = TextEditingController();
  final TextEditingController txtLastName = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _error = '';
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isSuccess => _isSuccess;

  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final UserViewModel _userViewModel = UserViewModel();

  // Sử dụng validators từ class Validators
  String? validateEmail(String? value) => Validators.validateEmail(value);
  String? validatePassword(String? value) => Validators.validatePassword(value);
  String? validateConfirmPassword(String? value) =>
      Validators.validateConfirmPassword(value, txtPassword.text);
  String? validatePhone(String? value) => Validators.validatePhone(value);
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên không được để trống';
    }
    return null;
  }

  bool get isFormValid {
    return validateEmail(txtEmail.text) == null &&
        validatePassword(txtPassword.text) == null &&
        validateConfirmPassword(txtConfirmPassword.text) == null &&
        validatePhone(txtMobile.text) == null &&
        validateName(txtFirstName.text) == null &&
        validateName(txtLastName.text) == null;
  }

  Future<bool> signUpWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) return false;

    try {
      _isLoading = true;
      _error = '';
      _isSuccess = false;
      notifyListeners();

      // Đăng ký tài khoản mới
      final userCredential =
          await _authenticationRepository.registerEmailAndPassword(
        txtEmail.text.trim(),
        txtPassword.text,
      );

      // Kiểm tra nếu đăng ký thành công
      if (userCredential.user != null) {
        // Tạo đối tượng UserModel từ thông tin người dùng nhập
        final userModel = UserModel(
          id: userCredential.user!.uid,
          firstname: txtFirstName.text.trim(),
          lastname: txtLastName.text.trim(),
          name: "${txtFirstName.text.trim()} ${txtLastName.text.trim()}",
          email: txtEmail.text.trim(),
          role: Role.user,
          phoneNumber: txtMobile.text.trim(),
          avatarUrl: '',
          createdAt: DateTime.now(),
          token: userCredential.user!.uid,
          profilePicture: '',
        );

        // Lưu thông tin người dùng vào Firestore
        await _userViewModel.saveUser(userCredential);

        // Đánh dấu đăng ký thành công
        _isSuccess = true;

        // Xóa form sau khi đăng ký thành công
        clearForm();
      }

      return _isSuccess;
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Đăng ký thất bại: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa form
  void clearForm() {
    txtEmail.clear();
    txtPassword.clear();
    txtConfirmPassword.clear();
    txtMobile.clear();
    txtFirstName.clear();
    txtLastName.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    txtMobile.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    super.dispose();
  }
}
