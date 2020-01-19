import "package:flutter/material.dart";
import 'package:hello_world/models/food.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/meal.dart';
import 'package:hello_world/screens/home/addMeal.dart';
import 'package:hello_world/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/models/user.dart';
import 'package:uuid/uuid.dart';

class FoodDiaryDetails extends StatelessWidget {
  final DateTime foodDiaryDate;
  FoodDiaryDetails({this.foodDiaryDate});

  @override
  Widget build(BuildContext context) {
    var foodDiaries = Provider.of<List<FoodDiary>>(context);

    final user = Provider.of<User>(context);
    var userId = user.uid;

    foodDiaries = foodDiaries.where((value) => value != null).toList();
    var foodDiaryForDate = foodDiaries.where((foodDiary) =>
        foodDiary.foodDiaryDate.day == foodDiaryDate.day &&
        foodDiary.userId == userId);

    final now = DateTime.now();

    //If a food diary cannot be found for the current day, add a Food Diary to Firebase
    if (foodDiaryForDate.length == 0 &&
        foodDiaryDate.month == now.month &&
        foodDiaryDate.day == now.day &&
        foodDiaryDate.year == now.year) {
      var foodDiaryId = Uuid().v4.toString();
      DatabaseService(uid: userId.toString())
          .updateUserData(foodDiaryDate, foodDiaryId);
      return Text(DateFormat("yyyy-MM-dd").format(foodDiaryDate));
    } else if (foodDiaryForDate.length == 0) {
      return Text("No Food Diary found for this date");
    }

    var foodDiary = foodDiaryForDate.first;

    var meals = Provider.of<List<Meal>>(context);
    var mealsDisplay = <DataRow>[];

    if (meals != null) {
      var mealsForFoodDiary =
          meals.where((meal) => meal.foodDiaryId == foodDiary.foodDiaryId);

      if (mealsForFoodDiary.length > 0) {
        int count = 1;
        for (var meal in mealsForFoodDiary) {
          mealsDisplay.add(DataRow(cells: [
            DataCell(Text("Meal #" + count.toString())),
            DataCell(Text('Details', style: TextStyle(color: Colors.lightBlue)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: "/AddMeal"),
                      builder: (context) => StreamProvider<List<Food>>.value(
                          value: DatabaseService(uid: userId).foods,
                          child: AddMeal(
                            foodDiaryId: foodDiary.foodDiaryId,
                            mealId: meal.mealId,
                          )),
                    ));
              })
          ]));
        }
      }
    }

    return ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 200)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 50,
                child: Text("         0%\nCalorie Goal",
                    style: TextStyle(color: Colors.white))),
            Padding(padding: EdgeInsets.all(20)),
            CircleAvatar(
                backgroundColor: Colors.red,
                radius: 50,
                child: Text("      0%\nFat Goal",
                    style: TextStyle(
                      color: Colors.white,
                    )))
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50,
                child: Text("        0%\nCarbs Goal",
                    style: TextStyle(color: Colors.white))),
            Padding(padding: EdgeInsets.all(20)),
            CircleAvatar(
                backgroundColor: Colors.green,
                radius: 50,
                child: Text("          0%\nProtein Goal",
                    style: TextStyle(
                      color: Colors.white,
                    )))
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          children: <Widget>[
            FlatButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: "/AddMeal"),
                      builder: (context) => StreamProvider<List<Food>>.value(
                          value: DatabaseService(uid: userId).foods,
                          child: AddMeal(
                            foodDiaryId: foodDiary.foodDiaryId,
                            mealId: Uuid().v4().toString(),
                          )),
                    ));
              },
              icon: Icon(Icons.add, size: 26),
              label: Text("Add a Meal", style: TextStyle(fontSize: 24)),
            )
          ],
        ),
        DataTable(columns: [
          DataColumn(
              label: Text('Meal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ))),
          DataColumn(
              label: Text('More Info',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        ], rows: mealsDisplay)
      ],
    );
  }
}
