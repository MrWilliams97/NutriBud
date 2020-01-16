import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/services/auth.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FoodDiaryScreen extends StatefulWidget {
  @override
  _FoodDiaryScreenState createState() => _FoodDiaryScreenState();
}

class _FoodDiaryScreenState extends State<FoodDiaryScreen> {
  final AuthService _authService = AuthService();

  DateTime diaryDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<FoodDiary>>.value(
      value: DatabaseService().foodDiaries,
      child: new Container(
          child: new Stack(children: <Widget>[
        Scaffold(
            body: Center(
              child: Text("Welcome to the home screen!"),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Container(
                height: 75,
                child: Row (
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(Icons.person),
                      onPressed: () async {
                        await _authService.signOut();
                      }
                    )
                  ],
                )
              ),
            ),
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
          style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
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
