import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voices_for_christ/data/cloud_database.dart' as cloud;
import 'package:fluttertoast/fluttertoast.dart';

Widget appBar(BuildContext context, String title, String theme, Function setTheme) {
  List<PopupMenuEntry<int>> _overflowOptions = [
    PopupMenuItem(
      value: 0,
      child: theme == 'light' ? Text('Switch to Dark Theme') : Text('Switch to Light Theme'),
    ),
    PopupMenuItem(
      value: 1,
      child: Text('Check for New Messages'),
    ),
  ];

  return AppBar(
    title: Text(title),
    elevation: 0,
    centerTitle: true,
    actions: <Widget>[
      PopupMenuButton<int>(
        icon: Icon(Icons.settings),
        itemBuilder: (context) => _overflowOptions,
        onSelected: (value) {
          switch (value) {
            case 0:
              String newTheme = theme == 'light' ? 'dark' : 'light';
              setTheme(newTheme);
              break;
            case 1:
              getAllMessageData(context);
              break;
          }
        },
      ),
    ],
  );
}

void onDataLoaded(var context) {
  //print('Successfully saved message data from Firestore');
  Fluttertoast.showToast(
    msg: "Message database updated",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 1,
    backgroundColor: Colors.grey[300],
    textColor: Colors.grey[800],
    fontSize: 16.0
  );
}

void getAllMessageData(BuildContext context) async {
  try {
    await cloud.getMessageDataFromCloud(onDataLoaded, context);
  } catch (error) {
    print('Error loading from Firestore: $error');

    if (error is SocketException) {
      Fluttertoast.showToast(
        msg: "Error loading message data: check connection",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.red[600],
        textColor: Colors.grey[50],
        fontSize: 16.0
      );
    }
    
    if (error is HttpException) {
      Fluttertoast.showToast(
        msg: "Error loading message data: server error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.red[600],
        textColor: Colors.grey[50],
        fontSize: 16.0
      );
    }
  }
}