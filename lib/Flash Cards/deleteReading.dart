import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class DeleteReading extends StatefulWidget {
  String sessionId;
  String readId;
  String title;

  DeleteReading({this.readId, this.sessionId, this.title});
  @override
  _DeleteReadingState createState() => _DeleteReadingState();
}

class _DeleteReadingState extends State<DeleteReading> {
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
                            await FirebaseFirestore.instance
                                .collection('level1')
                                .doc(widget.sessionId)
                                .collection('readings')
                                .doc(widget.readId)
                                .delete();
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
                                color: Colors.red),
                          ),
                        )
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
