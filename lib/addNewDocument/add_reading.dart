import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class AddReading extends StatefulWidget {
  String docId;

  AddReading({this.docId});
  @override
  State<StatefulWidget> createState() => AddReadingState();
}

class AddReadingState extends State<AddReading>
    with SingleTickerProviderStateMixin {
  final readingName = TextEditingController();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
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
                              'Add New Reading',
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
                                style: TextStyle(fontFamily: 'Segoe'),
                                controller: readingName,
                                cursorColor: Colors.grey[700],
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: 'Reading Title',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Segoe', fontSize: 12)),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      readingName.clear();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontFamily: 'Segoe',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  GestureDetector(
                                    onTap: () async {
                                      if (fKey.currentState.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          DocumentReference doc =
                                              FirebaseFirestore.instance
                                                  .collection('level1')
                                                  .doc(widget.docId)
                                                  .collection('readings')
                                                  .doc();
                                          await doc.set({
                                            'created_at': Timestamp.now(),
                                            'id': doc.id,
                                            'title': readingName.text
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

  String validateFields(String input) {
    if (input.isEmpty) {
      return "Field Required!";
    } else {
      return null;
    }
  }
}
