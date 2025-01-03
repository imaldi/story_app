import 'package:story_app/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool? error;
  final String? message;
  final User? loginResult;

  LoginResponse({
    this.error,
    this.message,
    this.loginResult,
  });

  LoginResponse copyWith({
    bool? error,
    String? message,
    User? loginResult,
  }) =>
      LoginResponse(
        error: error ?? this.error,
        message: message ?? this.message,
        loginResult: loginResult ?? this.loginResult,
      );

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
