import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flashcard_admin/utils/global_widgets.dart';
import 'package:flashcard_admin/utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class EditFC extends StatefulWidget {
  String sessionId;
  String readId;
  String fcId;
  String title;
  String body;
  String imgUrl;

  EditFC(
      {this.body,
      this.fcId,
      this.imgUrl,
      this.readId,
      this.sessionId,
      this.title});
  @override
  _EditFCState createState() => _EditFCState();
}

class _EditFCState extends State<EditFC> {
  TextEditingController textController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  bool isLoading = false;
  File _image;
  bool added = false;
  String imagePath;
  FToast fToast;
  final picker = ImagePicker();

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
    textController.text = widget.title;
    bodyController.text = widget.body;
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
                          textCapitalization: TextCapitalization.sentences,
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
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'Flashcard Title',
                              hintStyle:
                                  TextStyle(fontFamily: 'Segoe', fontSize: 12)),
                        ),
                      ),
                      Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey[700],
                        ),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontFamily: 'Segoe'),
                          controller: bodyController,
                          maxLines: 5,
                          validator: (input) {
                            return input.isEmpty
                                ? 'Flashcard body is required!'
                                : null;
                          },
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.grey[700],
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'Flashcard Body',
                              hintStyle:
                                  TextStyle(fontFamily: 'Segoe', fontSize: 12)),
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
                          height: widget.imgUrl == null
                              ? 40
                              : added == true
                                  ? 40
                                  : 80,
                          width: MediaQuery.of(context).size.width * 0.9,
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
                                          padding: EdgeInsets.only(left: 10),
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
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.done)),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                widget.imgUrl == null
                                                    ? 'Add primary image'
                                                    : 'Edit primary image',
                                                style: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 13),
                                              ))),
                                    ),
                                    widget.imgUrl == null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Icon(
                                                Icons.add_a_photo_outlined),
                                          )
                                        : Padding(
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
                                                  imageUrl:
                                                      widget.imgUrl == null
                                                          ? null
                                                          : widget.imgUrl,
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
                                                                  Colors.white,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                Color.fromRGBO(
                                                                    102,
                                                                    126,
                                                                    234,
                                                                    1),
                                                              ),
                                                              strokeWidth: 3,
                                                              value:
                                                                  downloadProgress
                                                                      .progress),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(
                                                    Icons.add_a_photo_outlined,
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
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              minWidth: 40,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Segoe',
                                ),
                              ),
                            ),
                            FlatButton(
                              minWidth: 40,
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                await uploadFile().then((value) {
                                  FirebaseFirestore.instance
                                      .collection('level1')
                                      .doc(widget.sessionId)
                                      .collection('readings')
                                      .doc(widget.readId)
                                      .collection('flashcards')
                                      .doc(widget.fcId)
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
  }
}
