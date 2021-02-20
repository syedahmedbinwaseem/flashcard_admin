import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';

// ignore: must_be_immutable
class PublishSession extends StatefulWidget {
  String docId;

  PublishSession({this.docId});
  @override
  _PublishSessionState createState() => _PublishSessionState();
}

class _PublishSessionState extends State<PublishSession> {
  FToast fToast;

  bool isLoading = false;

  @override
  void initState() {
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
                    'Are you sure you want to publish the session?',
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
                                  .update({'published': true});

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
