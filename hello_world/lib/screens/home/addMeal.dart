import 'package:flutter/material.dart';
import 'package:hello_world/models/food.dart';
import 'package:hello_world/screens/home/addManualFood/addFood.dart';
import 'package:hello_world/screens/home/addManualFood/searchFood.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';

class AddMeal extends StatefulWidget {
  final String foodDiaryId;
  final String mealId;
  AddMeal({this.foodDiaryId, this.mealId});

  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  //THIS WILL BE STORED IN THE DATABASE
  List<DataRow> foodsDisplay = [];

  @override
  Widget build(BuildContext context) {
    List<Food> foods = Provider.of<List<Food>>(context);

    var foodsForMeal = <Food>[];
    if (foods != null) {
      if (foods.length > 0) {
        foodsDisplay = [];
        foodsForMeal = foods.where((food) => food.mealId == widget.mealId).toList();
        if (foodsForMeal.length > 0) {
          // Add this meal to the database and display foods
          for (var food in foodsForMeal) {
            _addFoodItem(food);
          }
          DatabaseService().addMeal(widget.foodDiaryId, widget.mealId);
        }
      }
    }

    return Container(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
          ),
          body: SafeArea(
            //creates column to display all the widgets in vertical order
            child: Column(
              children: <Widget>[
                _buildButton(),
                Divider(
                  color: Colors.red,
                  thickness: 10,
                ),
                _buildFoodTable(),
                //adds a red line to seperate food list item from summary
                Divider(
                  color: Colors.red,
                  thickness: 10,
                ),
                _buildInfoCard(foodsForMeal),
              ],
            ),
          )),
    );
  }

  Widget _buildButton() {
    //adds 3 buttons for each way of adding food
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.red,
                border: Border.all(
                    color: Colors.lightBlue,
                    style: BorderStyle.solid,
                    width: 2),
              ),
              child: DropdownButton<String>(
                hint: Row(
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white),
                    Text("     Add a Food",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                icon: Icon(Icons.arrow_downward, color: Colors.white),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                onChanged: (String newValue) {
                  if (newValue == "Camera") {
                    // Go to camera screen
                    setState(() {
                      _addFoodItem(new Food());
                    });
                  } else if (newValue == "Lookup") {
                    // Go to search screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchFood(mealId: widget.mealId),
                        ));
                  } else if (newValue == "Barcode") {
                    // Go to barcode screen
                    setState(() {
                      _addFoodItem(new Food());
                    });
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: "Camera",
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.photo_camera),
                        Text("   Camera")
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Lookup",
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search),
                        Text("   Manual Search")
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Barcode",
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera_enhance),
                        Text("   Barcode")
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildFoodTable() {
    //makes a table to display all the food items already added
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          DataTable(
            columns: [
              DataColumn(
                  label: Text('Food',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ))),
              DataColumn(
                  label: Text('More Info',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))),
            ],
            rows: foodsDisplay,
          ),
        ],
      ),
    );
  }

  void _addFoodItem(Food food) {
    //adds a food item to the list
    foodsDisplay.add(
      DataRow(cells: [
        DataCell(Text(food.brandName + " - " + food.foodName)),
        DataCell(Text('Details', style: TextStyle(color: Colors.lightBlue)),
            onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFood(food: food),
              ));
        }),
      ]),
    );
  }

  Widget _buildInfoCard(List<Food> foods) {
    double calorieSum = 0;
    double fatSum = 0;
    double cholesterolSum = 0;
    double sodiumSum = 0;
    double carbohydratesSum = 0;
    double fiberSum = 0;
    double sugarSum = 0;
    double proteinSum = 0;
    double potassiumSum = 0;

    for(var food in foods){
      calorieSum += food.calories;
      fatSum += food.fat;
      cholesterolSum += food.cholesterol;
      sodiumSum += food.sodium;
      carbohydratesSum += food.carbohydrates;
      fiberSum += food.fiber;
      sugarSum += food.sugar;
      proteinSum += food.protein;
      potassiumSum += food.potassium;
    }

    //build info card that contains all the summed up info
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          DataTable(
            columns: [
              DataColumn(
                  label: Text('Nutrient',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ))),
              DataColumn(
                  label: Text('Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Calories')),
                DataCell(
                  Text(calorieSum.toString()),
                ),
              ],),
              DataRow(cells: [
                DataCell(Text('Fat')),
                DataCell(
                  Text(fatSum.toString()),
                ),
              ],),
              DataRow(cells: [
                DataCell(Text('Cholesterol')),
                DataCell(
                  Text(cholesterolSum.toString()),
                ),
              ],),
              DataRow(cells: [
                DataCell(Text('Sodium')),
                DataCell(
                  Text(sodiumSum.toString()),
                ),
              ],),
              DataRow(cells: [
                DataCell(Text('Carbohydrates')),
                DataCell(
                  Text(carbohydratesSum.toString()),
                ),
              ],),
              DataRow(cells: [
                DataCell(Text('Fiber')),
                DataCell(
                  Text(fiberSum.toString()),
                ),
              ],),
              DataRow(cells: [
                DataCell(Text('Sugar')),
                DataCell(
                  Text(sugarSum.toString()),
                ),
              ],),
              DataRow(cells: [
                DataCell(Text('Protein')),
                DataCell(
                  Text(proteinSum.toString()),
                ),
              ],),
              DataRow(cells: [
                DataCell(Text('Potassium')),
                DataCell(
                  Text(potassiumSum.toString()),
                ),
              ],),
            ],
          ),
        ],
      ),
    );
  }
}
