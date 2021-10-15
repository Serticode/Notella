import 'package:flutter/material.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          widget = RecycleBin() ;
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
