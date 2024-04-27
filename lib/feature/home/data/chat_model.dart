import 'dart:convert';

import 'package:flutter/widgets.dart';

class ChatModel {
  String? id;
  String? name;
  String? message;
  String? type;
  int? time;
  ChatModel({
    this.id,
    this.name,
    this.message,
    this.type,
    this.time,
  });

  ChatModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? name,
    ValueGetter<String?>? message,
    ValueGetter<String?>? type,
    ValueGetter<int?>? time,
  }) {
    return ChatModel(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      message: message != null ? message() : this.message,
      type: type != null ? type() : this.type,
      time: time != null ? time() : this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'message': message,
      'type': type,
      'time': time,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      name: map['name'],
      message: map['message'],
      type: map['type'],
      time: map['time']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(id: $id, name: $name, message: $message, type: $type, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChatModel &&
      other.id == id &&
      other.name == name &&
      other.message == message &&
      other.type == type &&
      other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      message.hashCode ^
      type.hashCode ^
      time.hashCode;
  }
}
