import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class DeleteTip extends StatefulWidget {
  String docId;

  DeleteTip({this.docId});
  @override
  _DeleteTipState createState() => _DeleteTipState();
}

class _DeleteTipState extends State<DeleteTip> {
  bool isLoading = false;
  FToast fToast;

  @override
  void initState() {
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
                                .collection('examtips')
                                .doc(widget.docId)
                                .delete();

                            setState(() {
                              isLoading = false;
                            });
                            fToast.showToast(
                                child: ToastWidget.toast(
                                    'Tip Deleted', Icon(Icons.done)));
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
      ),
    );
  }
}
