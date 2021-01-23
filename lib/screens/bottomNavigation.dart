import 'package:flashcard_admin/Dashboard%20Pages/examTips.dart';
import 'package:flashcard_admin/Dashboard%20Pages/flashCard.dart';
import 'package:flashcard_admin/Dashboard%20Pages/flashQuiz.dart';
import 'package:flashcard_admin/utils/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNavigator extends StatefulWidget {
  static double navSizee;
  BottomNavigator({@required this.initIndex});

  int initIndex;
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final key = GlobalKey();
  double iconSize = 25;

  int currentIndex;
  final tabs = [
    FlashCard(),
    FlashQuiz(),
    ExamTips(),
  ];

  @override
  void initState() {
    currentIndex = widget.initIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: tabs[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            key: key,
            selectedFontSize: MediaQuery.of(context).size.width * 0.037,
            currentIndex: currentIndex,
            backgroundColor: buttonColor2,
            selectedItemColor: headingColor,
            unselectedItemColor: textColor,
            showUnselectedLabels: false,
            onTap: (index) {
              setState(() {
                BottomNavigator.navSizee = key.currentContext.size.height;
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      child: Icon(
                        Icons.credit_card_sharp,
                        color: currentIndex == 0 ? textColor : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
                label: 'FLASH CARDS',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        'assets/images/quiz.png',
                        color: currentIndex == 1 ? textColor : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
                label: 'FLASH QUIZ',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        'assets/images/sticker.png',
                        color: currentIndex == 2 ? textColor : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
                label: 'EXAM TIPS',
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 40,
            width: 40,
            child: Image.asset(
              'assets/images/circlee.png',
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }
}
