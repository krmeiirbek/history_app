import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:history_app/utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  final String profilePicture;
  final double balance;
  final List<String> sandyq;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.balance,
    required this.sandyq,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "FirstName": firstName,
      "LastName": lastName,
      "Email": email,
      "Phone": phoneNumber,
      "ProfilePicture": profilePicture,
      "Balance": balance,
      "Sandyq": sandyq,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      firstName: json['FirstName'] as String? ?? '',
      lastName: json['LastName'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      phoneNumber: json['Phone'] as String? ?? '',
      profilePicture: json['ProfilePicture'] as String? ?? '',
      balance: json['Balance'] is String
          ? double.tryParse(json['Balance']) ?? 0.0
          : (json['Balance'] as double?) ?? 0.0,
      sandyq: (json['Sandyq'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
        balance: 0,
        sandyq: [],
      );

  static List<String> nameParts(fullName) => fullName.split(" ");

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['Phone'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        balance: _ensureDouble(data['Balance']),
        sandyq: (data['Sandyq'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
    } else {
      return UserModel.empty();
    }
  }

  static double _ensureDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0;
    }
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    double? balance,
    List<String>? sandyq,
  }) =>
      UserModel(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        profilePicture: profilePicture ?? this.profilePicture,
        balance: balance ?? this.balance,
        sandyq: sandyq ?? this.sandyq,
        id: id ?? this.id,
      );
}
