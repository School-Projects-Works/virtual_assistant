import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_assistant/core/views/custom_dialog.dart';
import 'package:virtual_assistant/feature/main/main_page.dart';
import 'package:virtual_assistant/feature/users/data/user_model.dart';
import 'package:virtual_assistant/feature/users/services/auth_services.dart';

final authProvider =
    StateNotifierProvider<AuthProvider, Users>((ref) => AuthProvider());

class AuthProvider extends StateNotifier<Users> {
  AuthProvider() : super(Users());

  void setEmail(String email) {
    state = state.copyWith(email: () => email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: () => password);
  }

  void createUser(
      {required WidgetRef ref,
      required BuildContext context,
      required GlobalKey<FormState> formKey}) async {
    CustomDialog.showLoading(message: 'Finding User.....');
    var services = AuthServices();
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // find user by name
    List<Users> users = [];
    users = await services.findUsersByName(state.name!);
    if (users.isEmpty) {
      users = await services.findUsersByEmail(state.email!);
    }
    if (users.isNotEmpty) {
      //check if email and password is correct
      var user = users
          .where((element) =>
              element.email == state.email &&
              element.password == state.password)
          .firstOrNull;
      if (user != null) {
        await prefs.setString('user', user.id!);
        state = user;
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
          message: 'Welcome ${user.name}',
        );
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        // ask youser if wants to create new account
        CustomDialog.dismiss();
        CustomDialog.showInfo(
            message: 'Do you want to create new account?',
            buttonText: 'Create',
            onPressed: () {
              createNewUser(ref: ref, context: context, formKey: formKey);
            });
      }
    } else {
      // ask youser if wants to create new account
      CustomDialog.dismiss();
      CustomDialog.showInfo(
          message: 'Do you want to create new account?',
          buttonText: 'Create',
          onPressed: () {
            createNewUser(ref: ref, context: context, formKey: formKey);
          });
    }
  }

  void setName(String? value) {
    state = state.copyWith(name: () => value);
  }

  void createNewUser(
      {required WidgetRef ref,
      required BuildContext context,
      required GlobalKey<FormState> formKey}) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Creating User.....');
     // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var services = AuthServices();
    var user = Users(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: state.name,
      email: state.email,
      password: state.password,
    );
    await services.createUser(user);
    CustomDialog.dismiss();
    CustomDialog.showSuccess(
      message: 'Welcome ${user.name}',
    );
     await prefs.setString('user', user.id!);
    state = user;
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void setUser(Users user) {
    state = user;
  }
}
