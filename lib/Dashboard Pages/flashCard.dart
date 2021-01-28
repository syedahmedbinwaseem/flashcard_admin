import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flashcard_admin/addNewDocument/add_fc.dart';
import 'package:flashcard_admin/addNewDocument/add_reading.dart';
import 'package:flashcard_admin/addNewDocument/add_session.dart';
import 'package:flashcard_admin/screens/ImageView.dart';
import 'package:flashcard_admin/screens/dashboard.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  FToast fToast;
  String readID;
  int addToNumber = 0;
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
  File _image;
  final picker = ImagePicker();
  bool added = false;
  String imagePath;

  Future uploadFile() async {
    if (_image == null) {
    } else {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('FC-Images/${Timestamp.now().toString()}');
        UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.whenComplete(() async {
          await storageReference.getDownloadURL().then((value) {
            imagePath = value;
          });
        });
        print('File Uploaded');
      } catch (e) {
        fToast.showToast(
          child: ToastWidget.toast(
              'Cannot add image', Icon(Icons.error, size: 20)),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          added = true;
        });
      } else {
        fToast.showToast(
          child: ToastWidget.toast(
              'Cannot add image', Icon(Icons.error, size: 20)),
          toastDuration: Duration(seconds: 2),
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  @override
  void initState() {
    isLoading = false;
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
            addToNumber--;
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
            addToNumber--;
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
            floatingActionButton:
                isOpen3 == true && isOpen2 == true && isOpen == true
                    ? Container()
                    : _addButtton(),
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
                                      addToNumber--;
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
                                            color:
                                                Colors.black.withOpacity(0.3)),
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
                                      addToNumber--;
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
                                            color:
                                                Colors.black.withOpacity(0.3)),
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
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            colors: [
                                              buttonColor1,
                                              buttonColor2
                                            ],
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
                                          addToNumber--;
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
                                          addToNumber--;
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
                                          addToNumber--;
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
                        .orderBy('created_at', descending: true)
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
                                        sessionTitle,
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
                                              Slidable(
                                                actionPane:
                                                    SlidableDrawerActionPane(),
                                                child: FlatButton(
                                                  height: 40,
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  highlightColor: buttonColor2
                                                      .withOpacity(0.3),
                                                  onPressed: () {
                                                    setState(() {
                                                      addToNumber = 2;
                                                      isOpen2 = true;
                                                      readId = snapshot
                                                          .data.docs[index].id;
                                                      readID = snapshot.data
                                                          .docs[index]['id'];
                                                      readTitle = snapshot.data
                                                          .docs[index]['title'];
                                                    });
                                                  },
                                                  // Reading data
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
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
                                                                          .docs[
                                                                      index]
                                                                  ['title'],
                                                          style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                secondaryActions: <Widget>[
                                                  IconSlideAction(
                                                    caption: 'Edit',
                                                    color: Colors.black45,
                                                    icon: Icons.edit,
                                                    onTap: () {
                                                      _editReading(
                                                          docId,
                                                          snapshot.data
                                                              .docs[index].id,
                                                          snapshot.data
                                                                  .docs[index]
                                                              ['title']);
                                                    },
                                                  ),
                                                  IconSlideAction(
                                                    caption: 'Delete',
                                                    color: Colors.red,
                                                    icon: Icons.delete,
                                                    onTap: () {
                                                      _deleteReadings(
                                                          docId,
                                                          snapshot.data
                                                              .docs[index].id,
                                                          snapshot.data
                                                                  .docs[index]
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
                  )
                : isOpen == true && isOpen2 == true && isOpen3 == false
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('level1')
                            .doc(docId)
                            .collection('readings')
                            .doc(readId)
                            .collection('flashcards')
                            .orderBy('created_at', descending: true)
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
                                              bottomRight:
                                                  Radius.circular(10))),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            sessionTitle,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            readTitle,
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
                                                  Slidable(
                                                    //fc
                                                    actionPane:
                                                        SlidableDrawerActionPane(),
                                                    child: FlatButton(
                                                      height: 40,
                                                      padding: EdgeInsets.only(
                                                          left: 8, right: 8),
                                                      highlightColor:
                                                          buttonColor2
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
                                                                .doc(snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .id)
                                                                .get();
                                                        snapshot.data.docs
                                                            .forEach((element) {
                                                          setState(() {
                                                            flashList
                                                                .add(element);
                                                          });
                                                        });

                                                        setState(() {
                                                          myIndex = index;
                                                          isOpen3 = true;
                                                          flashId = snapshot
                                                              .data
                                                              .docs[index]
                                                              .id;
                                                        });
                                                      },
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          formatter.format(
                                                                  index + 1) +
                                                              '\t\t\t\t' +
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ['title'],
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    secondaryActions: <Widget>[
                                                      IconSlideAction(
                                                        caption: 'Edit',
                                                        color: Colors.black45,
                                                        icon: Icons.edit,
                                                        onTap: () {
                                                          setState(() {
                                                            added = false;
                                                          });
                                                          _editFC(
                                                              docId,
                                                              readId,
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id,
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ['title'],
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ['body'],
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ['img_link']);
                                                        },
                                                      ),
                                                      IconSlideAction(
                                                        caption: 'Delete',
                                                        color: Colors.red,
                                                        icon: Icons.delete,
                                                        onTap: () {
                                                          _deleteFC(
                                                              docId,
                                                              readId,
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
                                                      begin: Alignment
                                                          .topCenter,
                                                      end: Alignment
                                                          .bottomCenter),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  Text(
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
                                                    readTitle,
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  child: Image.asset(
                                                      'assets/images/circlee.png'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ScrollConfiguration(
                                          behavior: MyBehavior(),
                                          child: ListView(
                                            padding:
                                                EdgeInsets.only(bottom: 70),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(height: 50),
                                                          Container(
                                                            height: 50,
                                                            child: Material(
                                                              shadowColor:
                                                                  Colors.black,
                                                              elevation: 1,
                                                              borderRadius: expand ==
                                                                      true
                                                                  ? BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10))
                                                                  : BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  buttonColor2,
                                                              child: InkWell(
                                                                splashColor:
                                                                    buttonColor1
                                                                        .withOpacity(
                                                                            0.6),
                                                                onTap: () {
                                                                  if (expand ==
                                                                      false) {
                                                                    setState(
                                                                        () {
                                                                      // heighth = 50;
                                                                      widthh = MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width;
                                                                      expand =
                                                                          !expand;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      // heighth = 0;
                                                                      widthh =
                                                                          0;
                                                                      expand =
                                                                          !expand;
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
                                                                      flashList[
                                                                              myIndex]
                                                                          [
                                                                          'title'],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              headingColor),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 50,
                                                                    ),
                                                                    expand ==
                                                                            false
                                                                        ? Icon(
                                                                            Icons
                                                                                .arrow_downward_outlined,
                                                                            color:
                                                                                Colors.black)
                                                                        : Icon(
                                                                            Icons.arrow_upward_outlined,
                                                                            color:
                                                                                Colors.black,
                                                                          )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          AnimatedContainer(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                              color:
                                                                  buttonColor2,
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    bottom: 10,
                                                                    top: 10),
                                                            width: widthh,
                                                            height: (flashList[myIndex]
                                                                            .data()
                                                                            .containsKey(
                                                                                'img_link') &&
                                                                        flashList[myIndex]['img_link']
                                                                            .toString()
                                                                            .isNotEmpty) &&
                                                                    flashList[myIndex]
                                                                            [
                                                                            'img_link'] !=
                                                                        null
                                                                ? 200
                                                                : 70,
                                                            duration: Duration(
                                                                microseconds:
                                                                    1000),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  flashList[
                                                                          myIndex]
                                                                      ['body'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          textColor,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                (flashList[myIndex].data().containsKey('img_link') &&
                                                                            flashList[myIndex]['img_link']
                                                                                .toString()
                                                                                .isNotEmpty) &&
                                                                        flashList[myIndex]['img_link'] !=
                                                                            null
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            imageUrl =
                                                                                flashList[myIndex]['img_link'];
                                                                            image =
                                                                                NetworkImage(flashList[myIndex]['img_link']);
                                                                          });
                                                                          Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => flashList[myIndex]['img_link'].toString().isEmpty || flashList[myIndex]['img_link'] == null
                                                                                  ? Container()
                                                                                  : ImageView(
                                                                                      image: NetworkImage(flashList[myIndex]['img_link']),
                                                                                      url: flashList[myIndex]['img_link'],
                                                                                    )));
                                                                        },
                                                                        child:
                                                                            Hero(
                                                                          tag:
                                                                              'image',
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                widthh,
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: flashList[myIndex]['img_link'].toString(),
                                                                                fit: BoxFit.cover,
                                                                                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                                  child: SizedBox(
                                                                                    height: 35,
                                                                                    width: 35,
                                                                                    child: CircularProgressIndicator(
                                                                                        backgroundColor: Colors.white,
                                                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                                                          Color.fromRGBO(102, 126, 234, 1),
                                                                                        ),
                                                                                        strokeWidth: 3,
                                                                                        value: downloadProgress.progress),
                                                                                  ),
                                                                                ),
                                                                                errorWidget: (context, url, error) => Icon(Icons.error),
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
                                .orderBy('created_at', descending: true)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                          minWidth:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                          onPressed: () {
                                                            setState(() {
                                                              addToNumber = 1;
                                                              isOpen = true;
                                                              docId = snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id;
                                                              sessionId = snapshot
                                                                      .data
                                                                      .docs[
                                                                  index]['id'];
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
                                                                      index +
                                                                          1) +
                                                                  "\t\t\t\t\t" +
                                                                  snapshot.data
                                                                              .docs[
                                                                          index]
                                                                      ['title'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        secondaryActions: <
                                                            Widget>[
                                                          IconSlideAction(
                                                            caption: 'Edit',
                                                            color:
                                                                Colors.black45,
                                                            icon: Icons.edit,
                                                            onTap: () {
                                                              _editSession(
                                                                  snapshot
                                                                      .data
                                                                      .docs[
                                                                          index]
                                                                      .id,
                                                                  snapshot.data
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'title']);
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
                                                                      .docs[
                                                                          index]
                                                                      .id,
                                                                  snapshot.data
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'title']);
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
    GlobalKey<FormState> fKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: GlobalWidget.backGround(),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Form(
                      key: fKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Edit Session Title',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Theme(
                            data: new ThemeData(
                              primaryColor: Colors.grey[700],
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontFamily: 'Segoe'),
                              controller: textController,
                              validator: (input) {
                                return input.isEmpty
                                    ? 'Session Name is required!'
                                    : null;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.grey[700],
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: 'Session Title',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Segoe', fontSize: 12)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
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
                                    if (fKey.currentState.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      Navigator.pop(context);
                                      await FirebaseFirestore.instance
                                          .collection('level1')
                                          .doc(sessionId)
                                          .update(
                                              {'title': textController.text});
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Save',
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
                    )),
              ),
            ),
          );
        });
  }

  _deleteSession(String sessionId, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                    'Are you sure you want to delete: $title?',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(right: 10),
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontFamily: 'Segoe',
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              Navigator.pop(context);
                              await FirebaseFirestore.instance
                                  .collection('level1')
                                  .doc(sessionId)
                                  .delete();
                              setState(() {
                                isLoading = false;
                              });
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
              )),
        );
      },
    );
  }

  _editReading(String sessionId, String readId, String title) {
    TextEditingController textController = TextEditingController(text: title);

    GlobalKey<FormState> fKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: GlobalWidget.backGround(),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Form(
                      key: fKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Edit Reading Title',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Theme(
                            data: new ThemeData(
                              primaryColor: Colors.grey[700],
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontFamily: 'Segoe'),
                              controller: textController,
                              validator: (input) {
                                return input.isEmpty
                                    ? 'Reading title is required!'
                                    : null;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.grey[700],
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: 'Reading Title',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Segoe', fontSize: 12)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
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
                                    if (fKey.currentState.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      Navigator.pop(context);
                                      await FirebaseFirestore.instance
                                          .collection('level1')
                                          .doc(sessionId)
                                          .collection('readings')
                                          .doc(readId)
                                          .update(
                                              {'title': textController.text});
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Save',
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
                    )),
              ),
            ),
          );
        });
  }

  _deleteReadings(String sessionId, String readId, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                    'Are you sure you want to delete: $title?',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(right: 10),
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontFamily: 'Segoe',
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              Navigator.pop(context);
                              await FirebaseFirestore.instance
                                  .collection('level1')
                                  .doc(sessionId)
                                  .collection('readings')
                                  .doc(readId)
                                  .delete();
                              setState(() {
                                isLoading = false;
                              });
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
              )),
        );
      },
    );
  }

  _editFC(String sessionId, String readId, String fcId, String title,
      String body, String imgUrl) {
    TextEditingController textController = TextEditingController(text: title);
    TextEditingController bodyController = TextEditingController(text: body);
    GlobalKey<FormState> fKey = GlobalKey<FormState>();
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
                        child: Form(
                          key: fKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Edit Flashcard Title',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.grey[700],
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(fontFamily: 'Segoe'),
                                  controller: textController,
                                  validator: (input) {
                                    return input.isEmpty
                                        ? 'Flashcard title is required!'
                                        : null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  cursorColor: Colors.grey[700],
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      hintText: 'Flashcard Title',
                                      hintStyle: TextStyle(
                                          fontFamily: 'Segoe', fontSize: 12)),
                                ),
                              ),
                              Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.grey[700],
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(fontFamily: 'Segoe'),
                                  controller: bodyController,
                                  validator: (input) {
                                    return input.isEmpty
                                        ? 'Flashcard body is required!'
                                        : null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  cursorColor: Colors.grey[700],
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      hintText: 'Flashcard Body',
                                      hintStyle: TextStyle(
                                          fontFamily: 'Segoe', fontSize: 12)),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  getImage().then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Container(
                                  height: imgUrl == null
                                      ? 40
                                      : added == true
                                          ? 40
                                          : 80,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: buttonColor1,
                                  ),
                                  child: added == true
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    'Image added',
                                                    style: TextStyle(
                                                        fontFamily: 'Segoe',
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Icon(Icons.done)),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        imgUrl == null
                                                            ? 'Add primary image'
                                                            : 'Edit primary image',
                                                        style: TextStyle(
                                                            fontFamily: 'Segoe',
                                                            fontSize: 13),
                                                      ))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Container(
                                                height: 65,
                                                width: 65,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: imgUrl == null
                                                        ? null
                                                        : imgUrl,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Center(
                                                      child: SizedBox(
                                                        height: 35,
                                                        width: 35,
                                                        child:
                                                            CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                strokeWidth: 3,
                                                                value: downloadProgress
                                                                    .progress),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(
                                                      Icons
                                                          .add_a_photo_outlined,
                                                      size: 23,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
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

                                        await uploadFile().then((value) {
                                          FirebaseFirestore.instance
                                              .collection('level1')
                                              .doc(sessionId)
                                              .collection('readings')
                                              .doc(readId)
                                              .collection('flashcards')
                                              .doc(fcId)
                                              .update({
                                            'title': textController.text,
                                            'body': bodyController.text,
                                            'img_link': imagePath
                                          });
                                        });
                                        Navigator.pop(context);
                                        setState(() {
                                          isLoading = false;
                                          _image = null;
                                        });
                                      },
                                      child: Text(
                                        'Save',
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
                        )),
                  ),
                ),
              ),
            );
          });
        });
  }

  _deleteFC(String sessionId, String readId, String fcId, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                    'Are you sure you want to delete: $title?',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(right: 10),
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontFamily: 'Segoe',
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              Navigator.pop(context);
                              await FirebaseFirestore.instance
                                  .collection('level1')
                                  .doc(sessionId)
                                  .collection('readings')
                                  .doc(readId)
                                  .collection('flashcards')
                                  .doc(fcId)
                                  .delete();
                              setState(() {
                                isLoading = false;
                              });
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
              )),
        );
      },
    );
  }

  Widget _addButtton() {
    // addTo will check what to add //Either session or reading or FC
    return FloatingActionButton(
      backgroundColor: buttonColor2,
      onPressed: () {
        if (addToNumber == 0) {
          _addSession();
        } else if (addToNumber == 1) {
          _addReading();
        } else if (addToNumber == 2) {
          _addFC();
        }
      },
      child: Center(
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  _addSession() {
    showDialog(
        context: context, barrierDismissible: false, child: AddSession());
  }

  _addReading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AddReading(
          docId: docId,
        ));
  }

  _addFC() {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AddFC(docId: docId, readId: readId));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
