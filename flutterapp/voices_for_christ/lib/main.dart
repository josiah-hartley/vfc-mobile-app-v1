import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voices_for_christ/screens/home_screen.dart';
import 'package:voices_for_christ/models/main_model.dart';
import 'package:voices_for_christ/ui/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // needed because of async work in initializePlayer()
  var model = MainModel();
  model.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_) {
    runApp(MyApp(model: model));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({ Key key, this.model }) : super(key: key);

  final MainModel model;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String theme = 'light';

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: widget.model,
      child: MaterialApp(
        title: 'Voices for Christ',
        theme: theme == 'light' ? lightTheme : darkTheme,
        //darkTheme: darkTheme,
        home: HomeScreen(theme: theme, setTheme: setTheme),
        debugShowCheckedModeBanner: false,
      )
    );
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedTheme = prefs.getString('appTheme');
    if (savedTheme != null) {
      setState(() {
        theme = savedTheme;
      });
    }
  }

  void setTheme(String newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('appTheme', newTheme);
    if (theme != newTheme) {
      setState(() {
        theme = newTheme;
      });
    }
  }
}