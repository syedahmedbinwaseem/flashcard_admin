import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_admin/screens/dashboard.dart';
import 'package:flashcard_admin/screens/forgotPassword.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

final FirebaseAuth mauth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey fkey = GlobalKey<FormState>();
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  bool showPass = true;
  bool login;
  FToast fToast;
  void toggle() {
    setState(() {
      showPass = !showPass;
    });
  }

  void logIn() async {
    try {
      await FirebaseFirestore.instance
          .doc("admin/${emailCon.text}")
          .get()
          .then((doc) async {
        if (doc.exists) {
          try {
            // ignore: unused_local_variable
            UserCredential user = await mauth.signInWithEmailAndPassword(
                email: emailCon.text, password: passCon.text);
            print('Login success');
            setState(() {
              login = true;
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (route) => false);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              setState(() {
                login = true;
              });
              Fluttertoast.showToast(
                msg: "User not found for this email",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red[400],
                textColor: Colors.white,
                fontSize: 15,
              );
            } else if (e.code == 'wrong-password') {
              setState(() {
                login = true;
              });
              Fluttertoast.showToast(
                msg: "Wrong password",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red[400],
                textColor: Colors.white,
                fontSize: 15,
              );
            }
          } catch (e) {
            print("Error: " + e);
          }
        } else {
          setState(() {
            login = true;
          });

          Fluttertoast.showToast(
            msg: "User not found for this email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red[400],
            textColor: Colors.white,
            fontSize: 15,
          );
        }
      });
    } catch (e) {
      setState(() {
        login = true;
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    int emailValidate;
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return null;
      },
      child: Stack(
        children: [
          Container(
            decoration: GlobalWidget.backGround(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.width * 0.35,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Image.asset('assets/images/logo.png')),
                        Form(
                          key: fkey,
                          child: Container(
                            height: height,
                            width: width,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.036),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      ':: Login',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Segoe',
                                        fontSize: width * 0.065,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: width * 0.05,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Email',
                                          style: TextStyle(
                                              color: textColor,
                                              fontFamily: 'Segoe',
                                              fontSize: width * 0.037),
                                        ),
                                        Container(
                                          width: width * 0.91,
                                          height: 50,
                                          child: TextFormField(
                                            validator: (input) {
                                              emailValidate =
                                                  validateEmail(input);
                                              return null;
                                            },
                                            cursorColor: Colors.black,
                                            style: TextStyle(
                                                color: textColor,
                                                fontFamily: 'Segoe'),
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: emailCon,
                                            decoration: InputDecoration(
                                                hintText: 'someone@xyz.com',
                                                hintStyle: TextStyle(
                                                    color: textColor,
                                                    fontFamily: 'Segoe',
                                                    fontSize: width * 0.03)),
                                          ),
                                        ),
                                        SizedBox(height: 25),
                                        Text(
                                          'Password',
                                          style: TextStyle(
                                              color: textColor,
                                              fontFamily: 'Segoe',
                                              fontSize: width * 0.037),
                                        ),
                                        Container(
                                          width: width * 0.91,
                                          height: 50,
                                          child: Stack(
                                            children: [
                                              TextFormField(
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontFamily: 'Segoe'),
                                                obscureText: showPass,
                                                controller: passCon,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    focusColor:
                                                        Colors.grey[700],
                                                    fillColor: Colors.grey[700],
                                                    hintText: '********',
                                                    hintStyle: TextStyle(
                                                        color: textColor,
                                                        fontFamily: 'Segoe',
                                                        fontSize:
                                                            width * 0.03)),
                                              ),
                                              GestureDetector(
                                                onTap: toggle,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: showPass
                                                      ? Icon(
                                                          Icons.visibility_off,
                                                          size: 18,
                                                          color: blueTextColor,
                                                        )
                                                      : Icon(
                                                          Icons.visibility,
                                                          size: 18,
                                                          color: blueTextColor,
                                                        ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPassword()));
                                          },
                                          child: Text(
                                            'Forgot password?',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: blueTextColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: width - width * 0.08,
                                          child: GestureDetector(
                                            onTap: () async {
                                              FormState fs = fkey.currentState;
                                              fs.validate();
                                              if (emailCon == null ||
                                                  emailCon.text == '') {
                                                fToast.showToast(
                                                  child: ToastWidget.toast(
                                                      'Enter email',
                                                      Icon(Icons.error,
                                                          size: 20)),
                                                  toastDuration:
                                                      Duration(seconds: 2),
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              } else if (emailValidate == 1) {
                                                fToast.showToast(
                                                  child: ToastWidget.toast(
                                                      'Invalid email',
                                                      Icon(Icons.error,
                                                          size: 20)),
                                                  toastDuration:
                                                      Duration(seconds: 2),
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              } else if (passCon == null ||
                                                  passCon.text == '') {
                                                fToast.showToast(
                                                  child: ToastWidget.toast(
                                                      'Enter password',
                                                      Icon(Icons.error,
                                                          size: 20)),
                                                  toastDuration:
                                                      Duration(seconds: 2),
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              } else {
                                                try {
                                                  final result =
                                                      await InternetAddress
                                                          .lookup('google.com');
                                                  if (result.isNotEmpty &&
                                                      result[0]
                                                          .rawAddress
                                                          .isNotEmpty) {
                                                    setState(() {
                                                      login = false;
                                                    });
                                                    logIn();
                                                  }
                                                } on SocketException catch (_) {
                                                  setState(() {
                                                    login = false;
                                                  });
                                                  fToast.showToast(
                                                    child: ToastWidget.toast(
                                                        'You are not connected to the internet',
                                                        Icon(Icons.error,
                                                            size: 20)),
                                                    toastDuration:
                                                        Duration(seconds: 2),
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                  );
                                                }
                                              }
                                            },
                                            child: Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            Color(0xFF667EEA),
                                                        offset: Offset(0, 6),
                                                        blurRadius: 3,
                                                        spreadRadius: -4)
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        buttonColor1,
                                                        buttonColor2
                                                      ]),
                                                  color: Colors.yellow,
                                                ),
                                                height: 45,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                child: Center(
                                                  child: Text(
                                                    'Log in',
                                                    style: TextStyle(
                                                        color: buttonTextColor,
                                                        fontFamily: 'Segoe',
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        // Container(
                                        //   width: width - width * 0.08,
                                        //   child: Center(
                                        //     child: RichText(
                                        //       text: TextSpan(
                                        //         children: [
                                        //           TextSpan(
                                        //               text:
                                        //                   'Don\'t have an account? ',
                                        //               style: TextStyle(
                                        //                 color: textColor,
                                        //                 fontSize: height * 0.02,
                                        //                 fontFamily: 'Segoe',
                                        //               )),
                                        //           TextSpan(
                                        //               text: 'Sign Up',
                                        //               recognizer:
                                        //                   new TapGestureRecognizer()
                                        //                     ..onTap = () {
                                        //                       // Navigator.push(
                                        //                       //     context,
                                        //                       //     MaterialPageRoute(
                                        //                       //         builder:
                                        //                       //             (context) =>
                                        //                       //                 SignUp()));
                                        //                     },
                                        //               style: TextStyle(
                                        //                   color: blueTextColor,
                                        //                   fontSize:
                                        //                       height * 0.02,
                                        //                   fontFamily: 'Segoe',
                                        //                   fontWeight:
                                        //                       FontWeight.bold)),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
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
          login == null
              ? Container()
              : login == false
                  ? Container(
                      height: height,
                      width: width,
                      color: Colors.white.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(blueTextColor),
                          strokeWidth: 3,
                        ),
                      ))
                  : Container()
        ],
      ),
    );
  }
}

int validateEmail(String value) {
  if (value.isEmpty) return 2;

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = new RegExp(pattern);

  if (!regex.hasMatch(value.trim())) {
    return 1;
  }
  return 0;
}
