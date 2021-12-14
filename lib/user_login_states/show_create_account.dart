import 'package:flutter/material.dart';
import 'package:notella/firebase/auth.dart';
import 'package:notella/utils/constants.dart';

void _showSnackBar({BuildContext context, String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showCreateAccount({BuildContext buildContext}) {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  //TEXT FIELD STATE
  String email = "";
  String password = "";

  showModalBottomSheet(
    context: buildContext,
    builder: (buildContext) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Create Account"),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Container(
          padding: EdgeInsets.only(
            top: 15.0,
            left: 5.0,
            right: 5.0,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30.0,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: textFormFieldStyle.copyWith(
                      hintText: "sample@sample.com",
                      contentPadding: EdgeInsets.all(18.0),
                    ),
                    validator: (value) =>
                        !value.contains("@") ? "Enter a valid Email" : null,
                    onChanged: (value) {
                      email = value;
                    },
                  ),

                  //FOR PASSWORD
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    decoration: textFormFieldStyle.copyWith(
                        hintText: "Your Password",
                        contentPadding: EdgeInsets.all(18.0)),
                    validator: (value) => value.length < 6
                        ? "Enter a password at least 6 characters long"
                        : null,
                    obscureText: true,
                    obscuringCharacter: "*",
                    onChanged: (value) {
                      password = value;
                    },
                  ),

                  SizedBox(
                    height: 30.0,
                  ),

                  TextFormField(
                    decoration: textFormFieldStyle.copyWith(
                        hintText: "Reenter Password",
                        contentPadding: EdgeInsets.all(18.0)),
                    validator: (value) =>
                        value != password ? "Passwords do not match" : null,
                    obscureText: true,
                    obscuringCharacter: "*",
                    onChanged: (value) {},
                  ),

                  //CREATE ACCOUNT BUTTON
                  SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.create_outlined,
                      size: 28,
                    ),
                    label: Text(
                      "Create Account",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var result =
                            await _authService.registerWithEmailAndPassword(
                                email: email, password: password);

                        if (result != null) {
                          if (result == "weak-password") {
                            _showSnackBar(
                                context: buildContext,
                                message: "The provided password is weak !");
                          } else if (result == "email-already-in-use") {
                            _showSnackBar(
                                context: buildContext,
                                message: "The account already exists.");
                          } else {
                            Navigator.of(buildContext).pop();
                            _showSnackBar(
                                context: buildContext,
                                message: "User account created.");
                          }
                        } else {
                          _showSnackBar(
                              context: buildContext,
                              message:
                                  "Apologies, the account could not be created.");
                        }
                      }
                    },
                    style: elevatedButtonStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
