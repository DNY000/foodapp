import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:foodapp/ultils/exception/firebase_exception.dart';
import 'package:foodapp/ultils/local_storage/storage_utilly.dart';
import 'package:foodapp/view/authentication/repository/authentication_repository.dart';
import 'package:foodapp/ultils/validators.dart';
import 'package:foodapp/viewmodels/user_viewmodel.dart';
import 'package:foodapp/ultils/exception/firebase_auth_exception.dart';
import 'package:foodapp/ultils/exception/platform_exception.dart';
import 'package:foodapp/ultils/exception/format_exception.dart';
import 'package:go_router/go_router.dart';

// GlobalKey cho navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LoginViewModel extends ChangeNotifier {
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final UserViewModel _userViewModel = UserViewModel();

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String _error = '';

  // Thêm callback để điều hướng từ View
  Function(String)? _navigationCallback;

  final TLocalStorage _localStorage = TLocalStorage.instance();
  bool _autoLogin = false;
  static const String KEY_USER_EMAIL = 'user_email';
  static const String KEY_PASSWORD_USER = 'password_user';

  bool get isLoading => _isLoading;
  String get error => _error;
  bool get autoLogin => _autoLogin;

  // Setter cho callback điều hướng
  set navigationCallback(Function(String) callback) {
    _navigationCallback = callback;
  }

  // Email validation
  String? validateEmail(String? value) => Validators.validateEmail(value);
  String? validatePassword(String? value) => Validators.validatePassword(value);

  /// -----------------------------
  /// Đăng nhập bằng email và mật khẩu
  /// -----------------------------
  ///

  Future<bool> loginWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) return false;

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final userCredential =
          await _authenticationRepository.signInWithEmailAndPassword(
        txtEmail.text.trim(),
        txtPassword.text,
      );

      if (userCredential.user != null) {
        // Lưu thông tin đăng nhập
        await _localStorage.saveData(KEY_USER_EMAIL, txtEmail.text);
        await _localStorage.saveData(KEY_PASSWORD_USER, txtPassword.text);
        await _localStorage.saveData("AUTO_LOGIN", true);
      }

      _isLoading = false;
      notifyListeners();

      // Sử dụng callback thay vì navigatorKey
      if (_navigationCallback != null) {
        _navigationCallback!('/main_tab');
      }

      return true;
    } on TFirebaseAuthException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } on TFirebaseException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } on TPlatformException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } on TFormatException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      // Đảm bảo thông báo lỗi không phải là một đối tượng
      _error = e.toString();
      if (_error.contains("Instance of ")) {
        _error = "Đã xảy ra lỗi không xác định. Vui lòng thử lại.";
      }
      notifyListeners();
      return false;
    }
  }

  Future<void> autoLoginUser() async {
    try {
      // Trên web, không nên tự động đăng nhập
      if (kIsWeb) {
        return;
      }

      final email = _localStorage.readData<String>(KEY_USER_EMAIL);
      final password = _localStorage.readData<String>(KEY_PASSWORD_USER);
      final shouldAutoLogin = _localStorage.readData<bool>("AUTO_LOGIN");

      // Kiểm tra null safety tốt hơn
      _autoLogin = shouldAutoLogin ?? false;

      if (email != null && password != null && _autoLogin) {
        txtEmail.text = email;
        txtPassword.text = password;
        await loginWithEmailAndPassword();
      }
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
      notifyListeners();
    } on TFirebaseException catch (e) {
      _error = e.message;
      notifyListeners();
    } on TPlatformException catch (e) {
      _error = e.message;
      notifyListeners();
    } on TFormatException catch (e) {
      _error = e.message;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// -----------------------------
  /// Đăng nhập bằng Google
  /// -----------------------------
  Future<bool> loginWithGoogle() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final userCredential = await _authenticationRepository.signInWithGoogle();

      _isLoading = false;

      if (userCredential == null) {
        _error = TPlatformException('sign_in_canceled').message;
        notifyListeners();
        return false;
      }

      _isLoading = true;
      notifyListeners();

      try {
        await _userViewModel.saveUser(userCredential);
        _isLoading = false;
        notifyListeners();

        // Sử dụng callback thay vì navigatorKey
        if (_navigationCallback != null) {
          _navigationCallback!('/main_tab');
        }

        return true;
      } on TFirebaseAuthException catch (e) {
        _error = e.message;
        _isLoading = false;
        notifyListeners();
        return false;
      } on TFirebaseException catch (e) {
        _error = e.message;
        _isLoading = false;
        notifyListeners();
        return false;
      } on TPlatformException catch (e) {
        _error = e.message;
        _isLoading = false;
        notifyListeners();
        return false;
      } on TFormatException catch (e) {
        _error = e.message;
        _isLoading = false;
        notifyListeners();
        return false;
      } catch (e) {
        _error = e.toString();
        if (_error.contains("Instance of ")) {
          _error =
              "Đã xảy ra lỗi không xác định khi lưu thông tin người dùng. Vui lòng thử lại.";
        }
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on TFirebaseAuthException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } on TFirebaseException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } on TPlatformException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } on TFormatException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      if (_error.contains("Instance of ")) {
        _error =
            "Đã xảy ra lỗi không xác định khi đăng nhập Google. Vui lòng thử lại.";
      }
      notifyListeners();
      return false;
    }
  }

  /// -----------------------------
  /// Đăng nhập bằng Facebook
  /// -----------------------------
  Future<void> loginWithFacebook() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final userCredential =
          await _authenticationRepository.signInWithFacebook();

      if (userCredential == null) {
        _error = TPlatformException('sign_in_canceled').message;
        notifyListeners();
        return;
      }

      await _saveUserFromFacebook(userCredential);

      _isLoading = false;
      notifyListeners();

      // Sử dụng callback thay vì navigatorKey
      if (_navigationCallback != null) {
        _navigationCallback!('/main_tab');
      }
    } on TFirebaseAuthException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      throw "$e.message";
    } on TFirebaseException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      throw "$e.message";
    } on TPlatformException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      throw "$e.message";
    } on TFormatException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      if (_error.contains("Instance of ")) {
        _error =
            "Đã xảy ra lỗi không xác định khi đăng nhập Facebook. Vui lòng thử lại.";
      }
      notifyListeners();
      throw "$e.message";
    }
  }

  /// -----------------------------
  /// Lưu thông tin người dùng từ Facebook
  /// -----------------------------
  Future<void> _saveUserFromFacebook(UserCredential credential) async {
    try {
      await _userViewModel.saveUser(credential);
    } on TFirebaseAuthException catch (e) {
      throw "$e.message";
    } on TFirebaseException catch (e) {
      throw "$e.message";
    } on TPlatformException catch (e) {
      throw "$e.message";
    } on TFormatException catch (e) {
      throw "$e.message";
    } catch (e) {
      throw "$e.message";
    }
  }

  /// -----------------------------
  /// Xoá thông tin trong các TextEditingControllers
  /// -----------------------------
  void clearControllers() {
    txtEmail.clear();
    txtPassword.clear();
    txtConfirmPassword.clear();
    phoneController.clear();
    otpController.clear();
    notifyListeners();
  }

  /// -----------------------------
  /// Đăng xuất
  /// -----------------------------
  Future<void> logOut() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await _authenticationRepository.logout();
      await _localStorage.saveData("AUTO_LOGIN", false);
      clearControllers();
      _error = '';

      // Đặt isLoading = false và thông báo TRƯỚC khi gọi callback
      _isLoading = false;
      notifyListeners();

      // Gọi callback sau khi đã cập nhật UI
      if (_navigationCallback != null) {
        _navigationCallback!('/login');
      }
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } on TFirebaseException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } on TPlatformException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } on TFormatException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
