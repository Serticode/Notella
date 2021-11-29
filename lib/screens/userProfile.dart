import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notella/firebase/auth.dart';
import 'package:notella/firebase/storage.dart';
import 'package:notella/firebase/userData.dart';
import 'package:notella/models/pageTitle.dart';
import 'package:notella/models/user.dart';
import 'package:notella/utils/userProfilePic.dart';
import 'package:notella/utils/wrapper.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ProfilePicture _profilePicture = ProfilePicture();
  MyUser _theUser;
  File _pickedImage;
  String profilePictureDownloadURL;
  ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() async {
    _theUser = Provider.of<MyUser>(context);
    String theProfilePictureDownloadURL;
    _theUser != null
        ? theProfilePictureDownloadURL =
            await DatabaseService().listDownloadLinks(email: _theUser.email)
        : print("No User");

    setState(() {
      profilePictureDownloadURL = theProfilePictureDownloadURL;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: AuthService().user,
      initialData: MyUser(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TitleWidget(thePageTitle: "User Profile"),
            Divider(
              thickness: 3.0,
              color: Theme.of(context).accentColor,
              endIndent: MediaQuery.of(context).size.width / 2,
            ),
            Padding(
              padding: const EdgeInsets.all(42.0),
              child: GestureDetector(
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.shade900,
                    radius: MediaQuery.of(context).size.width / 3.7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        image: DecorationImage(
                          image: _theUser == null
                              ? _profilePicture.userImage
                              : _pickedImage != null
                                  ? FileImage(_pickedImage)
                                  : profilePictureDownloadURL != null
                                      ? NetworkImage(
                                          profilePictureDownloadURL,
                                        )
                                      : _profilePicture.userImage,
                          fit: BoxFit.contain,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  getProfilePicture().whenComplete(() async {
                    await StorageService()
                        .uploadImage(email: _theUser.email, file: _pickedImage);
                    _showSnackBar(context, "Profile Picture Changed !");
                  });
                },
              ),
            ),
            //!TEXT FIELDS
            Wrapper(),
          ],
        ),
      ),
    );
  }

  Future getProfilePicture() async {
    final _image = await _picker.getImage(source: ImageSource.gallery);
    _image != null
        ? setState(() {
            _pickedImage = File(_image.path);
          })
        : _showSnackBar(context, "No Image selected");
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
