import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flashcard_admin/Flash%20Quiz/questionDetails.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class QuizDetails extends StatefulWidget {
  String snap;
  String title;

  QuizDetails({this.snap, this.title});
  @override
  _QuizDetailsState createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  List<DocumentSnapshot> questions = List<DocumentSnapshot>();
  NumberFormat formatter = new NumberFormat("00");
  bool isLoading = false;
  // void getQuestions() async {
  //   QuerySnapshot snap = await FirebaseFirestore.instance
  //       .collection('quizzes')
  //       .doc(widget.snap.id)
  //       .collection('questions')
  //       .get();

  //   snap.docs.forEach((element) {
  //     setState(() {
  //       questions.add(element);
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          icon: Icon(Icons.arrow_back_ios_outlined),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor2,
        child: Center(child: Icon(Icons.add)),
        onPressed: () {
          addQuestions();
        },
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: GlobalWidget.backGround(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Questions:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('quizzes')
                    .doc(widget.snap)
                    .collection('questions')
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return snapshot.data == null
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: snapshot.data == null
                              ? 0
                              : snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Text(
                                  formatter.format(index + 1) + ':',
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Slidable(
                                        actionPane: SlidableDrawerActionPane(),
                                        child: FlatButton(
                                          height: 40,
                                          padding: EdgeInsets.only(
                                              left: 3, right: 8),
                                          highlightColor:
                                              buttonColor2.withOpacity(0.3),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuestionDetail(
                                                          correctAnswer: snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .data()
                                                                  .containsKey(
                                                                      'correct_answer')
                                                              ? snapshot.data
                                                                          .docs[
                                                                      index][
                                                                  'correct_answer']
                                                              : null,
                                                          index: index + 1,
                                                          docId: widget.snap,
                                                          qId: snapshot.data
                                                              .docs[index].id,
                                                          question: snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ['question'],
                                                          snap: snapshot
                                                              .data.docs[index],
                                                        )));
                                          },
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(snapshot.data
                                                  .docs[index]['question'])),
                                        ),
                                        secondaryActions: <Widget>[
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            child: IconSlideAction(
                                              caption: 'Edit',
                                              color: Colors.black45,
                                              icon: Icons.edit,
                                              onTap: () {
                                                editQuestion(
                                                    snapshot.data.docs[index]
                                                        ['question'],
                                                    snapshot
                                                        .data.docs[index].id);
                                              },
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            child: IconSlideAction(
                                              caption: 'Delete',
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () {
                                                deleteQuestion(snapshot
                                                    .data.docs[index].id);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  editQuestion(String question, String docId) {
    TextEditingController textController =
        new TextEditingController(text: question);
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
                          'Edit Question',
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
                                hintText: 'Question',
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
                                        .doc(widget.snap)
                                        .collection('questions')
                                        .doc(docId)
                                        .update({
                                      'question': textController.text,
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

  deleteQuestion(String docId) {
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
                                    .doc(widget.snap)
                                    .collection('questions')
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

  addQuestions() {
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
                          'Add Question',
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
                                hintText: 'Question',
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
                                        .doc(widget.snap)
                                        .collection('questions')
                                        .doc()
                                        .set({
                                      'question': textController.text,
                                      'created_at': Timestamp.now()
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
}
