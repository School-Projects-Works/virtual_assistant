import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class Users {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? password;
  Users({
     this.id,
     this.name,
     this.email,
     this.password,
  });

  Users copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? name,
    ValueGetter<String?>? email,
    ValueGetter<String?>? password,
  }) {
    return Users(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      email: email != null ? email() : this.email,
      password: password != null ? password() : this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Users(id: $id, name: $name, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Users &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ password.hashCode;
  }
}
