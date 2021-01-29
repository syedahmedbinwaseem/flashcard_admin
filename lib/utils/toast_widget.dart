import 'package:flashcard_admin/utils/colors.dart';
import 'package:flutter/material.dart';

class ToastWidget {
  static Container toast(String text, Icon icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: buttonColor1,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(
            width: 10,
          ),
          Flexible(
              child: Text(
            text,
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }
}
