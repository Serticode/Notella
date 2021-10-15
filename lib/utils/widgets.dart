import 'package:flutter/material.dart';
import 'package:notella/models/note.dart';
import 'package:notella/models/user.dart';
import 'package:notella/screens/editNote.dart';
import 'package:notella/utils/constants.dart';
import 'package:notella/utils/database_helper.dart';
import 'package:notella/utils/userProfilePic.dart';
import 'package:provider/provider.dart';

class FirstWidget extends StatefulWidget {
  @override
  _FirstWidgetState createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {
  MyUser _theUser;
  ProfilePicture _profilePicture = ProfilePicture();

  String profilePictureDownloadURL;

  @override
  void didChangeDependencies() async {
    _theUser = Provider.of<MyUser>(context, listen: false);
    String theProfilePictureDownloadURL;
    _theUser != null
        ? theProfilePictureDownloadURL = await _profilePicture
            .getTheUserProfilePicture(theBuildContext: context)
        : print("No User");

    setState(() {
      profilePictureDownloadURL = theProfilePictureDownloadURL;
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _profilePicture.getTheUserProfilePicture(theBuildContext: context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextField(
            onTap: () {
              showSearch(
                context: context,
                delegate: Search(),
              );
            },
            decoration: textFormFieldStyle.copyWith(
              prefixIcon: Icon(
                Icons.search_outlined,
                size: 25.0,
                color: Colors.grey.shade700,
              ),
              hintText: "search notes",
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        ),
        CircleAvatar(
          backgroundColor: Colors.blue.shade900,
          radius: 30.0,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).canvasColor,
            backgroundImage: _theUser == null
                ? _profilePicture.userImage
                : profilePictureDownloadURL != null
                    ? NetworkImage(
                        profilePictureDownloadURL,
                      )
                    : _profilePicture.userImage,
            radius: 28.0,
          ),
        ),
      ],
    );
  }
}

Widget titleWidget({@required String pageTitle}) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 12.0,
      bottom: 12.0,
    ),
    child: Text(
      pageTitle,
      style: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade700,
      ),
    ),
  );
}

class Search extends SearchDelegate {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  Note selectedResult;
  int count;
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.cancel_outlined,
          color: Colors.blue.shade900,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_outlined,
        color: Colors.blue.shade900,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        FocusScope.of(context).unfocus();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, left: 30.0, right: 30.0, bottom: 5.0),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Note> suggestionList = List.empty(growable: true);
    try {
      if (noteList == null) {
        noteList = [];
        getNoteList();
      }

      query.isEmpty
          ? suggestionList = []
          : noteList.forEach((element) {
              if (element.title.toLowerCase().contains(query)) {
                suggestionList.add(element);
              }
            });
    } catch (e) {
      print(e);
    }

    return ListView.builder(
        itemCount: suggestionList.length == null ? 0 : suggestionList.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(15.0),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    suggestionList[position].title,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    this.noteList[position].date.toLowerCase(),
                  ),
                ],
              ),
              onTap: () {
                navigateToDetail(
                  note: suggestionList[position],
                  title: 'Edit Note',
                  buildContext: context,
                );
              },
            ),
          );
        });
  }

  void navigateToDetail(
      {@required Note note,
      @required String title,
      @required BuildContext buildContext}) async {
    await Navigator.push(buildContext,
        MaterialPageRoute(builder: (buildContext) {
      return EditNote(theNote: note, appBarTitle: title);
    }));
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList =
        await DatabaseHelper().getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table
    this.count = count;

    List<Note> listOfNotes = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      listOfNotes.add(Note.fromMapObject(noteMapList[i]));
    }

    this.noteList.addAll(
        listOfNotes);
    return this.noteList;
  }
}
