import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voices_for_christ/models/main_model.dart';
import 'package:voices_for_christ/widgets/search_window/search_box.dart';
import 'package:voices_for_christ/widgets/shared/message_list.dart';

class SearchWindow extends StatelessWidget {
  final BuildContext parentContext;
  SearchWindow({this.parentContext});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Expanded(
          child: Column(
            children: children(context, child, model),
          ),
        );
      }
    );
  }

  List<Widget> children(context, child, model) {
    List<Widget> list = [
      model.searchString != ''
        ? searchBox(context)
        : Expanded(child: searchBox(context)),
      model.searchString != ''
        ? Expanded(
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: model.searchResultCount == 1
                    ? Text('${model.searchResultCount.toString()} Result')
                    : Text('${model.searchResultCount.toString()} Results'),
                ),
                color: Theme.of(context).cardColor,
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              ),
              Expanded(
                child: ListView.builder(
                  key: PageStorageKey('search-results'),
                  itemCount: model.messages.length,
                  itemBuilder: (context, index) {
                    if (index + 1 >= model.messages.length && !model.resultsFinished) {
                      model.search();
                    }
                    return MessageDetails(message: model.messages[index]);
                  }
                ),
              ),
            ],
          ),
        )
        : browseMOTM(model),
    ];

    return list;
  }

  Widget browseMOTM(MainModel model) {
    if (model.messageOfTheMonth == null) {
      return SizedBox(
        height: !(MediaQuery.of(parentContext).viewInsets.bottom == 0.0) // keyboard open
          ? 200.0
          : 0.0,
      );
    }

    return Container(
      //padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Text('Message of the Month',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          MessageDetails(message: model.messageOfTheMonth),
          SizedBox(height:150),
        ],
      ),
    );    
  }
}