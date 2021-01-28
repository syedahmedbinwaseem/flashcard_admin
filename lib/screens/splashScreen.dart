import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashcard_admin/screens/dashboard.dart';
import 'package:flashcard_admin/screens/login.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getUser() async {
    Firebase.initializeApp().then((value) async {
      User admin = FirebaseAuth.instance.currentUser;
      if (admin == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Dashboard()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), getUser);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: GlobalWidget.backGround(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.11,
              ),
              Container(
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'CFA',
                        style: TextStyle(
                            color: blackTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                        children: [
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(0, -26),
                              child: Text(
                                '®',
                                //superscript is usually smaller in size
                                textScaleFactor: 0.7,
                                style: TextStyle(
                                    color: blackTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28),
                              ),
                            ),
                          ),
                          TextSpan(
                              text: ' 2021',
                              style: TextStyle(
                                  color: blackTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40),
                              children: []),
                          TextSpan(
                              text: '\nAdmin Console',
                              style: TextStyle(
                                  color: yellowTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32),
                              children: []),
                        ])),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [buttonColor1, buttonColor2],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: GestureDetector(
                  onTap: () {
                    getUser();
                  },
                  child: Container(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                padding: EdgeInsets.all(0),
                child: Text(
                  'CFA is a registeted trademark of the\nCFA Institute, USA.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blackTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  '© Nodal Educational Training LLC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: blueTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
