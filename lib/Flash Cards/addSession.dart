import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddSession extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddSessionState();
}

class AddSessionState extends State<AddSession>
    with SingleTickerProviderStateMixin {
  final sessionName = TextEditingController();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading;
  int totalSessions;

  void getTotalSessions() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('level1').get();
    setState(() {
      totalSessions = snap.docs.length;
    });
  }

  @override
  void initState() {
    isLoading = false;
    getTotalSessions();
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
                              'Add New Session',
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
                                controller: sessionName,
                                cursorColor: Colors.grey[700],
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: 'Session Title',
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
                                      sessionName.clear();
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
                                                  .doc();
                                          await doc.set({
                                            'created_at': Timestamp.now(),
                                            'id': doc.id,
                                            'title': sessionName.text,
                                            'index': totalSessions + 1
                                          });
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                            msg: "Something went wrong!",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
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
