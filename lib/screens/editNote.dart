import 'package:flutter/material.dart';
import 'package:notella/models/note.dart';
import 'package:notella/screens/note_detail.dart';

class EditNote extends StatefulWidget {
  final Note theNote;
  final String appBarTitle;
  EditNote({this.theNote, this.appBarTitle});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: NoteDetail(widget.theNote, widget.appBarTitle),
        ),
      ),
    );
  }
}
