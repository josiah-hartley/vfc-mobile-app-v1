import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  //primaryColor: Colors.blue[700],
  primaryColor: Colors.blueGrey[50],
  secondaryHeaderColor: Colors.grey[800], // text on primaryColor, play bar text
  unselectedWidgetColor: Colors.grey[800], // drawer links
  accentColor: Colors.brown[100].withOpacity(0.5), // play bar background
  canvasColor: Colors.white, // search box background
  scaffoldBackgroundColor: Colors.white, // search container background
  focusColor: Colors.blue[100], // search box border, focused
  hoverColor: Colors.blue[100].withOpacity(0.6), // search box border, unfocused
  splashColor: Colors.black, // search icon after search bar, arrow icon on message list
  buttonColor: Colors.blue[800],
  textSelectionColor: Colors.yellow[800], // favorite icon
  cardColor: Colors.white,
  dividerColor: Colors.transparent,
  //dividerColor: Colors.grey[200], // message details divider
  disabledColor: Colors.grey[500],
  indicatorColor: Colors.grey[300], // percent download indicator
  hintColor: Colors.blueGrey[50], // tag background
  bottomAppBarColor: Colors.blueGrey[50],
  selectedRowColor: Colors.blue[700], // selected item on bottom nav
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[850],
  secondaryHeaderColor: Colors.grey[300], // text on primaryColor, play bar text
  unselectedWidgetColor: Colors.blueGrey[100], // drawer links, search hint text
  accentColor: Colors.brown[700], // play bar background
  canvasColor: Colors.grey[700], // search box background
  scaffoldBackgroundColor: Colors.grey[800], // search container background
  focusColor: Colors.grey[600], // search box border, focused
  hoverColor: Colors.grey[600].withOpacity(0.6), // search box border, unfocused
  splashColor: Colors.white, // search icon after search bar, arrow icon on message list
  buttonColor: Colors.grey[100],
  textSelectionColor: Colors.yellow[800], // favorite icon
  cardColor: Colors.grey[800],
  dividerColor: Colors.transparent,
  //dividerColor: Colors.grey[200], // message details divider
  disabledColor: Colors.grey[500],
  indicatorColor: Colors.grey[400], // percent download indicator
  hintColor: Colors.blue[300].withOpacity(0.3), // tag background
  bottomAppBarColor: Colors.blueGrey[800],
  selectedRowColor: Colors.white, // selected item on bottom nav
);