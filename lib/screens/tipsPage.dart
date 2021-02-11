import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TipsPage extends StatefulWidget {
  List<DocumentSnapshot> allTips;
  int myIndex;
  int appBarIndex;

  TipsPage({this.allTips, this.myIndex, this.appBarIndex});
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GlobalWidget.backGround(),
      child: Scaffold(
        floatingActionButton: widget.allTips.length > 1 &&
                widget.allTips.length - 1 != widget.myIndex
            ? Container(
                height: 45,
                width: 45,
                child: Center(
                  child: FloatingActionButton(
                    heroTag: 'forward',
                    backgroundColor: buttonColor2,
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward,
                        size: 22.5,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.myIndex++;
                        widget.appBarIndex--;
                      });
                    },
                  ),
                ),
              )
            : Container(),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                buttonColor2,
                buttonColor1,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            'Tip # ${widget.appBarIndex}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: Center(
                    child: Text(
                      'TIP OF THE DAY',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Center(
                    child: Text(
                      widget.allTips[widget.myIndex]['tip'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                  child: Center(
                    child: Text(
                      'REMEMBER',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Center(
                    child: Text(
                      widget.allTips[widget.myIndex]['remember'],
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            widget.myIndex > 0 && widget.myIndex <= widget.allTips.length
                ? Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                              size: 22.5,
                            ),
                          ),
                          backgroundColor: buttonColor2,
                          heroTag: 'backward',
                          onPressed: () {
                            setState(() {
                              widget.myIndex--;
                              widget.appBarIndex++;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
