import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/common/enum.dart';
import 'package:foodapp/models/user_model.dart';
import 'package:foodapp/repositories/user_repository.dart';
import 'package:foodapp/ultils/exception/firebase_exception.dart';
import 'package:foodapp/ultils/exception/firebase_auth_exception.dart';
import 'package:foodapp/ultils/exception/format_exception.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  UserModel? _user;
  UserModel? get user => _user;
  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;

  // Lấy thông tin người dùng
  Future<void> fetchUser(String id) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _user = await _userRepository.getUser(id);
    } on TFirebaseException catch (e) {
      _error = e.message;
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
    } on TFormatException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã xảy ra lỗi không xác định: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lưu thông tin người dùng
  Future<void> saveUser(UserCredential? user) async {
    try {
      // if (kDebugMode) {
      //   print("=== Bắt đầu lưu thông tin người dùng ===");
      //   print("User null? ${user == null}");
      // }

      notifyListeners();
      if (user != null) {
        // if (kDebugMode) {
        //   print("UID: ${user.user?.uid}");
        //   print("DisplayName: ${user.user?.displayName}");
        //   print("Email: ${user.user?.email}");
        //   print("PhoneNumber: ${user.user?.phoneNumber}");
        // }

        final namePart = UserModel.nameParts(user.user!.displayName ?? "");

        final username =
            UserModel.generateUserName(user.user!.displayName ?? '');

        final userModel = UserModel(
          id: user.user!.uid,
          firstname: namePart[0],
          lastname: namePart[1],
          name: username,
          email: user.user!.email ?? '',
          role: Role.user,
          phoneNumber: user.user!.phoneNumber ?? '',
          avatarUrl: user.user!.photoURL ?? '',
          createdAt: DateTime.now(),
          token: user.user!.uid,
          profilePicture: user.user!.photoURL ?? '',
        );

        await _userRepository.saveUser(userModel);
      } else {}
    } on TFirebaseException catch (e) {
      _error = e.message;
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
    } on TFormatException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi lưu thông tin: $e';
    }
  }

  // Cập nhật thông tin người dùng
  Future<bool> updateUser(String id, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await _userRepository.updateUser(id, data);

      // Cập nhật lại thông tin người dùng nếu đang hiển thị
      if (_user != null && _user!.id == id) {
        await fetchUser(id);
      }

      return true;
    } on TFirebaseException catch (e) {
      _error = e.message;
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
    } on TFormatException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi cập nhật thông tin: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Xóa người dùng
  Future<bool> deleteUser(String id) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      await _userRepository.deleteUser(id);

      // Nếu đang hiển thị người dùng bị xóa, cần xóa tham chiếu
      if (_user != null && _user!.id == id) {
        _user = null;
      }

      return true;
    } on TFirebaseException catch (e) {
      _error = e.message;
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
    } on TFormatException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi xóa người dùng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Kiểm tra người dùng tồn tại
  Future<bool> checkUserExists(String id) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      bool exists = await _userRepository.checkUserExists(id);
      return exists;
    } on TFirebaseException catch (e) {
      _error = e.message;
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
    } on TFormatException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi kiểm tra người dùng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Lấy tất cả người dùng
  Future<List<UserModel>> getAllUsers() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      return await _userRepository.getAllUsers();
    } on TFirebaseException catch (e) {
      _error = e.message;
    } on TFirebaseAuthException catch (e) {
      _error = e.message;
    } on TFormatException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã xảy ra lỗi khi lấy danh sách người dùng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return [];
  }

  // Xóa lỗi
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Xóa dữ liệu người dùng đang hiển thị
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
