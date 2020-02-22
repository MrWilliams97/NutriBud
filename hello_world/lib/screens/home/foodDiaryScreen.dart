import 'package:flutter/material.dart';
import 'package:hello_world/models/food.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/meal.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:hello_world/screens/home/GainRivals/GainRivals.dart';
import 'package:hello_world/screens/home/customShapeBorder.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>(); 
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    widget.userId = user.uid;
    return StreamProvider<List<FoodDiary>>.value(
      value: DatabaseService(uid: widget.userId).foodDiaries,
      child: new Container(
          child: new Stack(children: <Widget>[
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.red,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            title: Padding(
                padding: EdgeInsets.only(top: 20),
                child: _buildChangeDateWidget()),
            shape: CustomShapeBorder(),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {},
              ),
            ],
          ),
          drawerEdgeDragWidth: 40,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [
                    Colors.red,
                    Colors.pink
                  ])),
                  child: CircleAvatar(
                  backgroundImage: ExactAssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.transparent,
                  radius: 120.0,)),
                new ListTile(
                  title: Text("Account Settings", style: TextStyle(color: Colors.red)),
                  trailing: new Icon(
                    Icons.settings,
                    color: Colors.red
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "/UserSettings"),
                        builder: (context) =>
                            StreamProvider<List<UserSettings>>.value(
                                value: DatabaseService(uid: widget.userId)
                                    .userSettings,
                                child: UserSettingsScreen())));
                  }
                ),
                new ListTile(
                  title: Text("Timelines", style: TextStyle(color: Colors.red)),
                  trailing: new Icon(
                    Icons.timeline,
                    color: Colors.red,
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StreamProvider<List<FoodDiary>>.value(
                            value:
                                DatabaseService(uid: widget.userId).foodDiaries,
                            child: StreamProvider<List<UserSettings>>.value(
                                value: DatabaseService(uid: widget.userId)
                                    .userSettings,
                                child: StreamProvider<List<Meal>>.value(
                                    value: DatabaseService(uid: widget.userId)
                                        .meals,
                                    child: StreamProvider<List<Food>>.value(
                                      value: DatabaseService(uid: widget.userId)
                                          .foods,
                                      child: Timelines(),
                                    ))),
                          )),
                    );
                  }
                ),
                new ListTile(
                  title: Text("GainRivals", style: TextStyle(color: Colors.red)),
                  trailing: new Icon(Icons.gamepad, color: Colors.red),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GainRivals()),
                    );
                  }
                ),
                new ListTile(
                  title: Text("Sign Out", style: TextStyle(color: Colors.red)),
                  trailing: new Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  onTap: () async {
                    await _authService.signOut();
                  }
                ),
              ],),
          ),
          body: Center(
            child: StreamProvider.value(
                value: DatabaseService().meals,
                child: FoodDiaryDetails(foodDiaryDate: diaryDate)),
          ),
        ),
      ])),
    );
  }

  // Contains the Top App Bar's Date, along with Arrow Icons to adjust the date
  Widget _buildChangeDateWidget() {
    List<Widget> widgets = [
      GestureDetector(
          child: Icon(Icons.arrow_left, size: 36, color: Colors.white),
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
                color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ))
    ];

    if (diaryDate.difference(DateTime.now()).inDays != 0) {
      widgets.add(GestureDetector(
          child: Icon(Icons.arrow_right, size: 36, color: Colors.white),
          onTap: () {
            setState(() {
              diaryDate = diaryDate.add(new Duration(days: 1));
            });
          }));
    }
    return Center(
      child: Row(
        children: widgets,
      ),
    );
  }
}
