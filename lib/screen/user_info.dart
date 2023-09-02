import 'package:flutter/material.dart';
import 'package:flutter_application_15/model/users.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    var users = ModalRoute.of(context)!.settings.arguments as Users;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Card(
          child: ListView(
            children: [
              ListTile(title: Text("Full Name"), subtitle: Text("${users.fullname}"),),
              ListTile(title: Text("Email"), subtitle: Text("${users.email}"),),
              ListTile(title: Text("Gender"), subtitle: Text("${users.gender}"),)
            ],
          ),
        ),
      ),
    );
  }
}
