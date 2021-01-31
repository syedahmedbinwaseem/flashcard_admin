import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/Flash%20Quiz/addQuiz.dart';
import 'package:flashcard_admin/Flash%20Quiz/deleteQuiz.dart';
import 'package:flashcard_admin/Flash%20Quiz/editQuiz.dart';
import 'package:flashcard_admin/Flash%20Quiz/publishQuiz.dart';
import 'package:flashcard_admin/NotificationManager/pushNotificationManager.dart';
import 'package:flashcard_admin/screens/quizDetails.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FlashQuiz extends StatefulWidget {
  @override
  _FlashQuizState createState() => _FlashQuizState();
}

class _FlashQuizState extends State<FlashQuiz> {
  List<DocumentSnapshot> quiz = List<DocumentSnapshot>();
  FToast fToast;
  bool isLoading = false;
  void getQuizzes() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('quizzes')
        .orderBy('created_at', descending: true)
        .get();
    snap.docs.forEach((element) {
      setState(() {
        quiz.add(element);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getQuizzes();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor2,
        child: Center(child: Icon(Icons.add)),
        onPressed: () {
          addQuiz();
        },
      ),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              buttonColor2,
              buttonColor1,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Flash Quiz',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: quiz.length == 0
          ? Container(
              decoration: GlobalWidget.backGround(),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(blueTextColor),
                ),
              ))
          : ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Container(
                decoration: GlobalWidget.backGround(),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('quizzes')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.data == null
                        ? Container(
                            decoration: GlobalWidget.backGround(),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    blueTextColor),
                              ),
                            ))
                        : ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   load = true;
                                      // });
                                      // getQ(result[index].id).then((_) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => QuizDetails(
                                                    snap: snapshot
                                                        .data.docs[index].id,
                                                    title: snapshot.data
                                                        .docs[index]['title'],
                                                  )));
                                    },
                                    child: Container(
                                      height: 80,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: snapshot.data.docs[index]
                                                    ['published'] ==
                                                true
                                            ? buttonColor2
                                            : buttonColor1,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 20),
                                          CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 20,
                                            child: Image.asset(
                                                'assets/images/ask.png'),
                                          ),
                                          SizedBox(width: 15),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data.docs[index]
                                                      ['title'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  snapshot
                                                          .data
                                                          .docs[index]
                                                              ['created_at']
                                                          .toDate()
                                                          .year
                                                          .toString() +
                                                      '-' +
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['created_at']
                                                          .toDate()
                                                          .month
                                                          .toString() +
                                                      '-' +
                                                      snapshot
                                                          .data
                                                          .docs[index]
                                                              ['created_at']
                                                          .toDate()
                                                          .day
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 13),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          snapshot.data.docs[index]
                                                      ['published'] ==
                                                  true
                                              ? Container()
                                              : Text('(Not Published)'),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: GestureDetector(
                                                    child: Icon(Icons
                                                        .arrow_forward_ios_outlined)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                secondaryActions: snapshot.data.docs[index]
                                            ['published'] ==
                                        false
                                    ? <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          height: 80,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            child: IconSlideAction(
                                              color: Colors.green,
                                              caption: 'Publish',
                                              icon: Icons.done,
                                              onTap: () {
                                                publishQuiz(snapshot
                                                    .data.docs[index].id);
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 80,
                                          child: IconSlideAction(
                                            caption: 'Edit',
                                            color: Colors.black45,
                                            icon: Icons.edit,
                                            onTap: () {
                                              editQuiz(
                                                  snapshot.data.docs[index]
                                                      ['title'],
                                                  snapshot.data.docs[index].id);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            height: 80,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              child: IconSlideAction(
                                                caption: 'Delete',
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                onTap: () {
                                                  deleteQuiz(snapshot
                                                      .data.docs[index].id);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    : <Widget>[
                                        Container(
                                          height: 80,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            child: IconSlideAction(
                                              caption: 'Edit',
                                              color: Colors.black45,
                                              icon: Icons.edit,
                                              onTap: () {
                                                editQuiz(
                                                    snapshot.data.docs[index]
                                                        ['title'],
                                                    snapshot
                                                        .data.docs[index].id);
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            height: 80,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              child: IconSlideAction(
                                                caption: 'Delete',
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                onTap: () {
                                                  deleteQuiz(snapshot
                                                      .data.docs[index].id);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                              );
                            });
                  },
                ),
              ),
            ),
    );
  }

  addQuiz() {
    showDialog(context: context, barrierDismissible: false, child: AddQuiz());
  }

  editQuiz(String title, String docId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: EditQuiz(
          title: title,
          docId: docId,
        ));
  }

  deleteQuiz(String docId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: DeleteQuiz(
          docId: docId,
        ));
  }

  publishQuiz(String docId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: PublishQuiz(
          docId: docId,
        ));
  }
}
