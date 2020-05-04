/*import 'package:flutter/material.dart';
import 'package:voices_for_christ/data/speaker_class.dart';
import 'package:voices_for_christ/data/database.dart';

class SpeakerWindow extends StatefulWidget {
  const SpeakerWindow({ Key key }) : super(key: key);

  @override
  _SpeakerWindowState createState() => _SpeakerWindowState();
}

class _SpeakerWindowState extends State<SpeakerWindow> {
  final db = MessageDB.instance;
  List<Speaker> _speakers = [];

  void loadSpeakers() async {
    List<Speaker> result = await db.queryAllSpeakers();
    setState(() {
      _speakers = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSpeakers();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _speakers.length,
        itemBuilder: (context, index) {
          return _speakerDetails(_speakers[index]);
        },
      ),
    );
  }

  Widget _speakerDetails(Speaker speaker) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Text(speaker.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          child: speaker.messagecount == 1
            ? Text('${speaker.messagecount.toString()} message')
            : Text('${speaker.messagecount.toString()} messages'),
        ),
      ],
    );
  }
}*/