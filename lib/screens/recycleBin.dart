import 'package:flutter/material.dart';
import 'package:notella/models/note.dart';
import 'package:notella/models/pageTitle.dart';
import 'package:notella/utils/recycleBin_helper.dart';
import 'package:notella/utils/widgets.dart';
import 'package:sqflite/sqflite.dart';

class RecycleBin extends StatefulWidget {
  @override
  _RecycleBinState createState() => _RecycleBinState();
}

class _RecycleBinState extends State<RecycleBin> {
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = [];
      updateListView();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TitleWidget(thePageTitle: "Recycle Bin"),
          Divider(
            thickness: 3.0,
            color: Theme.of(context).accentColor,
            endIndent: MediaQuery.of(context).size.width / 2,
          ),
          getDeletedNoteListView(),
        ],
      ),
    );
  }

  Widget getDeletedNoteListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  top: 5.0, left: 12.0, right: 12.0, bottom: 5.0),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.play_arrow,
                    color: getPriorityColor(this.noteList[position].priority),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    this.noteList[position].title == null
                        ? ""
                        : this.noteList[position].title.substring(
                                0,
                                this.noteList[position].title.length > 15
                                    ? 15
                                    : this.noteList[position].title.length) +
                            " ...",
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    this.noteList[position].date.toLowerCase(),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  this.noteList[position].description == null
                      ? ""
                      : this.noteList[position].description.substring(
                              0,
                              this.noteList[position].description.length > 100
                                  ? 100
                                  : this
                                      .noteList[position]
                                      .description
                                      .length) +
                          " ...",
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(
                      Icons.undo_outlined,
                      color: getPriorityColor(this.noteList[position].priority),
                    ),
                    onTap: () {
                      _showRestoreAlertDialog(
                        context,
                        alertTitle: "Restore Note",
                        note: noteList[position],
                        dialogueText: "Do you want to restore this note ?",
                      );
                    },
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.blue.shade900,
                    ),
                    onTap: () {
                      _showDeleteAlertDialog(
                        context,
                        alertTitle: "Delete Note Permanently",
                        note: noteList[position],
                        dialogueText:
                            "Do you want to permanently delete this note ?",
                      );
                    },
                  ),
                ],
              ),
              onTap: () {
                _showSnackBar(context,
                    message: "Not Allowed. You cannot open a deleted note");
              },
            ),
          );
        },
      ),
    );
  }

  //! Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.shade700;
        break;
      case 2:
        return Colors.yellow;
        break;
      case 3:
        return Colors.purple;
        break;
      case 4:
        return Colors.green;
        break;
      case 5:
        return Colors.blue.shade900;
        break;
      case 6:
        return Colors.blue.shade300;
        break;
      case 7:
        return Colors.amber;
        break;

      default:
        return Colors.yellow;
    }
  }

   _delete(BuildContext context, Note note) async {
    int result = await RecycleBinHelper().deleteDeletedNote(note.id);
    if (result != 0) {
      _showSnackBar(context,
          message: 'Note Permanently Deleted; Successfully !');
      updateListView();
    }
  }

  void _restore(BuildContext context, Note note) async {
    int result = await RecycleBinHelper().restoreDeletedNote(note.id);
    if (result != 0) {
      _showSnackBar(context, message: 'Note Restored Successfully !');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, {String message}) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showRestoreAlertDialog(BuildContext context,
      {String alertTitle, String dialogueText, Note note}) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        primary: Colors.white,
      ),
      child: Text(
        "Cancel",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        primary: Colors.white,
      ),
      child: Text(
        "Continue",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
        ),
      ),
      onPressed: () {
        _restore(context, note);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: Text(dialogueText),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showDeleteAlertDialog(BuildContext context,
      {String alertTitle,
      String dialogueText,
      Note note,
      }) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        primary: Colors.white,
      ),
      child: Text(
        "Cancel",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        primary: Colors.white,
      ),
      child: Text(
        "Continue",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade900,
        ),
      ),
      onPressed: () {
        _delete(context, note);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: Text(dialogueText),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = RecycleBinHelper().initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture =
          RecycleBinHelper().getDeletedNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
