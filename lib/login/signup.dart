import 'package:flutter/material.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/login/login.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = "Signup";

   SignupScreen({Key? key}) : super(key: key);

   var emailController=TextEditingController();
   var userNamaController=TextEditingController();
   var passwordController=TextEditingController();
   var ageController=TextEditingController();
   var phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('SignUp Screen'),
      ),
      bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    children: [
                      TextSpan(text: "I have an Account ? "),
                      TextSpan(text: "Login ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          )),
                    ]
                )),
          )),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
             TextField(
               controller: userNamaController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
             TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
            ),
            const SizedBox(height: 16),
             TextField(
               controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
              ),
            ),
            const SizedBox(height: 16),
             TextField(
               controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {

                FirebaseFunctions.creatAccountAuth(
                    emailController.text, passwordController.text);
              },
              child: const Text('SignUp'),
            ),
          ],
        ),
      ),
    );
  }
}