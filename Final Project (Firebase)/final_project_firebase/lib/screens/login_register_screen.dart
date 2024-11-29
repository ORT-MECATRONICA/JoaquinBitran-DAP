// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../core/data/auth.dart';

class LoginRegisterScreen extends StatefulWidget {
  static const String name = 'login_register';
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

// Error messages, Firebase thingies
class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  String? errorMessage = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      errorMessage = ""; // Reset the error message at the beginning
    });
    try {
      await Auth().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      context.go('/home');
      const successfulLogIn = SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Welcome'),
      );
      ScaffoldMessenger.of(context).showSnackBar(successfulLogIn);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // Create user function
  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      errorMessage = ""; // Reset the error message at the beginning
    });
    try {
      await Auth().createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Map<String, String> userData = {
        //Add the new User Data to the collection
        "Email": emailController.text,
        "Password": passwordController.text,
      };
      FirebaseFirestore.instance.collection("user").add(userData);
      context.pop();
      const successfulRegister = SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Registration successful'),
      );
      ScaffoldMessenger.of(context).showSnackBar(successfulRegister);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Login');
  }

  // Inputs
  Widget _entryField(
    String title,
    TextEditingController controller,
    Icon icon, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: icon,
      ),
    );
  }

  // Automated error message
  Widget _errorMessage() {
    return Text(
      errorMessage == "" ? "" : " $errorMessage ",
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 60, 60),
        fontFamily: 'OpenSans',
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Sign In button
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: signInWithEmailAndPassword,
      child: const Text("Login"),
    );
  }

  //Register Button
  Widget _registerButton() {
    return TextButton(
      onPressed: createUserWithEmailAndPassword,
      child: const Text("Register"),
    );
  }

  // Register window
Widget _registerWindow() {
  return TextButton(
    onPressed: () {
      // Show dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Register'),
            content: SizedBox(
              width: 820, 
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  _entryField(
                      "Enter Email", emailController, const Icon(Icons.person)),
                  const SizedBox(height: 30.0),
                  _entryField("Enter Password", passwordController,
                      const Icon(Icons.lock),
                      obscureText: true),
                  const SizedBox(height: 10.0),
                  _errorMessage(),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
            actions: [
              _registerButton(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
    child: const Text("Register Instead"),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color.fromRGBO(50, 40, 50, 0.5),
              Color.fromRGBO(100, 90, 100, 0.5),
              Color.fromRGBO(150, 140, 150, 0.5),
              Color.fromRGBO(200, 190, 200, 0.5),
            ])),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sign In',
                style: TextStyle(
                  color: Color.fromARGB(255, 60, 60, 60),
                  fontFamily: 'OpenSans',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _entryField(
                  "Enter Email", emailController, const Icon(Icons.person)),
              const SizedBox(height: 30.0),
              _entryField(
                  "Enter Password", passwordController, const Icon(Icons.lock),
                  obscureText: true),
              const SizedBox(height: 10.0),
              _errorMessage(),
              const SizedBox(height: 30.0),
              _submitButton(),
              const SizedBox(height: 10.0),
              _registerWindow(),
            ],
          ),
        ),
      ),
    );
  }
}
