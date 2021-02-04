import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/NotificationManager/pushNotificationManager.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ignore: must_be_immutable
class AddFC extends StatefulWidget {
  String docId;
  String readId;
  AddFC({this.docId, this.readId});
  @override
  State<StatefulWidget> createState() => AddFCState();
}

class AddFCState extends State<AddFC> with SingleTickerProviderStateMixin {
  final fcName = TextEditingController();
  final fcBody = TextEditingController();
  final picker = ImagePicker();
  File _image;
  FToast fToast;
  bool added = false;
  String imagePath;

  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading;
  String sessionName;
  String readingName;

  @override
  void initState() {
    _getSessionReading();
    isLoading = false;
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Future uploadFile() async {
    if (_image == null) {
    } else {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('FC-Images/${Timestamp.now().toString()}');
        UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.whenComplete(() async {
          await storageReference.getDownloadURL().then((value) {
            imagePath = value;
          });
        });
        print('File Uploaded');
      } catch (e) {
        print("Error is");
        print(e);

        Fluttertoast.showToast(
          msg: 'not',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 15,
        );
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          added = true;
        });
      } else {
        fToast.showToast(
          child: ToastWidget.toast(
              'Cannot add image', Icon(Icons.error, size: 20)),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Center(
          child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Form(
                  key: fKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    child: Container(
                        decoration: GlobalWidget.backGround(),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Add New Flashcard',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Theme(
                              data: new ThemeData(
                                primaryColor: Colors.grey[700],
                              ),
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (input) {
                                  return input.isEmpty
                                      ? "Field required"
                                      : null;
                                },
                                textInputAction: TextInputAction.next,
                                style: TextStyle(fontFamily: 'Segoe'),
                                controller: fcName,
                                cursorColor: Colors.grey[700],
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: 'Flashcard Title',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Segoe', fontSize: 12)),
                              ),
                            ),
                            Theme(
                              data: new ThemeData(
                                primaryColor: Colors.grey[700],
                              ),
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (input) {
                                  return input.isEmpty
                                      ? "Field required"
                                      : null;
                                },
                                maxLines: 5,
                                style: TextStyle(fontFamily: 'Segoe'),
                                controller: fcBody,
                                cursorColor: Colors.grey[700],
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: 'Flashcard Body',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Segoe', fontSize: 12)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                getImage();
                              },
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: buttonColor1,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: added == false
                                              ? Text(
                                                  'Select primary image',
                                                  style: TextStyle(
                                                      fontFamily: 'Segoe',
                                                      fontSize: 13),
                                                )
                                              : Text(
                                                  'Image added',
                                                  style: TextStyle(
                                                      fontFamily: 'Segoe',
                                                      fontSize: 13),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(right: 10),
                                        child: added == false
                                            ? Icon(
                                                Icons.add_a_photo_outlined,
                                                size: 23,
                                              )
                                            : Icon(Icons.done)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                    minWidth: 40,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      fcName.clear();
                                      fcBody.clear();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontFamily: 'Segoe',
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    minWidth: 40,
                                    onPressed: () async {
                                      if (fKey.currentState.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        await uploadFile().then((value) async {
                                          try {
                                            DocumentReference doc =
                                                FirebaseFirestore.instance
                                                    .collection('level1')
                                                    .doc(widget.docId)
                                                    .collection('readings')
                                                    .doc(widget.readId)
                                                    .collection('flashcards')
                                                    .doc();
                                            await doc.set({
                                              'created_at': Timestamp.now(),
                                              'id': doc.id,
                                              'title': fcName.text,
                                              'body': fcBody.text,
                                              'img_link': imagePath == null ||
                                                      imagePath == ''
                                                  ? null
                                                  : imagePath
                                            });
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                              msg: "Something went wrong!",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 3,
                                              backgroundColor: buttonColor1,
                                              textColor: Colors.white,
                                              fontSize: 15,
                                            );
                                          }
                                        });

                                        NotificationManager
                                            notificationManager =
                                            new NotificationManager();
                                        notificationManager.sendAndRetrieveMessage(
                                            '',
                                            "New Flashcard added",
                                            "CFA Nodal Trainer added new Flashcard in Session \'$sessionName\' under Reading \'$readingName\'.");

                                        Fluttertoast.showToast(
                                          msg:
                                              "Successfully Added new FlashCard!",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: buttonColor1,
                                          textColor: Colors.white,
                                          fontSize: 15,
                                        );
                                        Navigator.pop(context);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                          fontFamily: 'Segoe',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ))),
    );
  }

  _getSessionReading() async {
    DocumentSnapshot sessionSnap = await FirebaseFirestore.instance
        .collection('level1')
        .doc(widget.docId)
        .get();
    DocumentSnapshot readingSnap = await FirebaseFirestore.instance
        .collection('level1')
        .doc(widget.docId)
        .collection('readings')
        .doc(widget.readId)
        .get();

    sessionName = sessionSnap.data()['title'];
    readingName = readingSnap.data()['title'];
  }

  String validateFields(String input) {
    if (input.isEmpty) {
      return "Field Required!";
    } else {
      return null;
    }
  }
}
