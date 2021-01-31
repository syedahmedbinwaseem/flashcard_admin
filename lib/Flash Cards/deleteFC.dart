import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class DeleteFC extends StatefulWidget {
  String sessionId;
  String readId;
  String fcId;

  DeleteFC({this.fcId, this.readId, this.sessionId});
  @override
  _DeleteFCState createState() => _DeleteFCState();
}

class _DeleteFCState extends State<DeleteFC> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Dialog(
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: GlobalWidget.backGround(),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Warning',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Are you sure you want to delete?',
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
                              Navigator.pop(context);
                              await FirebaseFirestore.instance
                                  .collection('level1')
                                  .doc(widget.sessionId)
                                  .collection('readings')
                                  .doc(widget.readId)
                                  .collection('flashcards')
                                  .doc(widget.fcId)
                                  .delete();
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontFamily: 'Segoe',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          )
                        ],
                      ))
                ],
              )),
        ));
  }
}
