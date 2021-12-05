import 'package:flutter/material.dart';
import 'package:notella/models/note.dart';
import 'package:notella/screens/note_detail.dart';
import 'package:notella/screens/note_list.dart';
import 'package:notella/screens/recycleBin.dart';
import 'package:notella/screens/userProfile.dart';

class SwitchScreen extends StatelessWidget {
  final int pageIndex;
  const SwitchScreen({Key key, this.pageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return pageIndex == 0
        ? NoteList()
        : pageIndex == 1
            ? NoteDetail(Note('', '', 2), 'New Note')
            : pageIndex == 2
                ? RecycleBin()
                : pageIndex == 3
                    ? UserProfile()
                    : NoteList();
  }
}
