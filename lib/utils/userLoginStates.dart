import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notella/firebase/auth.dart';
import 'package:notella/firebase/userData.dart';
import 'package:notella/models/note.dart';
import 'package:notella/models/user.dart';
import 'package:notella/utils/constants.dart';
import 'package:notella/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget noUser({BuildContext buildContext}) {
  return Expanded(
    child: ListView(
      padding: EdgeInsets.only(
        bottom: 12.0,
        left: 10.0,
        right: 10.0,
      ),
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              "No user is logged in.",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ),

        SizedBox(
          height: 24.0,
        ),

        //!ELEVATED BUTTON
        ElevatedButton.icon(
          icon: Icon(
            Icons.create_outlined,
            size: 28,
          ),
          label: Text(
            "Create Account",
            style: elevatedButtonTextStyle,
          ),
          onPressed: () {
            showCreateAccount(buildContext: buildContext);
          },
          style: elevatedButtonStyle,
        ),
        SizedBox(
          height: 24.0,
        ),
        ElevatedButton.icon(
            icon: Icon(
              Icons.login_outlined,
              size: 28,
              color: Colors.blue.shade900,
            ),
            label: Text(
              "Log In",
              style: elevatedButtonTextStyle.copyWith(
                color: Colors.blue.shade900,
              ),
            ),
            onPressed: () {
              showLogin(buildContext: buildContext);
            },
            style: elevatedLoginButtonStyle),
      ],
    ),
  );
}

showLogin({BuildContext buildContext}) {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  MyUser _theUser;

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
                          Navigator.of(buildContext).pop();

                          final Future<Database> dbFuture =
                              DatabaseHelper().initializeDatabase();

                          dbFuture.then((database) {
                            Future<List<Note>> noteListFuture =
                                DatabaseHelper().getNoteList();

                            noteListFuture.then((noteList) async {
                              String notesInJSON = jsonEncode(noteList);

                              DatabaseService(email: _theUser.email)
                                  .updateUserData(
                                      userNoteListInJSON: notesInJSON);
                            });
                          });

                          _showSnackBar(
                              buildContext, "Logged in successfully !");
                        } else {
                          _showSnackBar(buildContext,
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

showCreateAccount({BuildContext buildContext}) {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  //MyUser _theUser;

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
                            _showSnackBar(buildContext,
                                "The provided password is weak !");
                          } else if (result == "email-already-in-use") {
                            _showSnackBar(
                                buildContext, "The account already exists.");
                          } else {
                            Navigator.of(buildContext).pop();
                            _showSnackBar(
                                buildContext, "User account created.");
                          }
                        } else {
                          _showSnackBar(buildContext,
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
/* 
_delete(BuildContext context, List<Note> theNotes) {
  theNotes.forEach((note) async {
    await RecycleBinHelper().deleteDeletedNote(note.id);
    print("NOTE ${note.id} DELETED");
  });
} */

Widget userLoggedIn({BuildContext buildContext, MyUser user}) {
  AuthService _auth = AuthService();
  return Expanded(
    child: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 5.0,
          ),
          child: Text(
            "Account Details",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              width: 2.0,
              color: Colors.blue.shade900,
            ),
          ),
          elevation: 10.0,
          shadowColor: Colors.grey.shade200.withOpacity(0.5),
          child: ListTile(
            contentPadding: EdgeInsets.all(15.0),
            title: Text(
              "Email: ",
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "${user.email}",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 24.0,
        ),

        //!ELEVATED BUTTON
        ElevatedButton(
          child: Text(
            "Log Out",
            style: elevatedButtonTextStyle,
          ),
          onPressed: () {
            _auth.signOut();
          },
          style: elevatedButtonStyle,
        ),
      ],
    ),
  );
}
