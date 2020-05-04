import 'dart:convert';
import 'dart:io';
import 'package:html/parser.dart';

import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/data/database.dart';

Future<Message> monthlyMessage() async {
  final db = MessageDB.instance;
  Message motm;
  String url = 'https://voicesforchrist.net/';

  HttpClient client = HttpClient();
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) {
    final isValidHost = host == 'voicesforchrist.net';
    return isValidHost;
  });

  try {
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();

    String contents = await response.transform(utf8.decoder).join();
    var document = parse(contents);
    var anchor = document.querySelector('div#motm > a');

    if (anchor != null) {
      String link = anchor.attributes['href'];

      String linkStart = link.split('?')[0];
      String idString = linkStart.split('/')[2];

      int id = int.parse(idString);
      motm = await db.queryOne(id);
    }
    
    return motm;
  } 
  catch(error) {
    print(error);
    return motm;
  }
  
}