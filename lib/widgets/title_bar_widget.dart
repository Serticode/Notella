import 'package:flutter/material.dart';
import 'package:notella/firebase/userData.dart';
import 'package:notella/models/note.dart';
import 'package:notella/models/pageTitle.dart';
import 'package:notella/models/user.dart';
import 'package:notella/screens/editNote.dart';
import 'package:notella/utils/constants.dart';
import 'package:notella/utils/database_helper.dart';
import 'package:notella/utils/userProfilePic.dart';
import 'package:provider/provider.dart';

class TitleBarWidget extends StatefulWidget {
  final String pageTitle;
  final bool customTitleBar;
  TitleBarWidget({@required this.pageTitle, this.customTitleBar});
  @override
  _TitleBarWidgetState createState() => _TitleBarWidgetState();
}

class _TitleBarWidgetState extends State<TitleBarWidget> {
  MyUser _theUser;
  ProfilePicture _profilePicture = ProfilePicture();

  String profilePictureDownloadURL;

  ImageProvider _theImage(MyUser _theUser) {
    return _theUser == null
        ? _profilePicture.userImage
        : profilePictureDownloadURL != null && profilePictureDownloadURL != ""
            ? NetworkImage(profilePictureDownloadURL)
            : _profilePicture.userImage;
  }

  @override
  void didChangeDependencies() async {
    _theUser = Provider.of<MyUser>(context);
    String theProfilePictureDownloadURL;
    _theUser != null
        ? theProfilePictureDownloadURL =
            await DatabaseService(email: _theUser.email)
                .listDownloadLinks(email: _theUser.email)
        : debugPrint("No User");

    setState(() {
      profilePictureDownloadURL = theProfilePictureDownloadURL;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return widget.pageTitle == "User Profile"
        ? Container(
            height: _screenSize.height / 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TitleWidget(thePageTitle: this.widget.pageTitle),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 20,
                ),
              ],
            ),
          )
        : widget.customTitleBar == false
            ? Container(
                height: _screenSize.height / 7,
                margin: EdgeInsets.only(bottom: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TitleWidget(thePageTitle: this.widget.pageTitle),
                    Row(
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
                            radius: 32.0,
                            child: CircleAvatar(
                              radius: 28.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    image: DecorationImage(
                                      image: _theImage(_theUser),
                                      fit: BoxFit.contain,
                                    ),
                                    shape: BoxShape.circle),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              )
            : Container(
                height: _screenSize.height / 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TitleWidget(thePageTitle: this.widget.pageTitle),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                    CircleAvatar(
                        backgroundColor: Colors.blue.shade900,
                        radius: 30.0,
                        child: CircleAvatar(
                          radius: 28.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                image: DecorationImage(
                                  image: _theImage(_theUser),
                                  fit: BoxFit.contain,
                                ),
                                shape: BoxShape.circle),
                          ),
                        )),
                  ],
                ),
              );
  }
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
    var noteMapList = await DatabaseHelper().getNoteMapList();
    int count = noteMapList.length;
    this.count = count;

    List<Note> listOfNotes = [];

    for (int i = 0; i < count; i++) {
      listOfNotes.add(Note.fromMapObject(noteMapList[i]));
    }

    this.noteList.addAll(listOfNotes);
    return this.noteList;
  }
}
