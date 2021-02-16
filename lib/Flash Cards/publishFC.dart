import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/NotificationManager/pushNotificationManager.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';

class PublishFC extends StatefulWidget {
  String docId;
  String readId;
  String fcId;

  PublishFC({this.docId, this.readId, this.fcId});
  @override
  _PublishFCState createState() => _PublishFCState();
}

class _PublishFCState extends State<PublishFC> {
  bool isLoading = false;
  FToast fToast;

  String sessionName;
  String readingName;
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

  @override
  void initState() {
    _getSessionReading();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Dialog(
          insetPadding: EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: GlobalWidget.backGround(),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Publish',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Are you sure you want to publish the flash card?',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            minWidth: 30,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontFamily: 'Segoe',
                              ),
                            ),
                          ),
                          FlatButton(
                            minWidth: 30,
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              await FirebaseFirestore.instance
                                  .collection('level1')
                                  .doc(widget.docId)
                                  .collection('readings')
                                  .doc(widget.readId)
                                  .collection('flashcards')
                                  .doc(widget.fcId)
                                  .update({'published': true});

                              NotificationManager notificationManager =
                                  new NotificationManager();
                              notificationManager.sendAndRetrieveMessage(
                                  '',
                                  "New Flashcard added",
                                  "CFA Nodal Trainer added new Flashcard in Session \'$sessionName\' under Reading \'$readingName\'.");
                              fToast.showToast(
                                child: ToastWidget.toast(
                                    'Published successfully',
                                    Icon(Icons.done, size: 20)),
                                toastDuration: Duration(seconds: 3),
                                gravity: ToastGravity.BOTTOM,
                              );
                              Navigator.pop(context);

                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontFamily: 'Segoe',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}

class ToastWidget {
  static toast(String s, Icon icon) {}
}
