import 'package:flutter/material.dart';
import 'package:hello_world/services/auth.dart';

class FoodDiary extends StatefulWidget {
  @override
  _FoodDiaryState createState() => _FoodDiaryState();
}

class _FoodDiaryState extends State<FoodDiary> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(children: <Widget>[
      Scaffold(
          appBar: AppBar(
            title: Text('AppBar Back Button'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Center(
            child: Text("Welcome to the home screen!"),
          )),
      new Container(
          height: 150.0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20.0, left: 10.0),
                child: Material(
                type: MaterialType.transparency,
                child: Center(
                  child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.red,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () async {
                          await _authService.signOut();
                        },
                      )),
                ),
              ),)
              
            ],
          ),
          decoration: new BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage("assets/images/food.jpg"),
                fit: BoxFit.cover,
              ),
              boxShadow: [new BoxShadow(blurRadius: 40.0)],
              borderRadius: new BorderRadius.vertical(
                  bottom: new Radius.elliptical(
                      MediaQuery.of(context).size.width, 100.0)))),
    ]));
  }
}
