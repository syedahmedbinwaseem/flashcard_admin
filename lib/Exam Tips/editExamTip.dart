import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class EditTip extends StatefulWidget {
  String docId;
  int index;
  String previousDate;
  String datee;
  String tip;
  String remember;

  EditTip(
      {this.docId,
      this.index,
      this.previousDate,
      this.datee,
      this.remember,
      this.tip});
  @override
  _EditTipState createState() => _EditTipState();
}

class _EditTipState extends State<EditTip> {
  bool isLoading = false;
  String date;
  FToast fToast;

  TextEditingController tipECon = TextEditingController();
  TextEditingController remECon = TextEditingController();

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
    tipECon.text = widget.tip;
    remECon.text = widget.remember;
    setState(() {
      date = widget.datee;
    });
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
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(10),
              decoration: GlobalWidget.backGround(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit tip',
                    style: TextStyle(
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Theme(
                    data: new ThemeData(
                      primaryColor: Colors.grey[700],
                    ),
                    child: TextField(
                        style: TextStyle(fontFamily: 'Segoe'),
                        controller: tipECon,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.grey[700],
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Tip',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Segoe',
                              fontSize: 12),
                        )),
                  ),
                  Theme(
                    data: new ThemeData(
                      primaryColor: Colors.grey[700],
                    ),
                    child: TextField(
                        style: TextStyle(fontFamily: 'Segoe'),
                        controller: remECon,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.grey[700],
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Remember',
                          labelStyle: TextStyle(
                              fontFamily: 'Segoe',
                              color: Colors.black,
                              fontSize: 12),
                        )),
                  ),
                  DateTimePicker(
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        labelText: 'Date',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Segoe',
                            fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    cursorColor: Colors.black,
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'Segoe', fontSize: 12),
                    initialValue: widget.previousDate,
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
                            tipECon.clear();
                            remECon.clear();

                            Navigator.pop(context);
                          },
                          child: Text('Cancel',
                              style: TextStyle(
                                  fontFamily: "Segoe",
                                  fontWeight: FontWeight.bold)),
                        ),
                        FlatButton(
                          minWidth: 40,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (tipECon.text == '') {
                              fToast.showToast(
                                  child: ToastWidget.toast(
                                      'Tip cannot be empty',
                                      Icon(Icons.error)));
                              setState(() {
                                isLoading = false;
                              });
                            } else if (remECon.text == '') {
                              fToast.showToast(
                                  child: ToastWidget.toast(
                                      'Remember cannot be empty',
                                      Icon(Icons.error)));
                              setState(() {
                                isLoading = false;
                              });
                            } else if (date == '') {
                              fToast.showToast(
                                  child: ToastWidget.toast(
                                      'Date cannot be empty',
                                      Icon(Icons.error)));
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('examtips')
                                    .doc(widget.docId)
                                    .update({
                                  'tip': tipECon.text,
                                  'remember': remECon.text,
                                  'time': convertDateFromString(date)
                                });
                                Navigator.pop(context);

                                setState(() {
                                  isLoading = false;
                                });
                                fToast.showToast(
                                    child: ToastWidget.toast(
                                        'Tip updated', Icon(Icons.done)));
                              } catch (e) {
                                print(e);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: Text('Edit',
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
  }
}
