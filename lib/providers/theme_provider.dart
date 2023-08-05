import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Color mainColor = Colors.blue;
  Color secondryColor = Colors.white;
  Color mainFontColor = Colors.black;
  Color secondryFontColor = Colors.black;

  void changeColor(String s, Color newColor) {
    if (s == 'Main Color') {
      mainColor = newColor;
    } else if (s == 'Secondry Color') {
      secondryColor = newColor;
    } else if (s == 'Main Font Color') {
      mainFontColor = newColor;
    } else if (s == 'Secondry Font Color') {
      secondryFontColor = newColor;
    }
    notifyListeners();
  }
}
