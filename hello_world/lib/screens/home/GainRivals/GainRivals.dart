import 'package:flutter/material.dart';
import 'package:hello_world/models/gainRivalsModel.dart';
import 'package:hello_world/models/gainRivalsUser.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/screens/home/GainRivals/GameScreen.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';

class GainRivals extends StatefulWidget {
  @override
  _GainRivalsState createState() => _GainRivalsState();
}

class _GainRivalsState extends State<GainRivals> {
  var gameName = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.red,
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_buildLogoWidget()],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  width: 300,
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() => gameName = val.trim());
                    },
                    decoration: new InputDecoration(
                        labelText: "Enter GameID",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    /*GainRivalsUser gainRivalsUser = new GainRivalsUser(
                        username: usernameForUser, userId: user.uid);
                    List<GainRivalsUser> gainRivalsUsers =
                        new List<GainRivalsUser>();
                    gainRivalsUsers.add(gainRivalsUser);

                    GainRivalsModel gainRivalsModel = new GainRivalsModel(
                        gameName: gameName, users: gainRivalsUsers);
                    DatabaseService(uid: user.uid)
                        .addGainRivalsGame(gainRivalsModel);
                    Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GameScreen()),
                          );*/
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Join a Game".toUpperCase(),
                      style: TextStyle(fontSize: 30)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    List<String> initialGameList = new List<String>();
                    initialGameList.add(user.uid);
                    GainRivalsModel gainRivalsModel = new GainRivalsModel(admin: user.uid, users: initialGameList, gameId: gameName);
                    DatabaseService().addGainRivalsGame(gainRivalsModel);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => 
                        StreamProvider.value(
                          value: DatabaseService().gainRivalsGames,
                          child: StreamProvider.value(
                            value: DatabaseService().foodDiaries,
                            child: StreamProvider.value(
                              value: DatabaseService().userSettings,
                              child: GameScreen(gameName),
                            )
                          )
                        )),
                    );
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Create a Game".toUpperCase(),
                      style: TextStyle(fontSize: 30)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoWidget() {
    return CircleAvatar(
        backgroundImage: ExactAssetImage('assets/images/gainrivals.png'),
        backgroundColor: Colors.red,
        radius: 120);
  }
}
