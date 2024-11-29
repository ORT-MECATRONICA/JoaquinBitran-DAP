import 'package:final_project_firebase/core/data/auth.dart';
import 'package:final_project_firebase/screens/home_screen.dart';
import 'package:final_project_firebase/screens/login_register_screen.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

//If user is logged in, it redirects them to the Home Page, instead of the Login Screen
class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginRegisterScreen();
          }
        });
  }
}
