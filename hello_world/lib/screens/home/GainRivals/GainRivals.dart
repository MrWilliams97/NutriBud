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

    var gainRivalsGames = Provider.of<List<GainRivalsModel>>(context);

    if (user == null || gainRivalsGames == null) {
      return Container();
    }

    var participatingGames = gainRivalsGames.where((gainRivalGame) =>
        gainRivalGame.users.contains(user.uid) &&
        gainRivalGame.admin != user.uid);
    var adminGames = gainRivalsGames
        .where((gainRivalGame) => gainRivalGame.admin == user.uid);

    var adminGamesRows = <DataRow>[];
    var participatingGamesRows = <DataRow>[];

    for (var adminGame in adminGames) {
      adminGamesRows.add(DataRow(cells: [
        DataCell(Text(adminGame.gameId)),
        DataCell(Text('Details', style: TextStyle(color: Colors.lightBlue)),
            onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamProvider.value(
                      value: DatabaseService().gainRivalsGames,
                      child: StreamProvider.value(
                          value: DatabaseService().foodDiaries,
                          child: StreamProvider.value(
                            value: DatabaseService().userSettings,
                            child: GameScreen(adminGame.gameId),
                          )))));
        })
      ]));
    }

    for (var participatingGame in participatingGames) {
      participatingGamesRows.add(DataRow(cells: [
        DataCell(Text(participatingGame.gameId)),
        DataCell(Text('Details', style: TextStyle(color: Colors.lightBlue)),
            onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamProvider.value(
                      value: DatabaseService().gainRivalsGames,
                      child: StreamProvider.value(
                          value: DatabaseService().foodDiaries,
                          child: StreamProvider.value(
                            value: DatabaseService().userSettings,
                            child: GameScreen(participatingGame.gameId),
                          )))));
        })
      ]));
    }

    return MaterialApp(
      title: 'Welcome to GainRivals',
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
                  onPressed: () async {
                    var userIdList = new List<String>();
                    userIdList.add(user.uid);
                    DatabaseService()
                        .joinGainRivalsGame(userIdList, gameName)
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StreamProvider.value(
                                value: DatabaseService().gainRivalsGames,
                                child: StreamProvider.value(
                                    value: DatabaseService().foodDiaries,
                                    child: StreamProvider.value(
                                      value: DatabaseService().userSettings,
                                      child: GameScreen(gameName),
                                    )))),
                      );
                    }).catchError((e) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("GainRivals Game Does Not Exist",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18.0)),
                              content: Text(
                                  "Please insert a valid GainRivals Code",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0)),
                            );
                          });
                    });
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
                    GainRivalsModel gainRivalsModel = new GainRivalsModel(
                        admin: user.uid,
                        users: initialGameList,
                        gameId: gameName);
                    DatabaseService()
                        .addGainRivalsGame(gainRivalsModel)
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StreamProvider.value(
                                value: DatabaseService().gainRivalsGames,
                                child: StreamProvider.value(
                                    value: DatabaseService().foodDiaries,
                                    child: StreamProvider.value(
                                      value: DatabaseService().userSettings,
                                      child: GameScreen(gameName),
                                    )))),
                      );
                    }).catchError((error) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("GainRivals Game already exists",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18.0)),
                              content: Text(
                                  "Create Game with different GameID not already in use",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0)),
                            );
                          });
                    });
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Create a Game".toUpperCase(),
                      style: TextStyle(fontSize: 30)),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                Text("Hosted Games:", style: TextStyle(color: Colors.blueGrey, fontSize: 25.0, fontWeight: FontWeight.bold))],
            ),
            DataTable(columns: [
              DataColumn(
                  label: Text('GameID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ))),
              DataColumn(
                  label: Text('View Board',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))),
            ], rows: adminGamesRows),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Text("Participating Games:", style: TextStyle(color: Colors.blueGrey, fontSize: 25.0, fontWeight: FontWeight.bold))],
            ),
            DataTable(columns: [
              DataColumn(
                  label: Text('GameID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ))),
              DataColumn(
                  label: Text('View Board',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))),
            ], rows: participatingGamesRows)
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
