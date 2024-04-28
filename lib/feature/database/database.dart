import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtual_assistant/feature/home/data/chat_pair.dart';
import 'package:virtual_assistant/feature/users/data/user_model.dart';

class DatabaseServices {
  static Future<void> createDatabase() async {
    //get project directory
    var path = await getApplicationDocumentsDirectory();
    await Hive.initFlutter("${path.path}/database");
    Hive.registerAdapter(UsersAdapter());
    Hive.registerAdapter(ChatPairAdapter());
  }
}
