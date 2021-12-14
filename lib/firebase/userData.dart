import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notella/firebase/storage.dart';
import 'package:notella/models/note.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  final String uid;
  final String email;
  DatabaseService({this.uid, this.email});

  //!COLLECTION REFERENCE
  final userCollection = FirebaseFirestore.instance.collection("User Data");

  //!FUNCTION TO CONVERT ASSET IMAGE TO FILE
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file =
        File('${(await getTemporaryDirectory()).path}/default_user.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future updateUserData({
    String userNoteListInJSON,
  }) async {
    DocumentReference userReference = userCollection.doc(email);
    FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        try {
          DocumentSnapshot snapshot = await transaction.get(userReference);
          if (!snapshot.exists) {
            await userReference.set({
              "Notes ": jsonEncode(Note("", "", 2)),
            });

            //!CONVERT ASSET IMAGE TO FILE AND UPLOAD AS DEFAULT USER IMAGE.
            File defaultImage =
                await getImageFileFromAssets("images/default_user.png");

            await StorageService()
                .uploadImage(email: email, file: defaultImage);
          } else {
            if (userNoteListInJSON != null) {
              transaction.update(userReference, {"Notes ": userNoteListInJSON});
            }
          }
        } catch (e) {
          print("FIRESTORE TRANSACTION ERROR: $e");
        }
      },
    );
  }

  Future updateDownloadLinks({String imageDownloadLinks}) async {
    DocumentReference userReference =
        userCollection.doc("$email\_downloadLinks");
    FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        try {
          DocumentSnapshot snapshot = await transaction.get(userReference);
          if (!snapshot.exists) {
            userReference.set({"Image DownloadLinks ": imageDownloadLinks});
          } else {
            if (imageDownloadLinks != null) {
              snapshot.data().clear();

              transaction.update(
                  userReference, {"Image DownloadLinks ": imageDownloadLinks});
            }
          }
        } catch (e) {
          debugPrint("FIRESTORE TRANSACTION ERROR: $e");
        }
      },
    );
  }

  listDownloadLinks({String email}) async {
    String urls;
    Map<String, dynamic> _theUserData;

    final userCollection = FirebaseFirestore.instance.collection("User Data");
    DocumentReference downloadLinkRef =
        userCollection.doc("$email\_downloadLinks");

    downloadLinkRef.get();
    await downloadLinkRef.snapshots().first.then((value) async {
      try {
        _theUserData = value.data();
        urls = _theUserData.values.first;
      } catch (e) {
        debugPrint("DOWNLOAD LINK REF CAUGHT ERROR: $e ");
      }
    });

    return urls;
  }

  //!GET USER DOWNLOAD LINKS STREAM
  Stream<QuerySnapshot> get getDownloadLinks {
    final userDownloadCollection =
        FirebaseFirestore.instance.collection("$email\_downloadLinks");
    return userDownloadCollection.snapshots();
  }
}
