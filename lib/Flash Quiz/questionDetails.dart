import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class QuestionDetail extends StatefulWidget {
  int index;
  String docId;
  String qId;
  String question;
  DocumentSnapshot snap;
  String correctAnswer;

  QuestionDetail(
      {this.index,
      this.docId,
      this.qId,
      this.question,
      this.snap,
      this.correctAnswer});
  @override
  _QuestionDetailState createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  DocumentSnapshot snap;
  bool isLoading = false;
  String dropdownValue;
  bool edit = false;
  FToast fToast;
  bool saved = false;

  @override
  void initState() {
    setState(() {
      dropdownValue = widget.correctAnswer;
    });
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    print(dropdownValue);
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
          'Question # ${widget.index}',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: GlobalWidget.backGround(),
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('quizzes')
                  .doc(widget.docId)
                  .collection('questions')
                  .doc(widget.qId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                print("Here we got ::: Snap Id :  and ${snapshot.data.id}");
                return snapshot.data == null
                    ? CircularProgressIndicator()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              widget.question,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: buttonColor1,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Answer Options:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CircleAvatar(
                                      radius: 18,
                                      child: IconButton(
                                        icon: Icon(Icons.add, size: 18),
                                        onPressed: () {
                                          setState(() {
                                            snap = snapshot.data;
                                          });

                                          addAnswerOption();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data == null
                                ? 0
                                : !snapshot.data
                                        .data()
                                        .containsKey('answer_options')
                                    ? 0
                                    : snapshot.data['answer_options'].length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    child: FlatButton(
                                      onPressed: () {},
                                      height: 40,
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      highlightColor:
                                          buttonColor2.withOpacity(0.3),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            snapshot.data['answer_options']
                                                [index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ),
                                    secondaryActions: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        child: IconSlideAction(
                                          caption: 'Edit',
                                          color: Colors.black45,
                                          icon: Icons.edit,
                                          onTap: () {
                                            setState(() {
                                              snap = snapshot.data;
                                            });
                                            editAnswerOptions(
                                                snapshot.data['answer_options']
                                                    [index],
                                                index);
                                          },
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        child: IconSlideAction(
                                          caption: 'Delete',
                                          color: Colors.red,
                                          icon: Icons.delete,
                                          onTap: () {
                                            setState(() {
                                              snap = snapshot.data;
                                            });
                                            deleteAnswerOption(index);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 0,
                                  )
                                ],
                              );
                            },
                          ),
                          Divider(height: 0),
                          SizedBox(height: 15),
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: buttonColor1,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Correct Answer:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          snapshot.data.data().containsKey('answer_options')
                              ? Container(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  width: MediaQuery.of(context).size.width,
                                  child: DropdownButtonHideUnderline(
                                    child: new DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(
                                        'Select an option',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      value: List.from(snapshot
                                                  .data['answer_options'])
                                              .contains(dropdownValue)
                                          ? dropdownValue
                                          : null,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      onChanged: (String value) {
                                        print(value);
                                        setState(() {
                                          snap = snapshot.data;
                                          dropdownValue = value;
                                        });
                                        addCorrectAnswer(value);
                                      },
                                      items: List.from(
                                              snapshot.data['answer_options'])
                                          .map<DropdownMenuItem<String>>((e) =>
                                              DropdownMenuItem<String>(
                                                  value: e, child: Text(e)))
                                          .toList(),
                                    ),
                                  ),
                                )
                              : Container(),
                          Divider(height: 5),
                          SizedBox(height: 15),
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: buttonColor1,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Explaination:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CircleAvatar(
                                      radius: 18,
                                      child: !snapshot.data
                                              .data()
                                              .containsKey('explanation')
                                          ? IconButton(
                                              onPressed: () {
                                                addExplanation(snapshot.data);
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                size: 18,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                editExplanation(snapshot
                                                    .data['explanation'], snapshot.data);
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          !snapshot.data.data().containsKey('explanation')
                              ? Container()
                              : FlatButton(
                                  onPressed: () {},
                                  height: 40,
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  highlightColor: buttonColor2.withOpacity(0.3),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        !snapshot.data
                                                .data()
                                                .containsKey('explanation')
                                            ? ''
                                            : snapshot.data['explanation'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      )),
                                ),
                          Divider(height: 5),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  addAnswerOption() {
    print(widget.docId);
    TextEditingController textController = new TextEditingController();
    GlobalKey<FormState> fKey = GlobalKey<FormState>();
    List previousValues = [];
    showDialog(
      barrierDismissible: false,
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
                          'Add Answer Option',
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
                                hintText: 'Answer Option',
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
                                    if (snap
                                        .data()
                                        .containsKey('answer_options')) {
                                      int length =
                                          snap['answer_options'].length;

                                      for (int i = 0; i < length; i++) {
                                        previousValues
                                            .add(snap['answer_options'][i]);
                                      }

                                      previousValues.add(textController.text);
                                    } else {
                                      previousValues.add(textController.text);
                                    }

                                    print(previousValues);
                                    await FirebaseFirestore.instance
                                        .collection('quizzes')
                                        .doc(widget.docId)
                                        .collection('questions')
                                        .doc(snap.id)
                                        .update(
                                            {'answer_options': previousValues});

                                    setState(() {
                                      isLoading = false;
                                      edit = true;
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

  editAnswerOptions(String option, int index) {
    TextEditingController textController =
        new TextEditingController(text: option);
    GlobalKey<FormState> fKey = GlobalKey<FormState>();
    List previousValues = [];
    showDialog(
        context: context,
        barrierDismissible: false,
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
                          'Edit Answer Option',
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
                                hintText: 'Answer Option',
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

                                    int length = snap['answer_options'].length;

                                    for (int i = 0; i < length; i++) {
                                      previousValues
                                          .add(snap['answer_options'][i]);
                                    }
                                    print(previousValues);

                                    previousValues[index] =
                                        (textController.text);
                                    print(previousValues);
                                    await FirebaseFirestore.instance
                                        .collection('quizzes')
                                        .doc(widget.docId)
                                        .collection('questions')
                                        .doc(snap.id)
                                        .update(
                                            {'answer_options': previousValues});

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

  deleteAnswerOption(int index) {
    List previousValues = [];
    showDialog(
      barrierDismissible: false,
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
                      'Are you sure you want to delete: ',
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

                                int length = snap['answer_options'].length;

                                for (int i = 0; i < length; i++) {
                                  previousValues.add(snap['answer_options'][i]);
                                }
                                previousValues.removeAt(index);
                                await FirebaseFirestore.instance
                                    .collection('quizzes')
                                    .doc(widget.docId)
                                    .collection('questions')
                                    .doc(snap.id)
                                    .update({'answer_options': previousValues});

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

  addCorrectAnswer(String option) {
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
                          'Option selected:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(option),
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
                                      saved = true;
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('quizzes')
                                        .doc(widget.docId)
                                        .collection('questions')
                                        .doc(snap.id)
                                        .update({'correct_answer': option});
                                    fToast.showToast(
                                      child: ToastWidget.toast(
                                          'Correct Answer Added',
                                          Icon(Icons.done, size: 20)),
                                      toastDuration: Duration(seconds: 2),
                                      gravity: ToastGravity.CENTER,
                                    );
                                    setState(() {
                                      isLoading = false;
                                      edit = false;
                                      saved = false;
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

  editCorrectAnswer(String answer) {
    TextEditingController textController =
        new TextEditingController(text: answer);
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
                          'Edit Correct Answer',
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
                                hintText: 'Correct Answer',
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
                                        .doc(widget.docId)
                                        .collection('questions')
                                        .doc(snap.id)
                                        .update({
                                      'correct_answer': textController.text
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

  addExplanation(DocumentSnapshot quizSnap) {
    TextEditingController textController = new TextEditingController();
    GlobalKey<FormState> fKey = GlobalKey<FormState>();
    // print("here we got ::: $snap ::: ++++");
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
                          'Add Explanation',
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
                            maxLines: 3,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                hintText: 'Explanation',
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
                                    try{
                                    await FirebaseFirestore.instance
                                        .collection('quizzes')
                                        .doc(widget.docId)
                                        .collection('questions')
                                        .doc(quizSnap.id)
                                        .update({
                                      'explanation': textController.text
                                    });
                                    }catch(e){
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(msg: "Exception $e");
                                    }
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

  editExplanation(String explanation, DocumentSnapshot quizSnap) {
    TextEditingController textController =
        new TextEditingController(text: explanation);
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
                          'Edit Explanation',
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
                                hintText: 'Explanation',
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
                                        .doc(widget.docId)
                                        .collection('questions')
                                        .doc(quizSnap.id)
                                        .update({
                                      'explanation': textController.text
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
