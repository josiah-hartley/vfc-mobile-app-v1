import 'package:flutter/material.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/data/cloud_database.dart' as cloud;
import 'package:fluttertoast/fluttertoast.dart';

final db = MessageDB.instance;

Widget menuDrawer(BuildContext context, String theme, Function setTheme) {
  return Drawer(
    child: Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(bottom: BorderSide(
                  color: Colors.grey[200],
                  width: 2.0,
                ))
              ),
              child: Center(
                child: Text('Voices for Christ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      String newTheme = theme == 'light' ? 'dark' : 'light';
                      setTheme(newTheme);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: theme == 'light'
                            ? Icon(Icons.brightness_high, color: Theme.of(context).unselectedWidgetColor)
                            : Icon(Icons.brightness_low, color: Theme.of(context).unselectedWidgetColor),
                          onPressed: () {
                            String newTheme = theme == 'light' ? 'dark' : 'light';
                            setTheme(newTheme);
                            Navigator.pop(context);
                          },
                          tooltip: theme == 'light' ? 'Dark Theme' : 'Light Theme',
                        ),
                        Text(theme == 'light' ? 'Dark Theme' : 'Light Theme',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                        )
                      ],
                    )
                  ),
                  _menuItem(context, Icons.add, _getAllMessageData, 'Check for Updates', 'Check for New Messages'),
                  //_menuItem(context, Icons.restore, _resetDatabase, 'Reset Database', 'Developer: Reset Database'),
                  //_menuItem(context, Icons.delete, _deleteAllMessages, 'Delete Messages', 'Developer: Delete Message Data'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _menuItem(BuildContext context, IconData icon, Function action, String tooltip, String text) {
  return InkWell(
    onTap: () {action(context);},
    child: Row(
      children: <Widget>[
        IconButton(
          icon: Icon(icon, color: Theme.of(context).unselectedWidgetColor),
          onPressed: () {action(context);},
          tooltip: tooltip,
        ),
        Text(text,
          style: TextStyle(
            fontSize: 15.0,
            color: Theme.of(context).unselectedWidgetColor,
          ),
        )
      ],
    )
  );
}

void _deleteAllMessages(BuildContext context) async {
  await db.deleteAll();
  Navigator.pop(context);
}

void _resetDatabase(BuildContext context) async {
  await db.resetDB();
  Navigator.pop(context);
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

void _getAllMessageData(BuildContext context) async {
  try {
    await cloud.getMessageDataFromCloud(onDataLoaded, context);
    //await cloud.getSpeakerDataFromCloud();
  } catch (error) {
    print('Error loading from Firestore: $error');
  }
  Navigator.pop(context);
}