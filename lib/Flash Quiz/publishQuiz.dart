import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/NotificationManager/pushNotificationManager.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class PublishQuiz extends StatefulWidget {
  String docId;

  PublishQuiz({this.docId});
  @override
  _PublishQuizState createState() => _PublishQuizState();
}

class _PublishQuizState extends State<PublishQuiz> {
  bool isLoading = false;
  int ansOptions = 0;
  int correctAns = 0;
  bool ansOption = false;
  bool correctAnss = false;
  FToast fToast;
  int numberOfQuestions;

  void checkValidity() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.docId)
        .collection('questions')
        .get();
    setState(() {
      numberOfQuestions = snap.docs.length;
    });

    //check if there are any answer options
    if (numberOfQuestions == 0) {
    } else {
      snap.docs.forEach((element) {
        if (element.data().containsKey('answer_options') &&
            element['answer_options'].length != 0) {
          setState(() {
            ansOptions++;
          });
        }
      });
      if (numberOfQuestions == ansOptions) {
        setState(() {
          ansOption = true;
        });
      }
    }

    //check if there is correct answer
    if (numberOfQuestions == 0) {
    } else {
      snap.docs.forEach((element) {
        if (element.data().containsKey('correct_answer')) {
          setState(() {
            correctAns++;
          });
        }
      });
      if (numberOfQuestions == correctAns) {
        setState(() {
          correctAnss = true;
        });
      }
    }
  }

  @override
  void initState() {
    checkValidity();
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
                    'Are you sure you want to publish the quiz?',
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
                              if (numberOfQuestions == 0) {
                                Navigator.pop(context);
                                fToast.showToast(
                                  child: ToastWidget.toast(
                                      'There must be at least 1 question in the quiz',
                                      Icon(Icons.error, size: 20)),
                                  toastDuration: Duration(seconds: 3),
                                  gravity: ToastGravity.BOTTOM,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              } else if (ansOption == false) {
                                Navigator.pop(context);
                                fToast.showToast(
                                  child: ToastWidget.toast(
                                      'Answer options of some questions is missing',
                                      Icon(Icons.error, size: 20)),
                                  toastDuration: Duration(seconds: 3),
                                  gravity: ToastGravity.BOTTOM,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              } else if (correctAnss == false) {
                                Navigator.pop(context);
                                fToast.showToast(
                                  child: ToastWidget.toast(
                                      'Correct answer of some questions is missing',
                                      Icon(Icons.error, size: 20)),
                                  toastDuration: Duration(seconds: 3),
                                  gravity: ToastGravity.BOTTOM,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                Navigator.pop(context);

                                await FirebaseFirestore.instance
                                    .collection('quizzes')
                                    .doc(widget.docId)
                                    .update({'published': true});

                                NotificationManager notificationManager =
                                    new NotificationManager();
                                notificationManager.sendAndRetrieveMessage(
                                    '',
                                    "New Quiz PUblished!",
                                    "CFA Nodal Trainer published new Quiz for you.");

                                fToast.showToast(
                                  child: ToastWidget.toast(
                                      'Published successfully',
                                      Icon(Icons.done, size: 20)),
                                  toastDuration: Duration(seconds: 3),
                                  gravity: ToastGravity.BOTTOM,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              }
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
