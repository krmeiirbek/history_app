class UserModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNo;
  final String password;

  const UserModel(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.email,
      required this.phoneNo,
      required this.password});

  toJson() {
    return {
      "Name": userName,
      "Email": email,
      "Phone": phoneNo,
      "Password": password
    };
  }
}
