import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notella/firebase/auth.dart';
import 'package:notella/firebase/userData.dart';
import 'package:notella/models/note.dart';
import 'package:notella/utils/constants.dart';
import 'package:notella/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

void _showSnackBar({BuildContext context, String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showLogin({BuildContext buildContext}) {
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
          title: Text("Log In"),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Container(
          padding: EdgeInsets.only(
            top: 30.0,
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

                  //SIGN IN BUTTON
                  SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.login_outlined,
                      size: 28,
                    ),
                    label: Text(
                      "Log In",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var result =
                            await _authService.signInWithEmailAndPassword(
                                email: email, password: password);

                        if (result != null) {
                          final Future<Database> dbFuture =
                              DatabaseHelper().initializeDatabase();

                          dbFuture.then((database) {
                            Future<List<Note>> noteListFuture =
                                DatabaseHelper().getNoteList();

                            noteListFuture.then((noteList) async {
                              String notesInJSON = jsonEncode(noteList);

                              DatabaseService(email: result.email)
                                  .updateUserData(
                                      userNoteListInJSON: notesInJSON);
                            });
                          });

                          Navigator.of(buildContext).pop();

                          _showSnackBar(
                              context: buildContext,
                              message: "Logged in successfully !");
                        } else {
                          _showSnackBar(
                              context: buildContext,
                              message:
                                  "Could not sign in with those credentials");
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
