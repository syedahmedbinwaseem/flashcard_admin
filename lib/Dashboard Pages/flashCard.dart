import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/addNewDocument/add_session.dart';
import 'package:flashcard_admin/screens/ImageView.dart';
import 'package:flashcard_admin/screens/dashboard.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FlashCard extends StatefulWidget {
  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  NumberFormat formatter = new NumberFormat("00");
  bool isOpen = false;
  bool expand = false;
  bool isOpen2 = false;
  bool isOpen3 = false;
  double height = 0;
  double width = 0;
  double height2 = 0;
  double width2 = 0;
  double height3 = 0;
  double width3 = 0;
  double heighth = 0;
  double widthh = 0;
  String sessionId;
  String sessionTitle;
  String readID;
  String readTitle;
  int myIndex = 0;
  DocumentSnapshot flash;
  List<DocumentSnapshot> flashList = [];
  String imageUrl;
  List title = [];
  String flashId;
  String docId;
  String readId;
  double value = 0.4;
  NetworkImage image;
  bool isLoading;

  @override
  void initState() {
    isLoading=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    return WillPopScope(
      onWillPop: () {
        if (isOpen3 == true && isOpen2 == true && isOpen == true) {
          setState(() {
            title = [];
            flashList = [];
            myIndex = 0;
            height3 = 0;
            width3 = 0;
            isOpen3 = false;
          });
        } else if (isOpen2 == true && isOpen == true) {
          setState(() {
            title = [];
            myIndex = 0;

            flashList = [];
            height2 = 0;
            width2 = 0;
            isOpen2 = false;
          });
        } else if (isOpen == true) {
          setState(() {
            title = [];
            flashList = [];
            myIndex = 0;

            isOpen = false;
            height = 0;
            width = 0;
          });
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
              (route) => false);
        }

        return null;
      },
      child: Container(
        decoration: GlobalWidget.backGround(),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            floatingActionButton: _addButtton(0),
            backgroundColor: Colors.transparent,
            key: scaffoldKey,
            appBar: AppBar(
              title: isOpen == true
                  ? Container()
                  : Text(
                      'Flash Quiz',
                      style: TextStyle(color: headingColor),
                    ),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.home, color: Colors.black),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                        (route) => false);
                  }),
              elevation: 0,
              flexibleSpace: Container(
                padding: EdgeInsets.only(top: padding.top + 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    buttonColor2,
                    buttonColor1,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Stack(
                  children: [
                    isOpen == true && isOpen2 == true && isOpen3 == true
                        ? Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      title = [];
                                      flashList = [];
                                      isOpen = false;
                                      myIndex = 0;

                                      height = 0;
                                      width = 0;
                                      height2 = 0;
                                      height3 = 0;
                                      width2 = 0;
                                      width3 = 0;
                                      isOpen2 = false;
                                      isOpen3 = false;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        border: Border.all(
                                            color: Colors.black.withOpacity(0.3)),
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            colors: [buttonColor1, buttonColor2],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                    child: Center(
                                      child: Text('SS',
                                          style: TextStyle(
                                              color: buttonTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      title = [];
                                      flashList = [];
                                      myIndex = 0;

                                      isOpen3 = false;
                                      height3 = 0;
                                      width3 = 0;
                                      height2 = 0;
                                      width2 = 0;
                                      isOpen2 = false;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        border: Border.all(
                                            color: Colors.black.withOpacity(0.3)),
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            colors: [buttonColor1, buttonColor2],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                    child: Center(
                                      child: Text('R',
                                          style: TextStyle(
                                              color: buttonTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      title = [];
                                      flashList = [];
                                      myIndex = 0;

                                      isOpen3 = false;
                                      height3 = 0;
                                      width3 = 0;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        border: Border.all(
                                            color: Colors.black.withOpacity(0.3)),
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            colors: [buttonColor1, buttonColor2],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                    child: Center(
                                      child: Text('FC',
                                          style: TextStyle(
                                              color: buttonTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : isOpen == true && isOpen2 == true
                            ? Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          title = [];
                                          flashList = [];
                                          myIndex = 0;

                                          isOpen = false;
                                          height = 0;
                                          width = 0;
                                          width2 = 0;
                                          height2 = 0;
                                          isOpen2 = false;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                                colors: [
                                                  buttonColor1,
                                                  buttonColor2
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        child: Center(
                                          child: Text('SS',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: buttonTextColor,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          title = [];
                                          flashList = [];
                                          myIndex = 0;

                                          isOpen2 = false;
                                          height2 = 0;
                                          width2 = 0;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                                colors: [
                                                  buttonColor1,
                                                  buttonColor2
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        child: Center(
                                          child: Text('R',
                                              style: TextStyle(
                                                  color: buttonTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : isOpen == true
                                ? Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          title = [];
                                          flashList = [];
                                          myIndex = 0;

                                          isOpen = false;
                                          height = 0;
                                          width = 0;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                                colors: [
                                                  buttonColor1,
                                                  buttonColor2
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        child: Center(
                                          child: Text('SS',
                                              style: TextStyle(
                                                  color: buttonTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                    // : Align(
                    //     alignment: Alignment.center,
                    //     child: Text(
                    //       'Flash Cards',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.w700,
                    //           fontSize: 18),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),

            ///******************
            ///ISOPen for Sesssions
            ///isOpen2 for Readings
            ///isOpen3 for FCs  */
            body: isOpen == true && isOpen2 == false && isOpen3 == false

                ///*********************************** Enlisting Readings ********************  */
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('level1')
                        .doc(docId)
                        .collection('readings')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return Column(
                        children: [
                          //Header 'Level 1 FLASH CARDS'
                          Container(
                            height: 75,
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  height: 75,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black,
                                          spreadRadius: -3,
                                          blurRadius: 10,
                                          offset: Offset(-1, -1)),
                                    ],
                                    gradient: LinearGradient(
                                        colors: [buttonColor1, buttonColor2],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Center(
                                          child: Text(
                                            'LEVEL 1 FLASH CARDS',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        sessionId + "\t\t\t" + sessionTitle,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10)),
                                      child: Image.asset(
                                          'assets/images/circlee.png'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          //List of Readings
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data == null
                                    ? 0
                                    : snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return snapshot.data.docs.isEmpty
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  blueTextColor),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FlatButton(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                highlightColor:
                                                    buttonColor2.withOpacity(0.3),
                                                onPressed: () {
                                                  setState(() {
                                                    isOpen2 = true;
                                                    readId = snapshot
                                                        .data.docs[index].id;
                                                    readID = snapshot
                                                        .data.docs[index]['id'];
                                                    readTitle = snapshot.data
                                                        .docs[index]['title'];
                                                  });
                                                },
                                                // Reading data
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        formatter.format(
                                                                index + 1) +
                                                            "\t\t\t\t" +
                                                            snapshot.data
                                                                    .docs[index]
                                                                ['title'],
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 15),
                                                      ),
                                                      Icon(Icons.delete)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Divider(height: 0)
                                            ],
                                          ),
                                        );
                                }),
                          ),
                        ],
                      );
                    },
                  )
                : isOpen == true && isOpen2 == true && isOpen3 == false
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('level1')
                            .doc(docId)
                            .collection('readings')
                            .doc(readId)
                            .collection('flashcards')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          return Column(
                            children: [
                              Container(
                                height: 110,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 110,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black,
                                                spreadRadius: -3,
                                                blurRadius: 10,
                                                offset: Offset(-1, -1)),
                                          ],
                                          gradient: LinearGradient(
                                              colors: [
                                                buttonColor1,
                                                buttonColor2
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10))),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Center(
                                              child: Text(
                                                'LEVEL 1 FLASH CARDS',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            sessionId + "\t\t\t" + sessionTitle,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            readID + "\t\t" + readTitle,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        height: 60,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10)),
                                          child: Image.asset(
                                              'assets/images/circlee.png'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data == null
                                        ? 0
                                        : snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      return !snapshot.hasData
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      blueTextColor),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FlatButton(
                                                    height: 40,
                                                    padding: EdgeInsets.only(
                                                        left: 8, right: 8),
                                                    highlightColor: buttonColor2
                                                        .withOpacity(0.3),
                                                    onPressed: () async {
                                                      flash =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'level1')
                                                              .doc(docId)
                                                              .collection(
                                                                  'readings')
                                                              .doc(readId)
                                                              .collection(
                                                                  'flashcards')
                                                              .doc(snapshot.data
                                                                  .docs[index].id)
                                                              .get();
                                                      snapshot.data.docs
                                                          .forEach((element) {
                                                        setState(() {
                                                          flashList.add(element);
                                                        });
                                                      });

                                                      print(index);
                                                      setState(() {
                                                        //abcd
                                                        myIndex = index;
                                                        isOpen3 = true;
                                                        flashId = snapshot
                                                            .data.docs[index].id;
                                                      });
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        formatter.format(
                                                                index + 1) +
                                                            '\t\t\t\t' +
                                                            snapshot.data
                                                                    .docs[index]
                                                                ['title'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(height: 0)
                                                ],
                                              ),
                                            );
                                    }),
                              ),
                            ],
                          );
                        },
                      )
                    : isOpen == true && isOpen2 == true && isOpen3 == true
                        ? Scaffold(
                            floatingActionButton: flashList.length > 1 &&
                                    flashList.length - 1 != myIndex
                                ? Container(
                                    height: 45,
                                    width: 45,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        setState(() {
                                          myIndex++;
                                        });
                                      },
                                      child: Center(
                                          child: Icon(
                                        Icons.arrow_forward,
                                        size: 22.5,
                                      )),
                                      backgroundColor: buttonColor2,
                                    ),
                                  )
                                : Container(),
                            body: Stack(
                              children: [
                                Container(
                                  decoration: GlobalWidget.backGround(),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 110,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 110,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black,
                                                        spreadRadius: -3,
                                                        blurRadius: 10,
                                                        offset: Offset(-1, -1)),
                                                  ],
                                                  // color: Color(0xffC8BF06),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        buttonColor1,
                                                        buttonColor2
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end:
                                                          Alignment.bottomCenter),
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10))),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    child: Center(
                                                      child: Text(
                                                        'LEVEL 1 FLASH CARDS',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  Text(
                                                    sessionId +
                                                        "\t\t\t" +
                                                        sessionTitle,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    readID + "\t\t" + readTitle,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 60,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(10)),
                                                  child: Image.asset(
                                                      'assets/images/circlee.png'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 50),
                                                  Container(
                                                    height: 50,
                                                    child: Material(
                                                      shadowColor: Colors.black,
                                                      elevation: 1,
                                                      borderRadius: expand == true
                                                          ? BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10))
                                                          : BorderRadius.circular(
                                                              10),
                                                      color: buttonColor2,
                                                      child: InkWell(
                                                        splashColor: buttonColor1
                                                            .withOpacity(0.6),
                                                        onTap: () {
                                                          if (expand == false) {
                                                            setState(() {
                                                              // heighth = 50;
                                                              widthh =
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width;
                                                              expand = !expand;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              // heighth = 0;
                                                              widthh = 0;
                                                              expand = !expand;
                                                            });
                                                          }
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Text(
                                                              flashList[myIndex]
                                                                  ['title'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                  color:
                                                                      headingColor),
                                                            ),
                                                            SizedBox(
                                                              width: 50,
                                                            ),
                                                            expand == false
                                                                ? Icon(
                                                                    Icons
                                                                        .arrow_downward_outlined,
                                                                    color: Colors
                                                                        .black)
                                                                : Icon(
                                                                    Icons
                                                                        .arrow_upward_outlined,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  AnimatedContainer(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      10)),
                                                      color: buttonColor2,
                                                    ),
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 10,
                                                        top: 10),
                                                    width: widthh,
                                                    height: (flashList[myIndex]
                                                                .data()
                                                                .containsKey(
                                                                    'img_link') &&
                                                            flashList[myIndex]
                                                                    ['img_link']
                                                                .toString()
                                                                .isNotEmpty)
                                                        ? 200
                                                        : 70,
                                                    duration: Duration(
                                                        microseconds: 1000),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          flashList[myIndex]
                                                              ['body'],
                                                          style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 15),
                                                        ),
                                                        SizedBox(height: 10),
                                                        (flashList[myIndex]
                                                                    .data()
                                                                    .containsKey(
                                                                        'img_link') &&
                                                                flashList[myIndex]
                                                                        [
                                                                        'img_link']
                                                                    .toString()
                                                                    .isNotEmpty)
                                                            ? InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    imageUrl = flashList[
                                                                            myIndex]
                                                                        [
                                                                        'img_link'];
                                                                    image = NetworkImage(
                                                                        flashList[
                                                                                myIndex]
                                                                            [
                                                                            'img_link']);
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => flashList[myIndex]['img_link'].toString().isEmpty
                                                                              ? Container()
                                                                              : ImageView(
                                                                                  image: NetworkImage(flashList[myIndex]['img_link']),
                                                                                  url: flashList[myIndex]['img_link'],
                                                                                )));
                                                                },
                                                                child: Hero(
                                                                  tag: 'image',
                                                                  child:
                                                                      Container(
                                                                    height: 150,
                                                                    width: widthh,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl: flashList[myIndex]
                                                                                [
                                                                                'img_link']
                                                                            .toString(),
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        progressIndicatorBuilder: (context,
                                                                                url,
                                                                                downloadProgress) =>
                                                                            Center(
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                35,
                                                                            width:
                                                                                35,
                                                                            child: CircularProgressIndicator(
                                                                                backgroundColor: Colors.white,
                                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                                  Color.fromRGBO(102, 126, 234, 1),
                                                                                ),
                                                                                strokeWidth: 3,
                                                                                value: downloadProgress.progress),
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Icon(Icons
                                                                                .error),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                flashList.length != 1 && myIndex != 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, bottom: 15),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            child: FloatingActionButton(
                                                onPressed: () {
                                                  setState(() {
                                                    myIndex--;
                                                  });
                                                },
                                                backgroundColor: buttonColor2,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.arrow_back,
                                                    size: 22.5,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          )

                        ///*********************************** Enlisting Readings ********************  */
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('level1')
                                .snapshots(),
                            builder:
                                (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              return Column(
                                children: [
                                  //Header
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: 48,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 48,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black,
                                                      spreadRadius: -3,
                                                      blurRadius: 10,
                                                      offset: Offset(-1, -1)),
                                                ],
                                                gradient: LinearGradient(
                                                    colors: [
                                                      buttonColor1,
                                                      buttonColor2
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 0),
                                              child: Center(
                                                child: Text(
                                                  'LEVEL 1 FLASH CARDS',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              height: 60,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                child: Image.asset(
                                                    'assets/images/circlee.png'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: snapshot.data == null
                                            ? 0
                                            : snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          return !snapshot.hasData
                                              ? CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(blueTextColor),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Slidable(
                                                        actionPane:
                                                            SlidableDrawerActionPane(),
                                                        child: FlatButton(
                                                          height: 40,
                                                          highlightColor:
                                                              buttonColor2
                                                                  .withOpacity(
                                                                      0.3),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8),
                                                          minWidth: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          onPressed: () {
                                                            setState(() {
                                                              isOpen = true;
                                                              docId = snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id;
                                                              sessionId = snapshot
                                                                      .data
                                                                      .docs[index]
                                                                  ['id'];
                                                              sessionTitle =
                                                                  snapshot.data
                                                                              .docs[
                                                                          index]
                                                                      ['title'];
                                                            });
                                                          },
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              formatter.format(
                                                                      index + 1) +
                                                                  "\t\t\t\t\t" +
                                                                  snapshot.data
                                                                              .docs[
                                                                          index]
                                                                      ['title'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        secondaryActions: <
                                                            Widget>[
                                                          IconSlideAction(
                                                            caption: 'Edit',
                                                            color: Colors.black45,
                                                            icon: Icons.edit,
                                                            onTap: () {
                                                              _editSession(
                                                                  snapshot
                                                                      .data
                                                                      .docs[index]
                                                                      .id,
                                                                  snapshot.data
                                                                              .docs[
                                                                          index]
                                                                      ['title']);
                                                            },
                                                          ),
                                                          IconSlideAction(
                                                            caption: 'Delete',
                                                            color: Colors.red,
                                                            icon: Icons.delete,
                                                            onTap: () {
                                                              _deleteSession(
                                                                  snapshot
                                                                      .data
                                                                      .docs[index]
                                                                      .id,
                                                                  snapshot.data
                                                                              .docs[
                                                                          index]
                                                                      ['title']);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(height: 0)
                                                    ],
                                                  ),
                                                );
                                        }),
                                  ),
                                ],
                              );
                            },
                          ),
          ),
        ),
      ),
    );
  }

  _editSession(String sessionId, String title) {
    TextEditingController textController = TextEditingController(text: title);
    GlobalKey<FormState> fKey=GlobalKey<FormState>();
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Edit Session Title'),
          content: Container(
            height: 70,
            child: SingleChildScrollView(
              child: Form(
                key: fKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: textController,
                      validator: (input) {
                        return input.isEmpty ? 'Session Name is required!' : null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7))),
                          labelText: 'Session Title'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black26,
              child: Text("Cancel"),
            ),
            RaisedButton(
              onPressed: () async{
                if(fKey.currentState.validate()){
                  setState(() {
                    isLoading=true;
                  });
                  Navigator.pop(context);
                  await FirebaseFirestore.instance.collection('level1').doc(sessionId).update({
                    'title': textController.text
                  });
                  setState(() {
                    isLoading=false;
                  });
                }
              },
              color: buttonColor2,
              child: Text("Save"),
            ),
          ],
        ));
  }

  _deleteSession(String sessionId, String title) {
    TextEditingController textController = TextEditingController(text: title);
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'Warning',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Are you sure you want to delete $title session?',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black26,
              child: Text("No"),
            ),
            RaisedButton(
              onPressed: () async{
                setState(() {
                  isLoading=true;
                });
                Navigator.pop(context);
                await FirebaseFirestore.instance.collection('level1').doc(sessionId).delete();
                setState(() {
                  isLoading=false;
                });
              },
              color: buttonColor2,
              child: Text("Yes"),
            ),
          ],
        ));
  }

  Widget _addButtton(int addTo) {
    // addTo will check what to add //Either session or reading or FC
    return Container(
      child: GestureDetector(
        onTap: (){
          if (addTo == 0) {
            _addSession();
          }
        },
        child: CircleAvatar(
          backgroundColor: buttonColor2,
          child: Icon(Icons.add, color: Colors.white),
        ),
      )
    );
    
  }

  _addSession() {
    showDialog(context: context, barrierDismissible: false, child: AddSession());
  }
}
