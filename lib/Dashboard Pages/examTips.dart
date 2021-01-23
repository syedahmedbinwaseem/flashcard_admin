import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_admin/screens/tipsPage.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:date_format/date_format.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ExamTips extends StatefulWidget {
  @override
  _ExamTipsState createState() => _ExamTipsState();
}

class _ExamTipsState extends State<ExamTips> {
  List<DocumentSnapshot> snap1 = List<DocumentSnapshot>();
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

  void setTimer() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        load = true;
      });
    });
  }

  void getTips() async {
    setState(() {
      snap1 = [];
    });
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('examtips')
        .orderBy('id')
        .get();
    snap.docs.forEach((element) {
      setState(() {
        snap1.add(element);
      });
    });
  }

  DateTime getTime(int index) {
    Timestamp t = snap1[index]['time'];
    return t.toDate();
  }

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
    setTimer();
    getTips();
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
          backgroundColor: blueTextColor,
          heroTag: 'newtip',
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return ModalProgressHUD(
                      inAsyncCall: isLoading,
                      child: Dialog(
                        insetPadding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
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
                                    'Add new tip',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 10),
                                  Theme(
                                    data: new ThemeData(
                                      primaryColor: Colors.grey[700],
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontFamily: 'Segoe'),
                                      controller: idCon,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colors.grey[700],
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: 'ID',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Segoe',
                                              fontSize: 12)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Theme(
                                    data: new ThemeData(
                                      primaryColor: Colors.grey[700],
                                    ),
                                    child: TextField(
                                      style: TextStyle(fontFamily: 'Segoe'),
                                      controller: tipCon,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colors.grey[700],
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: 'Tip',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Segoe',
                                              fontSize: 12)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Theme(
                                    data: new ThemeData(
                                      primaryColor: Colors.grey[700],
                                    ),
                                    child: TextField(
                                      style: TextStyle(fontFamily: 'Segoe'),
                                      controller: remCon,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colors.grey[700],
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: 'Remember',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Segoe',
                                              fontSize: 12)),
                                    ),
                                  ),
                                  DateTimePicker(
                                    decoration: InputDecoration(
                                        focusColor: Colors.black,
                                        hintText: 'Date',
                                        hintStyle: TextStyle(
                                            fontFamily: 'Segoe', fontSize: 12),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black))),
                                    style: TextStyle(
                                        fontFamily: 'Segoe', fontSize: 12),
                                    initialValue: '',
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    dateLabelText: 'Date',
                                    onChanged: (val) => setState(() {
                                      date = val;
                                    }),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 10),
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            remCon.clear();
                                            tipCon.clear();
                                            idCon.clear();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontFamily: 'Segoe',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            if (idCon.text == '') {
                                              fToast.showToast(
                                                child: ToastWidget.toast(
                                                    'ID cannot be empty',
                                                    Icon(Icons.error,
                                                        size: 20)),
                                                toastDuration:
                                                    Duration(seconds: 2),
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                              setState(() {
                                                isLoading = false;
                                              });
                                            } else if (tipCon.text == '') {
                                              fToast.showToast(
                                                child: ToastWidget.toast(
                                                    'Tip cannot be empty',
                                                    Icon(Icons.error,
                                                        size: 20)),
                                                toastDuration:
                                                    Duration(seconds: 2),
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                              setState(() {
                                                isLoading = false;
                                              });
                                            } else if (remCon.text == '') {
                                              fToast.showToast(
                                                child: ToastWidget.toast(
                                                    'Remember cannot be empty',
                                                    Icon(Icons.error,
                                                        size: 20)),
                                                toastDuration:
                                                    Duration(seconds: 2),
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                              setState(() {
                                                isLoading = false;
                                              });
                                            } else if (date == null ||
                                                date == '') {
                                              fToast.showToast(
                                                child: ToastWidget.toast(
                                                    'Date cannot be empty',
                                                    Icon(Icons.error,
                                                        size: 20)),
                                                toastDuration:
                                                    Duration(seconds: 2),
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                              setState(() {
                                                isLoading = false;
                                              });
                                            } else {
                                              User user = FirebaseAuth
                                                  .instance.currentUser;
                                              if (user != null) {
                                                try {
                                                  QuerySnapshot snap =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'examtips')
                                                          .get();
                                                  int checkAlreadyExist = 0;
                                                  snap.docs.forEach((element) {
                                                    if (element['id'] ==
                                                        idCon.text) {
                                                      checkAlreadyExist++;
                                                    } else {}
                                                  });

                                                  if (checkAlreadyExist == 0) {
                                                    try {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'examtips')
                                                          .doc()
                                                          .set({
                                                        'id': idCon.text,
                                                        'tip': tipCon.text,
                                                        'remember': remCon.text,
                                                        'time': Timestamp.fromDate(
                                                            convertDateFromString(
                                                                date))
                                                      });
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      Navigator.pop(context);
                                                      fToast.showToast(
                                                          child: ToastWidget.toast(
                                                              'Tip added successfully',
                                                              Icon(
                                                                  Icons.done)));
                                                      getTips();
                                                    } catch (e) {}
                                                  } else {
                                                    fToast.showToast(
                                                        child: ToastWidget.toast(
                                                            'Tip with this ID already exist',
                                                            Icon(Icons.error)));
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                } catch (e) {}
                                              }
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
                }).then((value) {
              idCon.clear();
              remCon.clear();
              tipCon.clear();
            });
          },
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
            icon: Icon(Icons.arrow_back_ios_outlined),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            'Tips Hsitory',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: snap1.length == 0 && load == false
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(blueTextColor),
              ))
            : snap1.length == 0 && load == true
                ? Center(
                    child: Text('No tips available.'),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 20, top: 10),
                    itemCount: snap1.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: buttonColor1,
                                    title: Text(
                                      'Tip # ' + snap1[index]['id'],
                                      style: TextStyle(
                                          fontFamily: 'Segoe',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      "Select an option",
                                      style: TextStyle(
                                        fontFamily: 'Segoe',
                                      ),
                                    ),
                                    actionsPadding:
                                        EdgeInsets.only(bottom: 10, right: 10),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            tipECon.text = snap1[index]['tip'];
                                            remECon.text =
                                                snap1[index]['remember'];
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return ModalProgressHUD(
                                                    inAsyncCall: isLoading,
                                                    child: Dialog(
                                                      insetPadding:
                                                          EdgeInsets.all(0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                        },
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration:
                                                                GlobalWidget
                                                                    .backGround(),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'Edit tip',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Segoe',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            Text(
                                                                          'ID: ' +
                                                                              snap1[index]['id'],
                                                                          style: TextStyle(
                                                                              fontFamily: 'Segoe',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Theme(
                                                                  data:
                                                                      new ThemeData(
                                                                    primaryColor:
                                                                        Colors.grey[
                                                                            700],
                                                                  ),
                                                                  child: TextField(
                                                                      style: TextStyle(fontFamily: 'Segoe'),
                                                                      controller: tipECon,
                                                                      textInputAction: TextInputAction.next,
                                                                      cursorColor: Colors.grey[700],
                                                                      decoration: InputDecoration(
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                        labelText:
                                                                            'Tip',
                                                                        labelStyle: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontFamily:
                                                                                'Segoe',
                                                                            fontSize:
                                                                                12),
                                                                        // hintText:
                                                                        //     'Tip',
                                                                        // hintStyle: TextStyle(
                                                                        //     fontFamily: 'Segoe',
                                                                        //     fontSize: 12),
                                                                      )),
                                                                ),
                                                                Theme(
                                                                  data:
                                                                      new ThemeData(
                                                                    primaryColor:
                                                                        Colors.grey[
                                                                            700],
                                                                  ),
                                                                  child: TextField(
                                                                      style: TextStyle(fontFamily: 'Segoe'),
                                                                      controller: remECon,
                                                                      textInputAction: TextInputAction.next,
                                                                      cursorColor: Colors.grey[700],
                                                                      decoration: InputDecoration(
                                                                        enabledBorder:
                                                                            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                        labelText:
                                                                            'Remember',
                                                                        labelStyle: TextStyle(
                                                                            fontFamily:
                                                                                'Segoe',
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 12),
                                                                      )
                                                                      // hintText:
                                                                      //     'Remember',
                                                                      // hintStyle: TextStyle(
                                                                      //     fontFamily:
                                                                      //         'Segoe',
                                                                      //     fontSize:
                                                                      //         12)),
                                                                      ),
                                                                ),
                                                                DateTimePicker(
                                                                  decoration: InputDecoration(
                                                                      focusColor: Colors.black,
                                                                      labelText: 'Date',
                                                                      labelStyle: TextStyle(color: Colors.black, fontFamily: 'Segoe', fontSize: 12),
                                                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                      border: UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.black),
                                                                      ),
                                                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))),
                                                                  cursorColor:
                                                                      Colors
                                                                          .black,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Segoe',
                                                                      fontSize:
                                                                          12),
                                                                  initialValue:
                                                                      convertStringFromDate(
                                                                          snap1[index]
                                                                              [
                                                                              'time']),
                                                                  firstDate:
                                                                      DateTime(
                                                                          2000),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2100),
                                                                  dateLabelText:
                                                                      'Date',
                                                                  onChanged: (val) =>
                                                                      setState(
                                                                          () {
                                                                    date = val;
                                                                  }),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10),
                                                                  height: 40,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.9,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          tipECon
                                                                              .clear();
                                                                          remECon
                                                                              .clear();

                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(fontFamily: "Segoe", fontWeight: FontWeight.bold)),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              20),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            isLoading =
                                                                                true;
                                                                          });
                                                                          if (tipECon.text ==
                                                                              '') {
                                                                            fToast.showToast(child: ToastWidget.toast('Tip cannot be empty', Icon(Icons.error)));
                                                                            setState(() {
                                                                              isLoading = false;
                                                                            });
                                                                          } else if (remECon.text ==
                                                                              '') {
                                                                            fToast.showToast(child: ToastWidget.toast('Remember cannot be empty', Icon(Icons.error)));
                                                                            setState(() {
                                                                              isLoading = false;
                                                                            });
                                                                          } else if (date ==
                                                                              '') {
                                                                            fToast.showToast(child: ToastWidget.toast('Date cannot be empty', Icon(Icons.error)));
                                                                            setState(() {
                                                                              isLoading = false;
                                                                            });
                                                                          } else {
                                                                            try {
                                                                              FirebaseFirestore.instance.collection('examtips').doc(snap1[index].id).update({
                                                                                'tip': tipECon.text,
                                                                                'remember': remECon.text,
                                                                                'time': convertDateFromString(date)
                                                                              });
                                                                              Navigator.pop(context);
                                                                              getTips();
                                                                              setState(() {
                                                                                isLoading = false;
                                                                              });
                                                                              fToast.showToast(child: ToastWidget.toast('Tip updated', Icon(Icons.done)));
                                                                            } catch (e) {
                                                                              setState(() {
                                                                                isLoading = false;
                                                                              });
                                                                            }
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                            'Edit',
                                                                            style: TextStyle(
                                                                                fontFamily: "Segoe",
                                                                                fontWeight: FontWeight.bold,
                                                                                color: blueTextColor)),
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
                                              });
                                        },
                                        child: Text('Edit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: blueTextColor)),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Are you sure?',
                                                    style: TextStyle(
                                                        fontFamily: 'Segoe',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  content: isLoading == true
                                                      ? Container(
                                                          height: 40,
                                                          width: 40,
                                                          child: Center(
                                                            child: SizedBox(
                                                                height: 35,
                                                                width: 35,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  valueColor:
                                                                      AlwaysStoppedAnimation<
                                                                          Color>(
                                                                    Color
                                                                        .fromRGBO(
                                                                            102,
                                                                            126,
                                                                            234,
                                                                            1),
                                                                  ),
                                                                  strokeWidth:
                                                                      3,
                                                                )),
                                                          ),
                                                        )
                                                      : null,
                                                  actionsPadding:
                                                      EdgeInsets.only(
                                                          bottom: 10,
                                                          right: 10),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                          fontFamily: 'Segoe',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'examtips')
                                                              .doc(snap1[index]
                                                                  .id)
                                                              .delete();
                                                          fToast.showToast(
                                                              child: ToastWidget.toast(
                                                                  'Tip Deleted',
                                                                  Icon(Icons
                                                                      .done)));

                                                          Navigator.pop(
                                                              context);
                                                          initState();
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        } catch (e) {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                          print(e);
                                                          // fToast.showToast(
                                                          //     child: ToastWidget.toast(
                                                          //         'Unexpected error occured',
                                                          //         Icon(Icons
                                                          //             .error)));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            fontFamily: 'Segoe',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                              fontFamily: 'Segoe',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TipsPage(
                                  allTips: snap1,
                                  myIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: buttonColor2,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tip # ${snap1[index]['id']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        getTime(index)
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Icon(
                                          Icons.arrow_forward_ios_outlined),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
