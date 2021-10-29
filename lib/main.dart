import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notella/firebase/auth.dart';
import 'package:notella/models/note.dart';
import 'package:notella/models/user.dart';
import 'package:notella/screens/note_detail.dart';
import 'package:notella/screens/note_list.dart';
import 'package:notella/screens/recycleBin.dart';
import 'package:notella/screens/userProfile.dart';
import 'package:notella/utils/appTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

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
                home: Splash(),);
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

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(children: <Widget>[
          Expanded(
            flex: 3,
            child: Image.asset("images/noteTaker.png"),
          ),
          Expanded(
            flex: 1,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Notella.',
                  cursor: "|",
                  curve: Curves.bounceIn,
                  textStyle: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 45.0,
                    color: Color(0xFF616161),
                  ),
                  speed: const Duration(milliseconds: 300),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 50),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          )
        ]),
      ),
    );
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

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  void itemTapped(int index) {
    _HomeState()._onItemTapped(index);
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 0.0,
          ),
          child: Container(
            child: views(_selectedIndex),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_outlined,
            ),
            label: 'Add Note',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.delete_outline,
            ),
            label: 'Recycle Bin',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget views(int index) {
    Widget widget;
    switch (index) {
      case 0:
        setState(() {
          widget = NoteList();
        });
        break;
      case 1:
        setState(() {
          widget = NoteDetail(Note('', '', 2), 'New Note');
        });
        break;
      case 2:
        setState(() {
          widget = RecycleBin();
        });
        break;
      case 3:
        setState(() {
          widget = UserProfile();
        });
        break;
      default:
        NoteList();
    }
    return widget;
  }
}
