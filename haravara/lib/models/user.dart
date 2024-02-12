class User {
  String? userId;
  String name;
  String? email;
  String? phoneNumber;
  List<String> phoneIds;

  User.regEmail(
      {required this.email, required this.phoneIds, required this.name});
  User.regPhoneNumber(
      {required this.phoneNumber, required this.phoneIds, required this.name});
  User(
      {required this.userId,
      required this.email,
      required this.phoneNumber,
      required this.phoneIds,
      required this.name});
}

class UserModel {
  final bool isLoggedIn;
  final String username;
  final String email;
  final String id;

  UserModel(
      {this.isLoggedIn = false,
      this.username = '',
      this.email = '',
      this.id = ''});
}
