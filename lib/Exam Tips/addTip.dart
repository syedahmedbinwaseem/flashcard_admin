import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_admin/NotificationManager/pushNotificationManager.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddTip extends StatefulWidget {
  @override
  _AddTipState createState() => _AddTipState();
}

class _AddTipState extends State<AddTip> {
  TextEditingController tipCon = TextEditingController();
  TextEditingController remCon = TextEditingController();
  String date;
  bool isLoading = false;
  FToast fToast;

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
    // TODO: implement initState
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 10),
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
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'Tip',
                          hintStyle:
                              TextStyle(fontFamily: 'Segoe', fontSize: 12)),
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
                      maxLines: 4,
                      cursorColor: Colors.grey[700],
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'Remember',
                          hintStyle:
                              TextStyle(fontFamily: 'Segoe', fontSize: 12)),
                    ),
                  ),
                  DateTimePicker(
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        hintText: 'Date',
                        hintStyle: TextStyle(fontFamily: 'Segoe', fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    style: TextStyle(fontFamily: 'Segoe', fontSize: 12),
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
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          minWidth: 40,
                          onPressed: () {
                            Navigator.pop(context);
                            remCon.clear();
                            tipCon.clear();
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
                            setState(() {
                              isLoading = true;
                            });
                            if (tipCon.text == '') {
                              fToast.showToast(
                                child: ToastWidget.toast('Tip cannot be empty',
                                    Icon(Icons.error, size: 20)),
                                toastDuration: Duration(seconds: 2),
                                gravity: ToastGravity.BOTTOM,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            } else if (remCon.text == '') {
                              fToast.showToast(
                                child: ToastWidget.toast(
                                    'Remember cannot be empty',
                                    Icon(Icons.error, size: 20)),
                                toastDuration: Duration(seconds: 2),
                                gravity: ToastGravity.BOTTOM,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            } else if (date == null || date == '') {
                              fToast.showToast(
                                child: ToastWidget.toast('Date cannot be empty',
                                    Icon(Icons.error, size: 20)),
                                toastDuration: Duration(seconds: 2),
                                gravity: ToastGravity.BOTTOM,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              User user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('examtips')
                                      .doc()
                                      .set({
                                    'created_at': Timestamp.now(),
                                    'tip': tipCon.text,
                                    'remember': remCon.text,
                                    'time': Timestamp.fromDate(
                                        convertDateFromString(date))
                                  });
                                  NotificationManager notificationManager =
                                      new NotificationManager();
                                  notificationManager.sendAndRetrieveMessage(
                                      '',
                                      "Tip of Day!",
                                      "CFA Nodal Trainer added new tip of day for you.");

                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                  fToast.showToast(
                                      child: ToastWidget.toast(
                                          'Tip added successfully',
                                          Icon(Icons.done)));
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
  }
}
