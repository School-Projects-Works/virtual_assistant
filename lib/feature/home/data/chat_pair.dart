import 'package:hive_flutter/hive_flutter.dart';


part 'chat_pair.g.dart';
@HiveType(typeId: 1)
class ChatPair {
  @HiveField(0)
  String? id;
  @HiveField(1)
  Map<String, dynamic>? user;
  @HiveField(2)
  Map<String, dynamic>? ai;
  @HiveField(3)
  int? dateTime;
  ChatPair({
    this.user,
    this.ai,
    this.dateTime,
  });
}
