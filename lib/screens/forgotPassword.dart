import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_admin/screens/login.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // ignore: non_constant_identifier_names
  String Categorydropdown, businessname, placeOfWork;
  bool isLoading;
  DateTime currentBackPressTime;
  final forgotemail = TextEditingController();
  FToast fToast;

  @override
  void initState() {
    isLoading = false;
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          color: blueTextColor,
          inAsyncCall: isLoading,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: GlobalWidget.backGround(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(left: 15, top: 20),
                              child: Icon(Icons.arrow_back_ios)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 45),
                            child: Center(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.35,
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Image.asset('assets/images/logo.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 70),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.036),
                      child: Text(
                        ':: Reset Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Segoe',
                          fontSize: width * 0.065,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: width * 0.07,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.036),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your email',
                            style: TextStyle(
                                color: textColor,
                                fontFamily: 'Segoe',
                                fontSize: width * 0.037),
                          ),
                          Container(
                            width: width * 0.91,
                            height: 50,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              style: TextStyle(
                                  color: textColor, fontFamily: 'Segoe'),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              controller: forgotemail,
                              decoration: InputDecoration(
                                  hintText: 'someone@xyz.com',
                                  hintStyle: TextStyle(
                                      color: textColor,
                                      fontFamily: 'Segoe',
                                      fontSize: width * 0.03)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(pattern);
                          if (regExp.hasMatch(forgotemail.text.toString())) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              final FirebaseAuth _firebaseAuth =
                                  FirebaseAuth.instance;
                              await _firebaseAuth.sendPasswordResetEmail(
                                  email: forgotemail.text.toString());
                              fToast.showToast(
                                child: ToastWidget.toast(
                                    'Password reset link sent on your email',
                                    Icon(Icons.done, size: 20)),
                                toastDuration: Duration(seconds: 2),
                                gravity: ToastGravity.BOTTOM,
                              );

                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                  (route) => false);
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              if (e.code == 'too-many-requests') {
                                fToast.showToast(
                                  child: ToastWidget.toast(
                                      'You are trying too often. Please try again later',
                                      Icon(Icons.error, size: 20)),
                                  toastDuration: Duration(seconds: 2),
                                  gravity: ToastGravity.BOTTOM,
                                );
                              } else {
                                fToast.showToast(
                                  child: ToastWidget.toast(
                                      'Operation failed. Try again later',
                                      Icon(Icons.error, size: 20)),
                                  toastDuration: Duration(seconds: 2),
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            }
                          } else {
                            fToast.showToast(
                              child: ToastWidget.toast(
                                  'Invalid email', Icon(Icons.error, size: 20)),
                              toastDuration: Duration(seconds: 2),
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF667EEA),
                                  offset: Offset(0, 6),
                                  blurRadius: 3,
                                  spreadRadius: -4)
                            ],
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                                colors: [buttonColor1, buttonColor2]),
                            color: Colors.yellow,
                          ),
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Center(
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                  color: buttonTextColor,
                                  fontFamily: 'Segoe',
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
