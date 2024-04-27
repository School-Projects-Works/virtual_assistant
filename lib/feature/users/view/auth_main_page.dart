import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_assistant/feature/main/main_page.dart';
import 'package:virtual_assistant/feature/users/data/user_model.dart';
import 'package:virtual_assistant/feature/users/provider/auth_provider.dart';
import 'package:virtual_assistant/feature/users/services/auth_services.dart';
import 'package:virtual_assistant/generated/assets.dart';
import 'package:virtual_assistant/utils/pallet.dart';

class AuthMainPage extends ConsumerStatefulWidget {
  const AuthMainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthMainPageState();
}

class _AuthMainPageState extends ConsumerState<AuthMainPage> {
  final _formKey = GlobalKey<FormState>();

  Future<Users> getUser() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('user');
    if(id == null){
      return Users();
    }
    var user = await AuthServices().findUsersById(id);
    return user!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Users>(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred'));
            }
            if (snapshot.hasData && snapshot.data != null&& snapshot.data!.id != null) {
              var user = snapshot.data;
              //check if widget is finished loading
              if (user != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(authProvider.notifier).setUser(user);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (Route<dynamic> route) => false,
                  );
                });
              }
            }
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: ZoomIn(
                        child: Image.asset(Assets.imagesPALogo, height: 70)),
                  ),
                  const SizedBox(height: 20),
                  //tab bar
                  const Text('Enter the following details to continue',
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallet.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(height: 20),
                  //username
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        ref.read(authProvider.notifier).setName(value);
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter your username',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        ref.read(authProvider.notifier).setEmail(value!);
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        ref.read(authProvider.notifier).setPassword(value!);
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //continue button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallet.mainFontColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                ref.read(authProvider.notifier).createUser(
                                    ref: ref,
                                    context: context,
                                    formKey: _formKey);
                              }
                            },
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
