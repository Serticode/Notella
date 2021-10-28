import 'package:flutter/material.dart';
import 'package:notella/models/user.dart';
import 'package:notella/utils/userLoginStates.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _theUser = Provider.of<MyUser>(context, listen: true);

    //!Return User or No user
    return _theUser == null
        ? noUser(buildContext: context, )
        : userLoggedIn(buildContext: context, user: _theUser, );
  }
}
