import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notella/firebase/userData.dart';
import 'package:notella/models/note.dart';
import 'package:notella/models/user.dart';
import 'package:notella/screens/editNote.dart';
import 'package:notella/utils/database_helper.dart';
import 'package:notella/widgets/title_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  double _animatedMargin = 150.0;

  animateMargin() {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      setState(() {
        _animatedMargin = 0.0;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    animateMargin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleBarWidget(pageTitle: "Notes", customTitleBar: false),
          AnimatedContainer(
            duration: Duration(milliseconds: 700),
            curve: Curves.decelerate,
            margin: EdgeInsets.only(top: _animatedMargin),
          ),
          FetchNoteList(),
        ],
      ),
    );
  }
}

class FetchNoteList extends StatefulWidget {
  const FetchNoteList({Key key}) : super(key: key);

  @override
  _FetchNoteListState createState() => _FetchNoteListState();
}

class _FetchNoteListState extends State<FetchNoteList> {
  List<Note> noteList;
  int count = 0;

  @override
  void didChangeDependencies() {
    MyUser _user = Provider.of<MyUser>(context);

    if (_user != null) {
      if (noteList == null) {
        noteList = [];
        updateListView(buildContext: context);
      } else {
        updateListView(buildContext: context, userEmail: _user.email);
      }
    } else {
      updateListView(buildContext: context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = [];
      updateListView(buildContext: context);
    }
    return Expanded(
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(15.0),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.play_arrow,
                    color: getPriorityColor(this.noteList[position].priority),
                  ),
                  SizedBox(
                    width: 20.0,
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
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete_outline,
                  color: getPriorityColor(this.noteList[position].priority),
                ),
                onTap: () {
                  _delete(
                    context: context,
                    note: noteList[position],
                  );
                },
              ),
              onTap: () {
                navigateToDetail(
                    buildContext: context,
                    note: this.noteList[position],
                    title: 'Edit Note');
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

  void _delete({@required BuildContext context, @required Note note}) async {
    int result = await DatabaseHelper().deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(
          buildContext: context, message: 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(
      {@required BuildContext buildContext, @required String message}) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(
      {@required Note note,
      @required String title,
      @required BuildContext buildContext}) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditNote(
          theNote: note, appBarTitle: title); //NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView({BuildContext buildContext, String userEmail}) {
    final Future<Database> dbFuture = DatabaseHelper().initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = DatabaseHelper().getNoteList();
      noteListFuture.then((noteList) async {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;

          if (userEmail != null) {
            String notesInJSON = jsonEncode(noteList);
            DatabaseService(email: userEmail)
                .updateUserData(userNoteListInJSON: notesInJSON);
          }
        });
      });
    });
  }
}
