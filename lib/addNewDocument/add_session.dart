import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddSession extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddSessionState();
}

class AddSessionState extends State<AddSession>
    with SingleTickerProviderStateMixin {
  final sessionName = TextEditingController();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading;

  @override
  void initState() {
    isLoading=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Center(
        child: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Form(
                key: fKey,
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                  child: Container(padding: EdgeInsets.all(10), child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Add New Session',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: TextFormField(
                          controller: sessionName,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: OutlineInputBorder(),
                            labelText: 'Session Title'
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.black26,
                            child: Text("Discard"),
                          ),
                          SizedBox(width: 10),
                          RaisedButton(
                            onPressed: () async{
                              if(fKey.currentState.validate()){
                                setState(() {
                                  isLoading=true;
                                });
                                try{
                                  DocumentReference doc=await FirebaseFirestore.instance.collection('level1').doc();
                                  await doc.set({
                                    'created_at': Timestamp.now(),
                                    'id': doc.id,
                                    'title' : sessionName.text
                                  });
                                }catch(e){
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong!",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: buttonColor1,
                                      textColor: Colors.white,
                                      fontSize: 15,
                                    );
                                }
                                Navigator.pop(context);
                                setState(() {
                                  isLoading =false;
                                });
                              }
                            },
                            color: buttonColor2,
                            child: Text("Add"),
                          ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  )),
                ),
              ),
            ))),
    );
  }

  String validateFields(String input) {
    if (input.isEmpty) {
      return "Field Required!";
    } else {
      return null;
    }
  }
}
