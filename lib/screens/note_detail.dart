import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:notella/models/note.dart';
import 'package:notella/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:notella/widgets/title_bar_widget.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  final List<String> _priorities = [
    'High',
    'Low',
    'Ambition',
    'Emotions',
    'Intelligence',
    'Confidence',
    'Energy'
  ];

  final List<Color> _choiceChipColour = [
    Colors.red.shade700,
    Colors.yellow,
    Colors.purple,
    Colors.green,
    Colors.blue.shade900,
    Colors.blue.shade300,
    Colors.amber,
  ];

  int selectedChip = 1;
  Color selectedChipColour = Colors.yellow;

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    TextStyle textStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade700,
    );

    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TitleBarWidget(pageTitle: this.appBarTitle, customTitleBar: true),

            //! CHOICE CHIPS
            Container(
                height: _screenSize.height / 14,
                margin: EdgeInsets.only(bottom: 10.0),
                child: ChipsChoice<int>.single(
                  value: this.appBarTitle == "Edit Note"
                      ? this.note.priority - 1
                      : selectedChip,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  onChanged: (value) {
                    setState(() {
                      selectedChip = value;
                      selectedChipColour = _choiceChipColour[value];
                      updatePriorityAsInt(_priorities[value]);
                    });
                  },
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: _priorities,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                  choiceStyle: C2ChoiceStyle(
                    padding: EdgeInsets.all(12.0),
                    borderColor: Colors.grey.shade700,
                    borderWidth: 1.4,
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  choiceActiveStyle: C2ChoiceStyle(
                    borderWidth: 1.8,
                    color: this.appBarTitle == "Edit Note"
                        ? _choiceChipColour[this.note.priority - 1]
                        : selectedChipColour, //selectedChipColour,
                    borderColor: _choiceChipColour[this.note.priority - 1],
                  ),
                )),

            //! NOTE TITLE
            Text(
              "Title.",
              style: textStyle.copyWith(
                  color: Colors.blue.shade900, fontSize: 20.0),
            ),
            Container(
              height: _screenSize.height / 8,
              margin: EdgeInsets.only(top: 5.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                style: textStyle.copyWith(
                  fontSize: 16,
                ),
                onChanged: (value) {
                  updateTitle();
                },
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade900,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            //! WRITE NOTE
            Text(
              "Description. ",
              style: textStyle.copyWith(
                  color: Colors.blue.shade900, fontSize: 20.0),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child:
                    //! DESCRIPTION
                    TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: descriptionController,
                  style: textStyle.copyWith(
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.shade900,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 10.0, right: 10.0),
              child: widget.appBarTitle == "Edit Note"
                  ? Center(
                      child: GestureDetector(
                        child: CircleAvatar(
                          radius: 24.0,
                          backgroundColor: Colors.blue.shade900,
                          child: Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          _save(context: context);
                          Navigator.pop(context);
                        },
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          child: CircleAvatar(
                            radius: 24.0,
                            backgroundColor: Colors.blue.shade900,
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            _delete();
                          },
                        ),
                        InkWell(
                          child: CircleAvatar(
                            radius: 24.0,
                            backgroundColor: Colors.blue.shade900,
                            child: Icon(
                              Icons.save_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            _save(context: context);
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //! Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        setState(() {
          note.priority = 1;
        });
        break;
      case 'Low':
        setState(() {
          note.priority = 2;
        });
        break;
      case 'Ambition':
        setState(() {
          note.priority = 3;
        });
        break;
      case 'Emotions':
        setState(() {
          note.priority = 4;
        });
        break;
      case 'Intelligence':
        setState(() {
          note.priority = 5;
        });
        break;
      case 'Confidence':
        setState(() {
          note.priority = 6;
        });
        break;
      case 'Energy':
        setState(() {
          note.priority = 7;
        });
        break;
    }
  }

  //! Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        setState(() {
          priority = _priorities[0]; // 'High'
        });
        break;
      case 2:
        setState(() {
          priority = _priorities[1]; // 'Low'
        });
        break;
      case 3:
        setState(() {
          priority = _priorities[2]; // ''Ambition',
        });
        break;
      case 4:
        setState(() {
          priority = _priorities[3]; // 'Emotions'
        });
        break;
      case 5:
        setState(() {
          priority = _priorities[4]; // 'Intelligence'
        });
        break;
      case 6:
        setState(() {
          priority = _priorities[5]; // 'Confidence'
        });
        break;
      case 7:
        setState(() {
          priority = _priorities[6]; // 'Energy'
        });
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  void resetTextFields() {
    titleController.text = "";
    descriptionController.text = "";
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save({
    BuildContext context,
  }) async {
    resetTextFields();

    initializeDateFormatting();
    DateTime now = DateTime.now();
    var dateString = DateFormat('dd/MM/yyyy').format(now);

    note.date = dateString;
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showSnackBarNotification('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showSnackBarNotification('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    resetTextFields();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showSnackBarNotification('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBarNotification('Status', 'Note Deleted Successfully');
    } else {
      _showSnackBarNotification('Status', 'Error Occurred while Deleting Note');
    }
  }

  void _showSnackBarNotification(String title, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
