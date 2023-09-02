import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_application_15/model/config.dart';
import 'package:flutter_application_15/model/users.dart';
import 'package:flutter_application_15/screen/home.dart';
import 'package:http/http.dart' as http;

class UserForm extends StatefulWidget {
  const UserForm({super.key});
  
  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formkey = GlobalKey<FormState>();
  late Users users;


  Future<void> addNewUser(users) async{
    var url = Uri.http(Configure.server, "users");
    var resp = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(users.toJson()));
    var rs = usersFromJson("[${resp.body}]");

    if (rs.length == 1) {
      Navigator.pop(context);
    }
    return;
  }

  Future<void> updateData(users) async {
    var url = Uri.http(Configure.server, "users/${users.id}");
    var resp = await http.put(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(users.toJson()));
      var rs = usersFromJson("[${resp.body}]");
      if (rs.length == 1) {
        Navigator.pop(context, "refresh");
      }
  }

  //Users user = Users();
  @override
  Widget build(BuildContext context) {
    try {
      users = ModalRoute.of(context)!.settings.arguments as Users;
      print(users.fullname);
    } catch (e) {
      users = Users();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Form"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fnameInputField(),
              emailInputField(),
              passwordInputField(),
              genderInputField(),
              SizedBox(
                height: 10,
              ),
              submitButton(),
            ],
          ),
          ),
      ),
    );
  }

  Widget fnameInputField() {
    return TextFormField(
      initialValue: users.fullname,
      decoration: 
      InputDecoration(
        labelText: "Fullname:",
        icon: Icon(Icons.person),
        ),
    validator: (value) {
      if (value!.isEmpty) {
        return "This field is required";
      }
      return null;
    },
    onSaved: (newValue) => users.fullname = newValue,
    );
  }

    Widget emailInputField() {
      return TextFormField(
        initialValue: users.email,
        decoration: InputDecoration(
          labelText: "Email:",
          icon: Icon(Icons.email)
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "This field is required";
          }
          return null;
        },
        onSaved: (newValue) => users.email = newValue,
      );
    }

    Widget passwordInputField() {
      return TextFormField(
        initialValue: users.password,
        decoration: InputDecoration(
          labelText: "Password:",
          icon: Icon(Icons.lock)
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "This field is required";
          }
          return null;
        },
        onSaved: (newValue) => users.password = newValue,
      );
    }

    Widget genderInputField() {
      var initGen = "None";
      try {
        if (!users.gender!.isNull)
        initGen = users.gender!;
      } catch (e) {
        initGen = "None";
      }

      return DropdownButtonFormField(
        decoration:
          InputDecoration(labelText: "Gender:", icon: Icon(Icons.man)),
        value: "None",
        items: Configure.gender.map((String val) {
          return DropdownMenuItem(
            value: val,
            child:  Text(val),
            );
        }).toList(),
        onChanged: (value) {
          users.gender = value;
        },
        onSaved: (newValue) => users.gender);
    }

  Widget submitButton() {
      return ElevatedButton(
        onPressed: () async {
        if(_formkey.currentState!.validate()){
          _formkey.currentState!.save();
          print(users.toJson().toString());
          //addNewUser(user);
          if (users.id == null){
          await addNewUser(users);   
        } else {
          await updateData(users);
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
      }
    }, 
    child: Text("Save"),
  );
  }
    
}