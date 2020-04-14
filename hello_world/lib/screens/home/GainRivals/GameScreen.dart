import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/gainRivalsModel.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:hello_world/screens/home/customShapeBorder.dart';
import 'package:provider/provider.dart';

// Define a corresponding State class.
// This class holds the data related to the Form.
class GameScreen extends StatelessWidget {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  String _gameName;
  GameScreen(String gameName) {
    _gameName = gameName;
  }

  int _goalScore(int percentage) {
    if (percentage >= 200 || percentage <= 0) {
      return 0;
    }

    if (percentage > 100) {
      return 200 - percentage;
    }

    return percentage;
  }

  Widget _leaderboardRow(String userName, int score) {
    return ListTile(
      leading: Icon(Icons.face),
      title: Text(userName),
      subtitle: Text(score.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var gainRivalsGames = Provider.of<List<GainRivalsModel>>(context);
    var userSettings = Provider.of<List<UserSettings>>(context);
    var foodDiaries = Provider.of<List<FoodDiary>>(context);

    if (gainRivalsGames == null ||
        userSettings == null ||
        foodDiaries == null) {
      return Container();
    }
//
    var game = gainRivalsGames.firstWhere((game) => game.gameId == _gameName);

    Map<String, int> gainRivalsScores = new Map<String, int>();
    Map<String, String> gainRivalsUsernames = new Map<String, String>();
    for (var gameUser in game.users) {
      gainRivalsScores[gameUser] = 0;
      gainRivalsUsernames[gameUser] = userSettings
          .firstWhere((userSetting) => userSetting.userId == gameUser)
          .userName;
      var pastWeekFoodDiaries = foodDiaries
          .where((foodDiary) =>
              foodDiary.userId == gameUser &&
              foodDiary.foodDiaryDate.difference(DateTime.now()).inDays.abs() >=
                  1 &&
              foodDiary.foodDiaryDate.difference(DateTime.now()).inDays.abs() <=
                  8)
          .toList();
      for (var foodDiary in pastWeekFoodDiaries) {
        if (foodDiary.savedCalorieGoal != null) {
          gainRivalsScores[gameUser] +=
              _goalScore(foodDiary.savedCalorieGoal.round());
        }

        if (foodDiary.savedCarbGoal != null) {
          gainRivalsScores[gameUser] +=
              _goalScore(foodDiary.savedCarbGoal.round());
        }

        if (foodDiary.savedFatGoal != null) {
          gainRivalsScores[gameUser] +=
              _goalScore(foodDiary.savedFatGoal.round());
        }

        if (foodDiary.savedProteinGoal != null) {
          gainRivalsScores[gameUser] +=
              _goalScore(foodDiary.savedProteinGoal.round());
        }
      }
    }

    var sortedKeys = gainRivalsScores.keys.toList(growable: false)
      ..sort((k1, k2) => gainRivalsScores[k1].compareTo(gainRivalsScores[k2]));

    

    var sortedScores = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => gainRivalsScores[k]);

    var leaderboardRows = sortedScores.keys
        .map((user) =>
            _leaderboardRow(gainRivalsUsernames[user], sortedScores[user]))
        .toList().reversed.toList();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Column(
            children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10),),
                  Text("Admin: ${gainRivalsUsernames[game.admin]}"),
                  Text(_gameName)
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          shape: CustomShapeBorder(),
          backgroundColor: Colors.red,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget> [
                Padding(padding: EdgeInsets.only(top: 30),),
                Column(children: leaderboardRows,)
              ],
            ),
          ),
        ));
  }
}
