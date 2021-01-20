import 'package:flutter/material.dart';

class GlobalWidget {
  static BoxDecoration backGround() {
    return BoxDecoration(
      image: DecorationImage(
          image: AssetImage(
            'assets/images/background.png',
          ),
          fit: BoxFit.cover),
    );
  }
}
