class LoginResponse {
  final bool? error;
  final String? message;
  final LoginResult? loginResult;

  LoginResponse({
    this.error,
    this.message,
    this.loginResult,
  });

  LoginResponse copyWith({
    bool? error,
    String? message,
    LoginResult? loginResult,
  }) =>
      LoginResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        loginResult: loginResult ?? this.loginResult,
      );
}

class LoginResult {
  final String? userId;
  final String? name;
  final String? token;

  LoginResult({
    this.userId,
    this.name,
    this.token,
  });

  LoginResult copyWith({
    String? userId,
    String? name,
    String? token,
  }) =>
      LoginResult(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        token: token ?? this.token,
      );
}
