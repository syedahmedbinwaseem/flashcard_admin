import 'package:flashcard_admin/screens/splashScreen.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MaterialColor customPrimaryColor = MaterialColor(0xFF509EB7, primaryColor);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: customPrimaryColor,
        textSelectionHandleColor: buttonColor1,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
