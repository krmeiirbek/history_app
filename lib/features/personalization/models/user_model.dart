import '../../../utils/formatters/formatter.dart';

class UserModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String profilePicture;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.profilePicture,
  });

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
      );
}
