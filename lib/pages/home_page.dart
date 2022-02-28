import 'package:flutter/material.dart';
import 'package:herewego/services/auth_service.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.red,
          onPressed: () {
            AuthService.signOutUser(context);
          },
          child: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16),),
        ),
      ),
    );
  }
}
