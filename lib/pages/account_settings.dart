import 'package:flutter/material.dart';
import 'package:herewego/services/auth_service.dart';

class AccountSettings extends StatefulWidget {
  static const String id = "account_settings_page";

  const AccountSettings({Key? key}) : super(key: key);

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Account Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: (){
                AuthService.deleteAccount(context);
              },
              child: const ListTile(
                leading: Icon(Icons.delete, color: Colors.red, size: 30,),
                title: Text("Delete account", style: TextStyle(fontSize: 20),),
                subtitle: Text("Delete your account and account data"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
