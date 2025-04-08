import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/common/enum.dart';
import 'package:foodapp/ultils/fomatter/formatters.dart';

class UserModel {
  String id;
  String name;
  String? email;
  String lastname;
  String firstname;
  String phoneNumber;
  String avatarUrl;
  String token;
  String profilePicture;
  Role role;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.createdAt,
    required this.lastname,
    required this.firstname,
    required this.token,
    required this.profilePicture,
  });
  String get fullName => TFormatter.formatFullName(firstname, lastname);
  String get formatPhoneNumber => TFormatter.formatPhoneNumber(phoneNumber);
  static List<String> nameParts(String fullName) {
    if (fullName.isEmpty) {
      return ['User', '']; // Giá trị mặc định khi tên rỗng
    }

    List<String> parts = fullName.split(' ');
    if (parts.length == 1) {
      // Nếu chỉ có một phần (firstName), để lastName rỗng
      return [parts[0], ''];
    } else if (parts.length > 1) {
      // Lấy phần tử đầu tiên làm firstName
      String firstName = parts[0];
      // Nối các phần tử còn lại làm lastName
      String lastName = parts.sublist(1).join(' ');
      return [firstName, lastName];
    }

    return ['User', '']; // Fallback
  }

  static String generateUserName(String fullName) {
    if (fullName.isEmpty) {
      return 'cwt_user';
    }

    List<String> parts = fullName.split(' ');
    String firstName = parts[0].toLowerCase();
    String lastName = parts.length > 1 ? parts.last.toLowerCase() : '';

    if (firstName.isEmpty) {
      firstName = "user";
    }

    String camelCaseUserName =
        lastName.isEmpty ? firstName : '$firstName.$lastName';

    String usernameWithPrefix = 'cwt_$camelCaseUserName';
    return usernameWithPrefix;
  }

  // chuyen doi tu json sàng dart
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      role: Role.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => Role.user,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastname: data['lastname'] ?? '',
      firstname: data['firstname'] ?? '',
      token: data['token'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
    );
  }
// chuyen doi dart sang json
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'role': role.name,
      'createdAt': createdAt,
      'lastname': lastname,
      'firstname': firstname,
      'token': token,
      'profilePicture': profilePicture,
    };
  }
}
