import "package:flutter/material.dart";
import 'package:hello_world/models/food.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/models/meal.dart';

class AddFood extends StatefulWidget {
  Food food;
  FoodDiary foodDiary;
  AddFood({this.food, this.foodDiary});

  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  @override
  Widget build(BuildContext context) {
    var userSettings = Provider.of<List<UserSettings>>(context);
    var meals = Provider.of<List<Meal>>(context);
    var foods = Provider.of<List<Food>>(context);

    var mealsForFoodDiary = meals
        .where((meal) => meal.foodDiaryId == widget.foodDiary.foodDiaryId)
        .map((meal) => meal.mealId)
        .toList();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red, title: Text("Food")),
      body: ListView(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                new ListTile(
                  leading: Container(
                    width: 100,
                    child: TextFormField(
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        autovalidate: true,
                        validator: (input) {
                          RegExp regExp =
                              new RegExp(r'^(\d{0,5}\.\d{1,2}|\d{1,5})$');
                          if (!regExp.hasMatch(input)) {
                            return "Input must be up to two decimal places";
                          } else {
                            return null;
                          }
                        },
                        initialValue: widget.food.servingQuantity.toString(),
                        onChanged: (value) {
                          setState(() {
                            var oldServingQuantity =
                                widget.food.servingQuantity;
                            widget.food.servingQuantity = double.parse(value);
                            var factor = widget.food.servingQuantity /
                                oldServingQuantity;

                            widget.food.calories =
                                widget.food.calories * factor;
                            widget.food.fat = widget.food.fat * factor;
                            widget.food.cholesterol =
                                widget.food.cholesterol * factor;
                            widget.food.sodium = widget.food.sodium * factor;
                            widget.food.carbohydrates =
                                widget.food.carbohydrates * factor;
                            widget.food.fiber = widget.food.fiber * factor;
                            widget.food.sugar = widget.food.sugar * factor;
                            widget.food.protein = widget.food.protein * factor;
                            widget.food.potassium =
                                widget.food.potassium * factor;
                          });
                        }),
                  ),
                  title: Text(widget.food.brandName + ' (${widget.food.servingUnit})'),
                  subtitle: Text(widget.food.foodName),
                )
              ],
            ),
          ),
          DataTable(columns: [
            DataColumn(label: Text("Nutrient")),
            DataColumn(label: Text("Amount"))
          ], rows: <DataRow>[
            DataRow(cells: [
              DataCell(Text("Calories (kCal)")),
              DataCell(Text(widget.food.calories.toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("Fat (g)")),
              DataCell(Text(widget.food.fat.toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("Cholesterol (mg)")),
              DataCell(Text(widget.food.cholesterol.toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("Sodium (mg)")),
              DataCell(Text(widget.food.sodium.toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("Carbohydrates (g)")),
              DataCell(Text(widget.food.carbohydrates.toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("Fiber (g)")),
              DataCell(Text(widget.food.fiber.toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("Sugar (g)")),
              DataCell(Text(widget.food.sugar.toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("Protein (g)")),
              DataCell(Text(widget.food.protein.toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("Potassium (mg)")),
              DataCell(Text(widget.food.potassium.toString()))
            ]),
          ]),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red)),
          onPressed: () async {
            var foodsForFoodDiary = foods
                .where(
                    (mealFood) => mealsForFoodDiary.contains(mealFood.mealId))
                .toList();

            double totalCalories = 0;
            double totalFat = 0;
            double totalProtein = 0;
            double totalCarbs = 0;
            for (var food in foodsForFoodDiary) {
              totalCalories += food.calories;
              totalFat += food.fat;
              totalProtein += food.protein;
              totalCarbs += food.carbohydrates;
            }

            var userSetting = userSettings.firstWhere(
                (userSetting) => userSetting.userId == widget.foodDiary.userId);

            var kgsInPound = 0.453592;
            var userAge =
                (DateTime.now().difference(userSetting.dateOfBirth).inDays /
                        365)
                    .floor();

            var bmr =
                10 * userSetting.ongoingFitnessGoal.startWeight * kgsInPound +
                    6.25 * userSetting.height / 100.0 -
                    5 * userAge +
                    5;

            if (!userSetting.isMale) {
              bmr =
                  10 * userSetting.ongoingFitnessGoal.startWeight * kgsInPound +
                      6.25 * userSetting.height / 100.0 -
                      5 * userAge -
                      161;
            }

            var daysUntilGoalEnd = userSetting.ongoingFitnessGoal.endDate
                .difference(DateTime.now())
                .inDays;
            var calorieConsumption = 3500 *
                (userSetting.ongoingFitnessGoal.endWeight -
                    userSetting.ongoingFitnessGoal.startWeight) /
                daysUntilGoalEnd.toDouble();

            var caloriesNeeded = (bmr + calorieConsumption).floor();

            var proteinGoal = caloriesNeeded *
                userSetting.ongoingFitnessGoal.calorieGoal.proteinPercentage;
            var carbGoal = caloriesNeeded *
                userSetting.ongoingFitnessGoal.calorieGoal.carbsPercentage;
            var fatGoal = caloriesNeeded *
                userSetting.ongoingFitnessGoal.calorieGoal.fatsPercentage;

            widget.foodDiary.savedCalorieGoal =
                totalCalories / (caloriesNeeded.toDouble());
            widget.foodDiary.savedCarbGoal = totalCarbs / (carbGoal.toDouble());
            widget.foodDiary.savedFatGoal = totalFat / (fatGoal.toDouble());
            widget.foodDiary.savedProteinGoal =
                totalProtein / (proteinGoal.toDouble());

            await DatabaseService().uploadFoodData(widget.food);
            DatabaseService(uid: widget.foodDiary.userId)
                .updateUserData(widget.foodDiary);

            Navigator.of(context).popUntil(ModalRoute.withName("/AddMeal"));
          },
          color: Colors.red,
          textColor: Colors.white,
          child: Text("Add Food".toUpperCase(), style: TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
}
