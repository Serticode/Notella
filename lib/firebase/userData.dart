import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as _storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notella/models/note.dart';

class DatabaseService {
  final String uid;
  final String email;
  DatabaseService({this.uid, this.email});

  //!COLLECTION REFERENCE
  final userCollection = FirebaseFirestore.instance.collection("User Data");

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

            await updateDownloadLinks();
          } else {
            if (userNoteListInJSON != null) {
              //await snapshot.data().remove("Notes ");
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
            userReference.set({
              "Image DownloadLinks ": "",
            });
          } else {
            if (imageDownloadLinks != null) {
              snapshot.data().clear();

              transaction.update(
                  userReference, {"Image DownloadLinks ": imageDownloadLinks});
            } else {
              print("PASSED VALUE = 0 BLOCK GOT RUN !!!");
            }
          }
        } catch (e) {
          print("FIRESTORE TRANSACTION ERROR: $e");
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

    downloadLinkRef.get().catchError((theError) {
      debugPrint("DOCUMENT REF .GET() ERROR. \nERROR IS: $theError");
    });
    await downloadLinkRef.snapshots().first.then((value) async {
      try {
        _theUserData = value.data();
        urls = _theUserData.values.first;
      } catch (e) {
        print("DOWNLOAD LINK REF CAUGHT ERROR: $e ");
      }
    });

    return urls;
  }

  Future<Note> listUserBackedUpNotes({@required String email}) async {
    Map<String, dynamic> backedUpNotes;

    final userCollection = FirebaseFirestore.instance.collection("User Data");
    DocumentReference downloadLinkRef = userCollection.doc("$email");
    downloadLinkRef.get();

    await downloadLinkRef.snapshots().first.then((value) {
      backedUpNotes = value.data();
      debugPrint("DOCUMENTS ARE: $backedUpNotes ");
    });

    return Note.fromMapObject(backedUpNotes);
  }

  /* //!GET USER STREAM
  Stream<QuerySnapshot> get userData {
    return userCollection.snapshots();
  } */

  //!GET USER DOWNLOAD LINKS STREAM
  Stream<QuerySnapshot> get getDownloadLinks {
    final userDownloadCollection =
        FirebaseFirestore.instance.collection("$email\_downloadLinks");
    return userDownloadCollection.snapshots();
  }
}

/* class UserFolders {
  //!GET LIST OF FILES IN EACH NAMED DIRECTORY FOUND IN ROOT DIRECTORY

  Future<List<Reference>> listImagesFolderContent({String email}) async {
    //!IMAGES DIRECTORY
    _storage.ListResult imagesDirectoryResult =
        await _storage.FirebaseStorage.instance.ref("$email/Images").listAll();
    return imagesDirectoryResult.items;
  }
}
 */