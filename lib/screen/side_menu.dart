import 'package:flutter/material.dart';
import 'package:flutter_application_15/screen/home.dart';
import 'package:flutter_application_15/screen/login.dart';
import 'package:flutter_application_15/model/config.dart';
import 'package:flutter_application_15/model/users.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    String accountName = "N/A";
    String accountEmail = "N/A";
    String accountUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Cha_Eunwoo_Marie_Claire_Korea_2020_3.png/220px-Cha_Eunwoo_Marie_Claire_Korea_2020_3.png";

    Users user = Configure.login;
    if(user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(accountUrl),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home), // Use Icons.home instead of Icon.home
            title: Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, Home.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Login"),
            onTap: () {
              Navigator.pushNamed(context, Login.routeName);
            },
          )
          // Add more menu items as needed
        ],
      ),
    );
  }
}
