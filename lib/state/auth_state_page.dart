import 'package:flutter/material.dart';
import 'package:sports_hub_ios/page/login_page.dart';
import 'package:sports_hub_ios/page/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin ? SignUpPage() : LoginPage();

  void toggle() => setState(() => isLogin = !isLogin);
}
