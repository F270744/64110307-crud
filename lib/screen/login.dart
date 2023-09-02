import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart'; // Import the email validator package
import 'package:flutter_application_15/model/users.dart';
import 'package:flutter_application_15/screen/home.dart';
import 'package:flutter_application_15/model/config.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static const routeName = "/login";
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  Users user = Users();

  Future<void> login(Users users) async {
  var params = {"email": user.email, "password": user.password};

  var url = Uri.http(Configure.server, "users", params);
  var resp = await http.get(url);
  print(resp.body);
  
  List<Users> login_result = usersFromJson(resp.body);
  print(login_result.length);
  if (login_result.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("username or password invalid")));
  } else {
    Configure.login = login_result[0];
    Navigator.pushNamed(context, Home.routeName);
    
  }
  return;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              emailInputField(),
              passwordInputField(),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  submitButton(),
                  SizedBox(width: 10.0,),
                  backButton(),
                  SizedBox(width: 10.0),
                  registerLink()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailInputField() {
    return TextFormField(
      initialValue: "fitree@mail.com", // Remove the extra colon
      decoration: InputDecoration(
        labelText: "Email:",
        icon: Icon(Icons.email), // Use Icons.email instead of Icon.email
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        if (!EmailValidator.validate(value)) {
          return "It is not an email format";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      initialValue: "000",
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password:",
        icon: Icon(Icons.lock), // Use Icons.lock instead of Icon.lock
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue!,
      // You should save the password value in a variable or do something with it here
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          print(user.toJson().toString());
          _formKey.currentState!.save();
          login(user);
          // Form is valid, you can perform further actions here
        }
      },
      child: Text("Login"),
    );
  }

  Widget backButton() {
    return ElevatedButton(
      onPressed: () {},
      child: Text("Back"));
  }

  Widget registerLink() {
    return InkWell(
      child: const Text("Sign Up"),
      onTap: () {
        // Implement the registration navigation or action
      },
    );
  }
}
