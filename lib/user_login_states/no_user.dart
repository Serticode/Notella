import 'package:flutter/material.dart';
import 'package:notella/user_login_states/show_create_account.dart';
import 'package:notella/utils/constants.dart';
import 'show_log_in.dart';

class NoUser extends StatelessWidget {
  const NoUser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              showCreateAccount(buildContext: context);
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
                showLogin(buildContext: context);
              },
              style: elevatedLoginButtonStyle),
        ],
      ),
    );
  }
}
