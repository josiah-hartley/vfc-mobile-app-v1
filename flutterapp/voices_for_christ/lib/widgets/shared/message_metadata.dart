import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:voices_for_christ/data/message_class.dart';

String durationInMinutes(double durationInSeconds) {
  if (durationInSeconds == null) {
    return '00:00';
  }

  String minutes = (durationInSeconds ~/ 60).toString();
  String seconds = (durationInSeconds % 60).round().toString();
  if (seconds.length == 1) {
    seconds = '0' + seconds;
  }
  return '$minutes:$seconds';
}

String reversedName(String name) {
  return name.split(',').reversed.join(' ').trim();
}

Widget _playedIndicator(BuildContext context, Message message) {
  return message?.isplayed == 1
    ? Container(
      child: Icon(Icons.done, color: Theme.of(context).buttonColor, size: 20.0),
      padding: EdgeInsets.only(left: 5.0),
    )
    : SizedBox(height: 0.0);
}

Widget title(BuildContext context, Message message, bool truncateTitle) {
  num _percentagePlayed = message.durationinseconds == null || message.lastplayedposition == null ? 0 : 100 * message.lastplayedposition / message.durationinseconds;
  /*if (message.isplayed == 1) {
    _percentagePlayed = 100;
  }*/

  String _durationInMinutes = '';
  if (message.durationinseconds != null) {
    /*String minutes = (message.durationinseconds ~/ 60).toString();
    String seconds = (message.durationinseconds % 60).round().toString();
    if (seconds.length == 1) {
      seconds = '0' + seconds;
    }
    _durationInMinutes = '$minutes:$seconds';*/
    _durationInMinutes = durationInMinutes(message.durationinseconds);
  }

  return Container(
    padding: EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(message.title,
                overflow: truncateTitle ? TextOverflow.ellipsis : TextOverflow.visible,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: message.isdownloaded == 1 ? FontWeight.w500 : FontWeight.w400,
                  color: message.isdownloaded == 1 ? Theme.of(context).splashColor : Theme.of(context).splashColor.withOpacity(0.6),
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _playedIndicator(context, message),
          ],
        ),
        /*Text(message.title,
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: message.isdownloaded == 1 ? FontWeight.w500 : FontWeight.w400,
            color: message.isdownloaded == 1 ? Theme.of(context).splashColor : Theme.of(context).splashColor.withOpacity(0.6),
            //fontWeight: FontWeight.bold,
          ),
        ),*/
        Container(
          padding: EdgeInsets.only(top: 6.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(reversedName(message.speaker),
                  overflow: truncateTitle ? TextOverflow.ellipsis : TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 16.0,
                    //fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: message.isdownloaded == 1 ? Theme.of(context).splashColor.withOpacity(0.7) : Theme.of(context).splashColor.withOpacity(0.5),
                  ),
                ),
              ),
              Text(_durationInMinutes,
                style: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  color: message.isdownloaded == 1 ? Theme.of(context).splashColor.withOpacity(0.7) : Theme.of(context).splashColor.withOpacity(0.5),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: CircularPercentIndicator(
                    radius: 15.0,
                    lineWidth: 3.0,
                    percent: (_percentagePlayed / 100).toDouble(),
                    backgroundColor: Theme.of(context).indicatorColor,
                    progressColor: Theme.of(context).buttonColor,
                  ),
              ),
              Text('${_percentagePlayed.round().toString()}%'),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget details(BuildContext context, Message message) {
  String dateAndLocation = '';
  if (message.location != 'unavailable') {
    dateAndLocation += message.location;
  }
  if (message.date != null) {
    if (dateAndLocation != '') {
      dateAndLocation += ', ${message.date}';
    } else {
      dateAndLocation += message.date;
    }
  }

  List<String> tags = message.taglist.split(',');
  if (tags[0] == '') {
    tags = [];
  }

  List<Widget> childs = [];
  if (dateAndLocation != '') {
    childs.add(
      Text(dateAndLocation)
    );
  }
  if (tags.length > 0) {
    childs.add(
      Container(
        height: 35.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Row(
                children: <Widget>[
                  Text('Tags: '),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    padding: EdgeInsets.all(6.0),
                    margin: EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 0.0),
                    child: Text(tags[index],
                      style: TextStyle(color: Theme.of(context).splashColor),
                    ),
                  )
                ],
              );
            }
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              padding: EdgeInsets.all(6.0),
              margin: EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 0.0),
              child: Text(tags[index],
                style: TextStyle(color: Theme.of(context).splashColor),
              ),
            );
          } 
        ),
      ),
    );
  }

  if (childs.length > 0) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: childs,
      ),
    );
  }

  return Container(height: 0.0);
}