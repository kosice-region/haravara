class AuthState {
  final String code;
  final String? enteredUsername;
  final String? enteredEmail;
  final String userId;
  final bool isLogin;

  AuthState({
    this.code = '',
    this.enteredUsername,
    this.enteredEmail,
    this.userId = '',
    this.isLogin = false,
  });

  // CopyWith method to create a new instance of AuthState with updated fields
  AuthState copyWith({
    String? code,
    String? enteredUsername,
    String? enteredEmail,
    bool? isLogin,
  }) {
    return AuthState(
      code: code ?? this.code,
      enteredUsername: enteredUsername ?? this.enteredUsername,
      enteredEmail: enteredEmail ?? this.enteredEmail,
      isLogin: isLogin ?? this.isLogin,
    );
  }
}
