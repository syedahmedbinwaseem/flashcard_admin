import 'package:cloud_firestore/cloud_firestore.dart';
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
    TextEditingController textController = new TextEditingController();
    GlobalKey<FormState> fKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                          'Add Quiz',
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
                              return input.isEmpty
                                  ? 'Field is required!'
                                  : null;
                            },
                            textInputAction: TextInputAction.done,
                            cursorColor: Colors.grey[700],
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                hintText: 'Quiz title',
                                hintStyle: TextStyle(
                                    fontFamily: 'Segoe', fontSize: 12)),
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
                                        .doc()
                                        .set({
                                      'title': textController.text,
                                      'attempted': [],
                                      'created_at': Timestamp.now(),
                                      'published': false
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
          );
        });
  }

  editQuiz(String title, String docId) {
    TextEditingController textController =
        new TextEditingController(text: title);
    GlobalKey<FormState> fKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                              return input.isEmpty
                                  ? 'Field is required!'
                                  : null;
                            },
                            textInputAction: TextInputAction.done,
                            cursorColor: Colors.grey[700],
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                hintText: 'Title',
                                hintStyle: TextStyle(
                                    fontFamily: 'Segoe', fontSize: 12)),
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
                                        .doc(docId)
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
          );
        });
  }

  deleteQuiz(String docId) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                                Navigator.pop(context);

                                setState(() {
                                  isLoading = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('quizzes')
                                    .doc(docId)
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
                ),
              ),
            ),
          );
        });
  }

  publishQuiz(String docId) async {
    int ansOptions = 0;
    int correctAns = 0;
    bool ansOption = false;
    bool correctAnss = false;
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(docId)
        .collection('questions')
        .get();
    int numberOfQuestions = snap.docs.length;

    //check if there are any answer options
    if (numberOfQuestions == 0) {
    } else {
      snap.docs.forEach((element) {
        if (element.data().containsKey('answer_options') &&
            element['answer_options'].length != 0) {
          ansOptions++;
        }
      });
      if (numberOfQuestions == ansOptions) {
        ansOption = true;
      }
    }

    //check if there is correct answer
    if (numberOfQuestions == 0) {
    } else {
      snap.docs.forEach((element) {
        if (element.data().containsKey('correct_answer')) {
          correctAns++;
        }
      });
      if (numberOfQuestions == correctAns) {
        correctAnss = true;
      }
    }

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                                      .doc(docId)
                                      .update({'published': true});

                                  NotificationManager notificationManager=new NotificationManager();
                                  notificationManager.sendAndRetrieveMessage('', 
                                  "New Quiz PUblished!",
                                  "CFA Nodal Trainer published new Flashcard for you.");
                                
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
          );
        });
  }
}
