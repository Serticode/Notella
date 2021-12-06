import 'package:flutter/material.dart';
import 'package:notella/firebase/auth.dart';
import 'package:notella/models/user.dart';
import 'package:notella/utils/constants.dart';
import 'package:provider/provider.dart';

class UserLoggedIn extends StatelessWidget {
  UserLoggedIn({Key key}) : super(key: key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final MyUser _theLoggedInUser = Provider.of<MyUser>(context);
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
                  "${_theLoggedInUser.email}",
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
}
