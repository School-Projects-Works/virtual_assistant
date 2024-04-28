// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_pair.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatPairAdapter extends TypeAdapter<ChatPair> {
  @override
  final int typeId = 1;

  @override
  ChatPair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatPair(
      user: (fields[1] as Map?)?.cast<String, dynamic>(),
      ai: (fields[2] as Map?)?.cast<String, dynamic>(),
      dateTime: fields[3] as int?,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, ChatPair obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.ai)
      ..writeByte(3)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatPairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
