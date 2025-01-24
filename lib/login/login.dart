import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/login/signup.dart';
import 'package:todo_app/providers/my_provider.dart';

import '../firebase_functions.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "Login";

  LoginScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider= Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.pushNamed(context, SignupScreen.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(children: [
                  TextSpan(text: "Donot have an Account ? "),
                  TextSpan(
                      text: "Signup ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      )),
                ])),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FirebaseFunctions.loginUser(
                    emailController.text, passwordController.text,
                    onSuccess: (label) {
                      provider.initUser();
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, (rout) => false,
                      arguments: label);
                }, onError: (error) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Error"),
                      content: Text("error"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Okay!"))
                      ],
                    ),
                  );
                });
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
