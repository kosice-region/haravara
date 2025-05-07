
class AuthState {
  final String code;
  final String? enteredUsername;
  final String? enteredEmail;
  final String? location;
  final String userId;
  final bool isLogin;
  final bool isFamily;
  final bool isNeedToRemeber;
  final int? children;

  AuthState({
    this.code = '',
    this.enteredUsername,
    this.enteredEmail,
    this.location,
    this.userId = '',
    this.isLogin = false,
    this.isFamily = true,
    this.isNeedToRemeber = false,
    this.children = 0,
  });

  AuthState copyWith({
    String? code,
    String? enteredUsername,
    String? enteredEmail,
    String? location,
    bool? isLogin,
    bool? isFamily,
    bool? isNeedToRemeber,
    int? children,
  }) {
    return AuthState(
      code: code ?? this.code,
      enteredUsername: enteredUsername ?? this.enteredUsername,
      enteredEmail: enteredEmail ?? this.enteredEmail,
      location: location ?? this.location,
      isLogin: isLogin ?? this.isLogin,
      isFamily: isFamily ?? this.isFamily,
      isNeedToRemeber: isNeedToRemeber ?? this.isNeedToRemeber,
      children: children ?? this.children,
    );
  }

  @override
  String toString() {
    return 'AuthState(code: $code, enteredUsername: $enteredUsername, location: $location, enteredEmail: $enteredEmail, userId: $userId, isLogin: $isLogin, isFamily: $isFamily, children: $children)';
  }
}
