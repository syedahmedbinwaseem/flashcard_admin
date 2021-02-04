import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class EditQuiz extends StatefulWidget {
  String title;
  String docId;

  EditQuiz({this.docId, this.title});
  @override
  _EditQuizState createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  TextEditingController textController = new TextEditingController();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    textController.text = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Dialog(
          insetPadding: EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: GlobalWidget.backGround(),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Form(
                  key: fKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Edit Title',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey[700],
                        ),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontFamily: 'Segoe'),
                          controller: textController,
                          validator: (input) {
                            return input.isEmpty ? 'Field is required!' : null;
                          },
                          textInputAction: TextInputAction.done,
                          cursorColor: Colors.grey[700],
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'Title',
                              hintStyle:
                                  TextStyle(fontFamily: 'Segoe', fontSize: 12)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                  Navigator.pop(context);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('quizzes')
                                      .doc(widget.docId)
                                      .update({
                                    'title': textController.text,
                                  });

                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    fontFamily: 'Segoe',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
