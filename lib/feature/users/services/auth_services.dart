import 'package:hive_flutter/hive_flutter.dart';
import 'package:virtual_assistant/feature/users/data/user_model.dart';

class AuthServices{
  Future<List<Users>> findUsersByName(String name) async {
    var userBox = await Hive.openBox<Users>('users');
    if(!userBox.isOpen){
      userBox = await Hive.openBox<Users>('users');
    }
    var users = userBox.values.where((element) => element.name == name).toList();
    return users;
  }

  //find user by email
  Future<List<Users>> findUsersByEmail(String email) async {
    var userBox = await Hive.openBox<Users>('users');
    if(!userBox.isOpen){
      userBox = await Hive.openBox<Users>('users');
    }
    var users = userBox.values.where((element) => element.email == email).toList();
    return users;
  }

  //create user
  Future<void> createUser(Users user) async {
    var userBox = await Hive.openBox<Users>('users');
    if(!userBox.isOpen){
      userBox = await Hive.openBox<Users>('users');
    }
    await userBox.put(user.id, user);
  }

  Future<Users?>findUsersById(String? id)async {
    var userBox = await Hive.openBox<Users>('users');
    if(!userBox.isOpen){
      userBox = await Hive.openBox<Users>('users');
    }
    var user = userBox.get(id);
    return user;
  }

  //update user

}