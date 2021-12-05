import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notella/firebase/auth.dart';
import 'package:notella/models/user.dart';
import 'package:notella/utils/appTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'constants/home.dart';
import 'constants/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme().fetchLightTheme,
              home: Splash(),
            );
          } else {
            return StreamProvider<MyUser>.value(
              value: AuthService().user,
              initialData: MyUser(),
              child: MaterialApp(
                title: 'Notella',
                debugShowCheckedModeBanner: false,
                theme: AppTheme().fetchLightTheme,
                home: Home(),
              ),
            );
          }
        });
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 7));
  }
}
