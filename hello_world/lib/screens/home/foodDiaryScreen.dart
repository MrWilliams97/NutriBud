import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:hello_world/screens/home/GainRivals/GainRivals.dart';
import 'package:hello_world/screens/home/foodDiaryDetails.dart';
import 'package:hello_world/screens/home/timelines.dart';
import 'package:hello_world/screens/home/userSettingsScreen.dart';
import 'package:hello_world/services/auth.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hello_world/models/user.dart';

class FoodDiaryScreen extends StatefulWidget {
  var userId;
  @override
  _FoodDiaryScreenState createState() => _FoodDiaryScreenState();
}

class _FoodDiaryScreenState extends State<FoodDiaryScreen> {
  final AuthService _authService = AuthService();

  DateTime diaryDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    widget.userId = user.uid;
    return StreamProvider<List<FoodDiary>>.value(
      value: DatabaseService(uid: widget.userId).foodDiaries,
      child: new Container(
          child: new Stack(children: <Widget>[
        Scaffold(
          body: Center(
            child: StreamProvider.value(
              value: DatabaseService().meals,
              child: FoodDiaryDetails(foodDiaryDate: diaryDate)),
          ),
          bottomNavigationBar: _buildBottomAppBar(),
        ),
        new Container(
            height: 150.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildChangeDateWidget(),
              ],
            ),
            decoration: new BoxDecoration(
                color: Colors.red,
                boxShadow: [new BoxShadow(blurRadius: 40.0)],
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0)))),
      ])),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
        color: Colors.red,
        child: new Row(
          children: <Widget>[
            new FlatButton(
              onPressed: () async {
                await _authService.signOut();
              },
              padding: EdgeInsets.only(left: 30, right: 20),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  new Text("Sign Out", style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            new FlatButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Timelines()),
                );
              },
              padding: EdgeInsets.only(left: 20, right: 20),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(
                    Icons.timeline,
                    color: Colors.white,
                  ),
                  new Text("Timeline", style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            new FlatButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GainRivals()),
                );
              },
              padding: EdgeInsets.only(left: 20, right: 20),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(
                    Icons.games,
                    color: Colors.white,
                  ),
                  new Text("GainRivals", style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            new FlatButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute
                  (
                    settings: RouteSettings(name: "/UserSettings"),
                    builder: (context) => StreamProvider<List<UserSettings>>.value(
                      value: DatabaseService(uid: widget.userId).userSettings,
                      child: UserSettingsScreen()
                    )
                ));
              },
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  new Text("Profile", style: TextStyle(color: Colors.white))
                ],
              ),
            )
          ],
        ));
  }

  // Contains the Top App Bar's Date, along with Arrow Icons to adjust the date
  Widget _buildChangeDateWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            child: Icon(Icons.arrow_left, size: 50, color: Colors.white),
            onTap: () {
              setState(() {
                diaryDate = diaryDate.subtract(new Duration(days: 1));
              });
            }),
        Material(
            color: Colors.red,
            child: Text(
              DateFormat("yyyy-MM-dd").format(diaryDate),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            )),
        GestureDetector(
            child: Icon(Icons.arrow_right, size: 50, color: Colors.white),
            onTap: () {
              setState(() {
                diaryDate = diaryDate.add(new Duration(days: 1));
              });
            })
      ],
    );
  }
}
