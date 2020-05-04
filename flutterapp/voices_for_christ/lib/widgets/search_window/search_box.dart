import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voices_for_christ/models/main_model.dart';

final searchController = TextEditingController();

Widget searchBox(BuildContext context) {
  return ScopedModelDescendant<MainModel>(
    builder: (context, child, model) {
      return Container(
        height: 65.0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onEditingComplete: () { searchDB(context, model); },
                  cursorWidth: 1.0,
                  style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).canvasColor,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).hoverColor,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).focusColor,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                    hintText: 'Search for a topic or speaker',
                    hintStyle: TextStyle(
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                    //prefixIcon: Icon(Icons.search)
                  ),
                ),
              )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: ShapeDecoration(
                color: Theme.of(context).hoverColor,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(Icons.search),
                color: Theme.of(context).splashColor,
                onPressed: () { searchDB(context, model); },
              ),
            ),
          ],
        )
      );
    }
  );
}

void searchDB(BuildContext context, MainModel model) {
  model.startNewSearch(searchController.text);
  model.search();

  // Minimize the keyboard
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}