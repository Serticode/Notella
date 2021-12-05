//! BASIC DATA USED TO BUILD BOTTOM NAV BAR
import 'package:flutter/material.dart';

class SalomonBottomBarData {
  get theIcons => _icons;
  get theSelectedIconSize => _selectedIconSize;
  get theNavigationTitle => _navigationTitle;
  get theSelectionBackgroundColours => _selectionBackgroundColours;

  //!SALOMON NAV BAR ICONS
  final List<IconData> _icons = const [
    Icons.home_outlined,
    Icons.add_outlined,
    Icons.delete_outlined,
    Icons.person_outlined,
  ];

  //!SIZE OF SALOMON NAV BAR SELECTED ICON
  final double _selectedIconSize = 26.0;

  //!TITLE OF SALOMON NAV BAR ICON
  final List<String> _navigationTitle = const [
    "Notes List",
    "New Note",
    "Recycle Bin",
    "Profile"
  ];

  //!COLOUR OF SALOMON NAV BAR SELECTION BACKGROUND
  final Color _selectionBackgroundColours = Colors.blue.shade900;
}
