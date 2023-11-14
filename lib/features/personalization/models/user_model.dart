import '../../../utils/formatters/formatter.dart';

class UserModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String profilePicture;
  final double balance;
  final List<String> sandyq;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.profilePicture,
    required this.balance,
    required this.sandyq,
  });

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? profilePicture,
    double? balance,
    List<String>? sandyq,
  }) =>
      UserModel(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
        profilePicture: profilePicture ?? this.profilePicture,
        balance: balance ?? this.balance,
        sandyq: sandyq ?? this.sandyq,
      );

  /// Helpers
  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static UserModel empty() => UserModel(
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        password: '',
        profilePicture: '',
        balance: 0,
        sandyq: [],
      );
}
