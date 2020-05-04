import 'package:flutter/material.dart';
import 'package:voices_for_christ/data/message_class.dart';

Widget actionIconButton(Message message, Function actionPressed, IconData actionIcon, Color actionColor, bool showBorder) {
  BorderSide border = showBorder 
      ? BorderSide(width: 2.0, color: actionColor)
      : BorderSide(width: 2.0, color: Colors.transparent);

  Icon icon = showBorder 
      ? Icon(actionIcon, color: actionColor)
      : Icon(actionIcon, color: actionColor, size: 25.0);

  return RawMaterialButton(
    child: actionIcon == null
      ? CircularProgressIndicator()
      : icon,
    shape: CircleBorder(side: border),
    padding: showBorder ? EdgeInsets.all(5.0) : EdgeInsets.all(4.0),
    constraints: BoxConstraints(),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashColor: Colors.transparent,
    onPressed: actionPressed == null ? null : () { actionPressed(message); },
  );
}

Widget actionRowItem(Message message, Function actionPressed, String actionText, IconData actionIcon, Color actionColor, bool showBorder) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        actionIconButton(message, actionPressed, actionIcon, actionColor, showBorder),
        RawMaterialButton(
          child: Text(actionText,
            style: TextStyle(color: actionColor, fontSize: 13.0),
          ),
          constraints: BoxConstraints(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: showBorder ? EdgeInsets.only(top: 4.0) : EdgeInsets.all(0.0),
          splashColor: Colors.transparent,
          onPressed: () { actionPressed(message); },
        )
      ],
    ),
  );
}

Widget actionRowDivider(BuildContext context) {
  return Container(
    width: 1,
    height: 40,
    color: Theme.of(context).dividerColor,
  );
}