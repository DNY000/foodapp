import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodapp/models/user_model.dart';
import 'package:foodapp/ultils/exception/firebase_exception.dart';
import 'package:foodapp/ultils/exception/format_exception.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    try {
      if (kDebugMode) {
        print("Gọi đến Firestore để lưu user: ${user.id}");
      }

      // Chuyển đổi userModel.toMap() thành dữ liệu phù hợp với Firestore
      Map<String, dynamic> userData = user.toMap();

      // Chuyển DateTime thành Timestamp cho Firestore
      userData['createdAt'] = Timestamp.fromDate(user.createdAt);

      if (kDebugMode) {
        print("Dữ liệu sẽ lưu vào Firestore: $userData");
      }

      // Sử dụng SetOptions(merge: true) để không ghi đè dữ liệu đã có
      await _firestore
          .collection("users")
          .doc(user.id)
          .set(userData, SetOptions(merge: true));

      if (kDebugMode) {
        print("Đã lưu dữ liệu user thành công!");
        // Kiểm tra xem user đã thực sự được lưu chưa
        final docSnapshot =
            await _firestore.collection("users").doc(user.id).get();
        print("User tồn tại trong database: ${docSnapshot.exists}");
        if (docSnapshot.exists) {
          print("Dữ liệu user hiện tại: ${docSnapshot.data()}");
        }
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("FirebaseException khi lưu user: ${e.code} - ${e.message}");
      }
      throw TFirebaseException(e.code);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định khi lưu user: $e");
      }
      throw TFormatException('Lỗi khi lưu thông tin người dùng: $e');
    }
  }

  Future<UserModel> getUser(String id) async {
    try {
      final snapshot = await _firestore.collection('users').doc(id).get();

      if (!snapshot.exists) {
        throw TFirebaseException('not-found');
      }

      return UserModel.fromMap(snapshot.data() ?? {}, snapshot.id);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code);
    } catch (e) {
      throw TFormatException('Lỗi khi lấy thông tin người dùng: $e');
    }
  }

  Future<bool> checkUserExists(String id) async {
    try {
      final snapshot = await _firestore.collection('users').doc(id).get();
      return snapshot.exists;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code);
    } catch (e) {
      throw TFormatException('Lỗi khi kiểm tra người dùng: $e');
    }
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(id).update(data);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code);
    } catch (e) {
      throw TFormatException('Lỗi khi cập nhật thông tin người dùng: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code);
    } catch (e) {
      throw TFormatException('Lỗi khi xóa thông tin người dùng: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code);
    } catch (e) {
      throw TFormatException('Lỗi khi lấy danh sách người dùng: $e');
    }
  }
}
