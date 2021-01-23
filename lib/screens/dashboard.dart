import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_admin/screens/bottomNavigation.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> primaryEmails;
  bool primary;
  @override
  void initState() {
    primary = false;
    // Future.delayed(Duration(seconds: 5), () {
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

    return Container(
      decoration: GlobalWidget.backGround(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldState,
        drawer: _drawer(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Center(
                      child: Container(
                    height: 150,
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.fitHeight,
                    ),
                  )),

                  SizedBox(
                    height: 50,
                  ),
                  //FlashCards
                  GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width * .8,
                        height: MediaQuery.of(context).size.height * .18,
                        decoration: _cardDecoration(),
                        child: Center(
                          child: Text(
                            'FLASHCARDS',
                            style: TextStyle(
                              color: blackTextColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                    blurRadius: 5,
                                    color: Colors.white,
                                    offset: Offset(2, 2))
                              ]),
                        ),
                      )),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BottomNavigator(
                          initIndex: 0,
                        ),
                      ));
                    },
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  //FlashQuix
                  GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width * .8,
                        height: MediaQuery.of(context).size.height * .18,
                        decoration: _cardDecoration(),
                        child: Center(
                          child: Text(
                            'FLASHQUIZ',
                            style: TextStyle(
                                color: blackTextColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      blurRadius: 5,
                                      color: Colors.white,
                                      offset: Offset(2, 2))
                                ]),
                          ),
                        )),
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => BottomNavigator(
                      //     initIndex: 1,
                      //   ),
                      // ));
                    },
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  //Exam Tips
                  GestureDetector(
                    child: InkWell(
                      splashColor: Colors.pink,
                      focusColor: Colors.pink,
                      highlightColor: Colors.pink,
                      hoverColor: Colors.pink,
                      child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          height: MediaQuery.of(context).size.height * .18,
                          decoration: _cardDecoration(),
                          child: Center(
                            child: Text(
                              'EXAM TIPS',
                              style: TextStyle(
                                  color: blackTextColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 5,
                                        color: Colors.white,
                                        offset: Offset(2, 2))
                                  ]),
                            ),
                          )),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BottomNavigator(
                          initIndex: 2,
                        ),
                      ));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    child: Text(
                      'CFA is a registeted trademark of the\nCFA Institute, USA.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: blackTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Text(
                      '© Nodal Educational Training LLC',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: blueTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  )
                ],
              ),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                height: 70,
                child: IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: blueTextColor,
                  ),
                  onPressed: () {
                    scaffoldState.currentState.openDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _cardDecoration() {
    return BoxDecoration(
      image: DecorationImage(image: AssetImage('assets/images/card.png')),
    );
  }

  _drawer() {
    return Drawer(
      child: Container(
        decoration: GlobalWidget.backGround(),
        child: Column(
          children: [
            SafeArea(
              child: Container(
                height: 5,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 30,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: headingColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Container(
                height: 120,
                child: Center(
                    child: Image.asset('assets/images/logo.png',
                        fit: BoxFit.fitWidth))),
            Divider(),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Divider(),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => TipsHistory()));
              },
              child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tips History',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Divider(),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);

                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => QuizHistory()));
              },
              child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quiz History',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Divider(),
            FlatButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (e) {}
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Divider(),
            FlatButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => TermsAndConditions()));
              },
              child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Terms And Conditions',
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
