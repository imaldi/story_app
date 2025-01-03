import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String? userId;
  final String? name;
  final String? token;
  final String? email;
  final String? password;

  User({
    this.userId,
    this.name,
    this.token,
    this.email,
    this.password,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    name,
    token,
    email,
    password
  ];

  User copyWith({
    String? userId,
    String? name,
    String? token,
    String? email,
    String? password,
  }) =>
      User(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        token: token ?? this.token,
        email: email ?? this.email,
        password: password ?? this.password,
      );


  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}