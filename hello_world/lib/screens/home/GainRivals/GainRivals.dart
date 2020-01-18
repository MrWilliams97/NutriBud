import 'package:flutter/material.dart';
import 'package:hello_world/models/gainRivalsModel.dart';
import 'package:hello_world/models/gainRivalsUser.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/screens/home/GainRivals/GameScreen.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';

class GainRivals extends StatefulWidget {
  @override
  _GainRivalsState createState () => _GainRivalsState();
}
class _GainRivalsState extends State<GainRivals> {

  var gameName = "";
  var usernameForUser = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text("GainRivals"),
            leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),),
            centerTitle: true,
            backgroundColor: Colors.red,
          ),
          body: SafeArea(
              child: Center(
                child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                      ),
                      TextField(
                        onChanged: (val) {
                          setState(() => gameName = val.trim());
                        },
                        decoration: InputDecoration(
                          hintText: "Enter a gameID",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                      ),
                      TextField(
                        onChanged: (val) {
                          setState(() => usernameForUser = val.trim());
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your Username",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                      ),
                      RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                        onPressed: () {
                          GainRivalsUser gainRivalsUser = new GainRivalsUser(username: usernameForUser, userId: user.uid);
                          List<GainRivalsUser> gainRivalsUsers = new List<GainRivalsUser>();
                          gainRivalsUsers.add(gainRivalsUser);

                          GainRivalsModel gainRivalsModel = new GainRivalsModel(gameName: gameName, users: gainRivalsUsers);
                          DatabaseService(uid: user.uid).addGainRivalsGame(gainRivalsModel);
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GameScreen()),
                          );*/
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("Join a Game".toUpperCase(),
                            style: TextStyle(fontSize: 30)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 100),
                      ),
                      RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GameScreen()),
                          );
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("Create a Game".toUpperCase(),
                            style: TextStyle(fontSize: 30)),
                      ),
                    ]),
              )
          ),
        ),
      );
  }
}