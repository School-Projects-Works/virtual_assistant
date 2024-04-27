import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:virtual_assistant/feature/users/view/auth_main_page.dart';
import 'package:virtual_assistant/utils/pallet.dart';
import 'feature/database/database.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseServices.createDatabase();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Virtual Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallet.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallet.whiteColor,
        ),
      ),
      home: const AuthMainPage(),
      builder: FlutterSmartDialog.init(),
    );
  }
}
