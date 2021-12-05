import 'package:flutter/material.dart';
import 'package:notella/constants/salomon_bottom_bar_data.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'switch_screens.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

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
              left: 20.0,
              right: 20.0,
            ),
            child: SwitchScreen(pageIndex: _selectedIndex),
          ),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <SalomonBottomBarItem>[
            //!HOME
            SalomonBottomBarItem(
              icon: Icon(_bottomBarIcons[0]),
              activeIcon:
                  Icon(_bottomBarIcons[0], size: _bottomBarSelectedIconSize),
              title: Text(_bottomBarPageTitle[0]),
              selectedColor: _selectedBackgroundColour,
            ),

            //! NEW NOTE
            SalomonBottomBarItem(
              icon: Icon(_bottomBarIcons[1]),
              title: Text(_bottomBarPageTitle[1]),
              selectedColor: _selectedBackgroundColour,
            ),

            //! RECYCLE BIN
            SalomonBottomBarItem(
              icon: Icon(_bottomBarIcons[2]),
              title: Text(_bottomBarPageTitle[2]),
              selectedColor: _selectedBackgroundColour,
            ),

            //! USER PROFILE
            SalomonBottomBarItem(
              icon: Icon(_bottomBarIcons[3]),
              title: Text(_bottomBarPageTitle[3]),
              selectedColor: _selectedBackgroundColour,
            )
          ],
        ));
  }

  //!NEEDED GETTERS
  get _bottomBarIcons => SalomonBottomBarData().theIcons;
  get _bottomBarPageTitle => SalomonBottomBarData().theNavigationTitle;
  get _bottomBarSelectedIconSize => SalomonBottomBarData().theSelectedIconSize;
  get _selectedBackgroundColour =>
      SalomonBottomBarData().theSelectionBackgroundColours;
}
