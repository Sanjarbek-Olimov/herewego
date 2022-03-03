import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/account_settings.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/sign_in_page.dart';
import 'package:herewego/pages/sign_up_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage(){
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            HiveDB.storeUid(snapshot.data!.uid);
            return HomePage(user: FirebaseAuth.instance.currentUser!);
          } else {
            HiveDB.removeUid();
            return const SignInPage();
          }
        });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireBase Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _startPage(),
      routes: {
        AccountSettings.id: (context) => const AccountSettings(),
        SignUpPage.id: (context) => const SignUpPage(),
        SignInPage.id: (context) => const SignInPage(),
      },
    );
  }
}
