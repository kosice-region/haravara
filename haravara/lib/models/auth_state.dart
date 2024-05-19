class AuthState {
  final String code;
  final String? enteredUsername;
  final String? enteredEmail;
  final String userId;
  final bool isLogin;
  final bool isFamily;

  AuthState({
    this.code = '',
    this.enteredUsername,
    this.enteredEmail,
    this.userId = '',
    this.isLogin = false,
    this.isFamily = true,
  });

  AuthState copyWith({
    String? code,
    String? enteredUsername,
    String? enteredEmail,
    bool? isLogin,
    bool? isFamily,
  }) {
    return AuthState(
      code: code ?? this.code,
      enteredUsername: enteredUsername ?? this.enteredUsername,
      enteredEmail: enteredEmail ?? this.enteredEmail,
      isLogin: isLogin ?? this.isLogin,
      isFamily: isFamily ?? this.isFamily,
    );
  }
}
