import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/Exam%20Tips/addTip.dart';
import 'package:flashcard_admin/Exam%20Tips/deteleTip.dart';
import 'package:flashcard_admin/Exam%20Tips/editExamTip.dart';
import 'package:flashcard_admin/Exam%20Tips/publishTip.dart';
import 'package:flashcard_admin/screens/tipsPage.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:date_format/date_format.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExamTips extends StatefulWidget {
  @override
  _ExamTipsState createState() => _ExamTipsState();
}

class _ExamTipsState extends State<ExamTips> {
  String date;
  final idCon = TextEditingController();
  final remCon = TextEditingController();
  final tipCon = TextEditingController();

  final idECon = TextEditingController();
  final remECon = TextEditingController();
  final tipECon = TextEditingController();
  bool isLoading;
  bool isDelete;
  bool isEdit;
  FToast fToast;
  bool load = false;

  DateTime convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);

    return todayDate;
  }

  String convertStringFromDate(Timestamp time) {
    final todayDate =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    return formatDate(todayDate, [yyyy, '-', mm, '-', dd]);
  }

  @override
  void initState() {
    isLoading = false;

    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalWidget.backGround(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: buttonColor2,
          heroTag: 'newtip',
          onPressed: addTip,
          child: Center(
            child: Icon(Icons.add),
          ),
        ),
        backgroundColor: Colors.transparent,
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
            'Exam Tips',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('examtips')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.data == null
                ? Container(
                    decoration: GlobalWidget.backGround(),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(blueTextColor),
                      ),
                    ))
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 20, top: 10),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        secondaryActions: snapshot.data.docs[index]
                                    ['published'] ==
                                true
                            ? <Widget>[
                                Container(
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    child: IconSlideAction(
                                      caption: 'Edit',
                                      color: Colors.black45,
                                      icon: Icons.edit,
                                      onTap: () {
                                        editTip(
                                            snapshot.data.docs[index].id,
                                            index,
                                            context,
                                            convertStringFromDate(snapshot
                                                .data.docs[index]['time']),
                                            snapshot.data.docs[index]['tip'],
                                            snapshot.data.docs[index]
                                                ['remember']);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      child: IconSlideAction(
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () {
                                          deleteTip(
                                              snapshot.data.docs[index].id);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            : <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    child: IconSlideAction(
                                      color: Colors.green,
                                      caption: 'Publish',
                                      icon: Icons.done,
                                      onTap: () {
                                        publishTip(
                                            snapshot.data.docs[index].id);
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
                                      editTip(
                                          snapshot.data.docs[index].id,
                                          index,
                                          context,
                                          convertStringFromDate(snapshot
                                              .data.docs[index]['time']),
                                          snapshot.data.docs[index]['tip'],
                                          snapshot.data.docs[index]
                                              ['remember']);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      child: IconSlideAction(
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () {
                                          deleteTip(
                                              snapshot.data.docs[index].id);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TipsPage(
                                    allTips: snapshot.data.docs,
                                    myIndex: index,
                                    appBarIndex:
                                        snapshot.data.docs.length - index,
                                  ),
                                ),
                              );
                            },
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
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
                                          'assets/images/lightbulb.png'),
                                    ),
                                    SizedBox(width: 15),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // 'Tip # ${index + 1}',
                                            'Tip # ${snapshot.data.docs.length - index}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            snapshot.data.docs[index]['time']
                                                    .toDate()
                                                    .month
                                                    .toString() +
                                                '-' +
                                                snapshot
                                                    .data.docs[index]['time']
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                '-' +
                                                snapshot
                                                    .data.docs[index]['time']
                                                    .toDate()
                                                    .year
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    snapshot.data.docs[index]['published'] ==
                                            true
                                        ? Container()
                                        : Text('(Not Published)'),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Icon(
                                              Icons.arrow_forward_ios_outlined),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  addTip() {
    showDialog(context: context, barrierDismissible: false, child: AddTip());
  }

  editTip(String docId, int index, BuildContext context, String previousDate,
      String tip, String remember) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: EditTip(
          datee: previousDate,
          docId: docId,
          previousDate: previousDate,
          index: index,
          tip: tip,
          remember: remember,
        ));
  }

  deleteTip(String docId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: DeleteTip(
          docId: docId,
        ));
  }

  publishTip(String docId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: PublishTip(
          docId: docId,
        ));
  }
}
