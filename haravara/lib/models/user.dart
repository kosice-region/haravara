
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
