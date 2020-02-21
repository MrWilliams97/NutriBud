import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hello_world/models/food.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/meal.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class Timelines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<User>(context).uid;
    var userSettingProvider = Provider.of<List<UserSettings>>(context);
    var foodDiaryProvider = Provider.of<List<FoodDiary>>(context);
    var mealProvider = Provider.of<List<Meal>>(context);
    var foodProvider = Provider.of<List<Food>>(context);

    var userSetting = userSettingProvider
        .firstWhere((userSetting) => userSetting.userId == userId);

    List<MapEntry<String, DateTime>> foodDiaries = foodDiaryProvider
        .where((foodDiary) => foodDiary.userId == userId)
        .map((diary) => new MapEntry<String, DateTime>(
            diary.foodDiaryId, diary.foodDiaryDate))
        .toList();

    Map<String, DateTime> foodDiaryDictionary = Map.fromIterable(foodDiaries,
        key: (item) => item.key, value: (item) => item.value);

    var meals = mealProvider
        .where((meal) => foodDiaryDictionary.containsKey(meal.foodDiaryId));

    var mealsForDiary = meals.map((meal) => new MapEntry<String, DateTime>(
        meal.mealId, foodDiaryDictionary[meal.foodDiaryId]));
    Map<String, DateTime> mealDictionary = Map.fromIterable(mealsForDiary,
        key: (item) => item.key, value: (item) => item.value);
    var foods =
        foodProvider.where((food) => mealDictionary.containsKey(food.mealId));

    var totalFoods = foods.map((food) =>
        new MapEntry<Food, DateTime>(food, mealDictionary[food.mealId]));

    Map<DateTime, List<MapEntry<Food, DateTime>>> dateGroupForFoods =
        groupBy(totalFoods, (obj) => obj.value);
    var dateCalorieSum = new List<TimeSeriesSales>();
    dateGroupForFoods.forEach((k, v) => dateCalorieSum.add(new TimeSeriesSales(
        k, v.map((food) => food.key.calories).reduce((a, b) => a + b))));
    var dateFatSum = new List<TimeSeriesSales>();
    dateGroupForFoods.forEach((k, v) => dateFatSum.add(new TimeSeriesSales(
        k, v.map((food) => food.key.fat).reduce((a, b) => a + b))));

    var dateCarbsSum = new List<TimeSeriesSales>();
    dateGroupForFoods.forEach((k, v) => dateCarbsSum.add(new TimeSeriesSales(
        k, v.map((food) => food.key.carbohydrates).reduce((a, b) => a + b))));

    var dateProteinSum = new List<TimeSeriesSales>();
    dateGroupForFoods.forEach((k, v) => dateProteinSum.add(new TimeSeriesSales(
        k, v.map((food) => food.key.protein).reduce((a, b) => a + b))));

    return DefaultTabController(
        length: 5,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
                title: Text("Timelines"),
                centerTitle: true,
                backgroundColor: Colors.red,
                bottom: TabBar(
                  tabs: <Widget>[
                    Text("Calorie"),
                    Text("Fat"),
                    Text("Carbs"),
                    Text("Protein"),
                    Text("Weight"),
                  ],
                )),
            body: TabBarView(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    _createGraph("Calories", "kCal", dateCalorieSum)
                  ],
                ),
                ListView(
                  children: <Widget>[
                    _createGraph("Fat", "g", dateFatSum)
                  ],
                ),
                ListView(
                  children: <Widget>[
                    _createGraph("Carbohydrates", "g", dateCarbsSum)
                  ],
                ),
                ListView(
                  children: <Widget>[
                    _createGraph("Protein", "g", dateProteinSum)
                  ],
                ),
                ListView(
                  children: <Widget>[
                    _createGraph("Weight", "lbs", dateCalorieSum)
                  ],
                ),
              ],
            )));
  }

  Widget _createGraph(
      String graphTitle, String yAxisTitle, List<TimeSeriesSales> sampleData) {
    return Container(
      height: 300,
      child: charts.TimeSeriesChart(
        _createSampleData(sampleData),
        behaviors: [
          new charts.PanAndZoomBehavior(),
          new charts.ChartTitle(yAxisTitle,
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
          new charts.ChartTitle(graphTitle,
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
        ],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      List<TimeSeriesSales> timeSeriesSales) {
    //Sorts by ascending time for data points
    timeSeriesSales.sort((a, b) => a.time.compareTo(b.time));

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Fitness Over Time',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.amount,
        data: timeSeriesSales,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final double amount;

  TimeSeriesSales(this.time, this.amount);
}
