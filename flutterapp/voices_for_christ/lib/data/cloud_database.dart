import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/data/database.dart';

Future getMessageDataFromCloud([Function onCompleted, var context]) async {
  // see when database was last updated
  final db = MessageDB.instance;
  int lastUpdated = await db.getLastUpdatedDate() ?? 0;
  String timeParam = lastUpdated.toString();
  String url = 'https://us-central1-voices-for-christ.cloudfunctions.net/getMessagesSinceDate?time=' + timeParam;

  // get all messages since last update
  try {
    //print('Loading message data from Firestore...');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> msgMap = json.decode(response.body);

      // Add data in batches
      List<Message> msgList = [];

      for (var m in msgMap.entries) {
        m.value['id'] = int.parse(m.key);
        Message msg = Message.fromCloudMap(m.value);

        msgList.add(msg);
      }
      await db.batchAddToDB(msgList);

      // save current time as last updated time
      db.setLastUpdatedDate(DateTime.now().millisecondsSinceEpoch);
      
      onCompleted(context);
    } else {
      throw HttpException('Server error: failed to load messages from Firestore');
    }
  } catch (error) {
    throw error;
  }
}