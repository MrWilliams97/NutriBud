import 'package:flutter/material.dart';
import 'package:hello_world/models/food.dart';
import 'package:hello_world/screens/home/addManualFood/addFood.dart';
import 'package:hello_world/screens/home/addManualFood/searchFood.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart'; // show platform exception
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  var result = "";

  File imageFile;

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Food> foods = Provider.of<List<Food>>(context);

    var foodsForMeal = <Food>[];
    if (foods != null) {
      if (foods.length > 0) {
        foodsDisplay = [];
        foodsForMeal =
            foods.where((food) => food.mealId == widget.mealId).toList();
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
                onChanged: (String newValue) async {
                  if (newValue == "Camera") {
                    _openCamera(context);
                    // Go to camera screen
                    var options = await fetchOptions();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ButtonOptions(options: options, mealId: widget.mealId)),
                    );
                  } else if (newValue == "Lookup") {
                    // Go to search screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchFood(mealId: widget.mealId),
                        ));
                  } else if (newValue == "Barcode") {
                    //Pushes Barcode Widget
                    await _scanQR();
                    var food = await fetchUpc(result);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddFood(food: food)),
                    );
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

    for (var food in foods) {
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
              DataRow(
                cells: [
                  DataCell(Text('Calories')),
                  DataCell(
                    Text(calorieSum.toString()),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Fat')),
                  DataCell(
                    Text(fatSum.toString()),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Cholesterol')),
                  DataCell(
                    Text(cholesterolSum.toString()),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Sodium')),
                  DataCell(
                    Text(sodiumSum.toString()),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Carbohydrates')),
                  DataCell(
                    Text(carbohydratesSum.toString()),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Fiber')),
                  DataCell(
                    Text(fiberSum.toString()),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Sugar')),
                  DataCell(
                    Text(sugarSum.toString()),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Protein')),
                  DataCell(
                    Text(proteinSum.toString()),
                  ),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Potassium')),
                  DataCell(
                    Text(potassiumSum.toString()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<String>> fetchOptions() async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    String fileName = imageFile.path.split("/").last;

    var response = await http.post('http://localhost:8000/sendImage', body: {
      "image": base64Image,
      "name": fileName,
    });

    List<String> buttonOptions = [];
    if (response.statusCode == 200) {
      List<dynamic> options = jsonDecode(response.body);

      for (var option in options) {
        buttonOptions.add(option.toString());
      }
    }else {
      print("Fail");
    }
    

    return buttonOptions;
  }

  Future<Food> fetchUpc(String upc) async {
    // Need to replace with ngrok for now
    var url = "http://localhost:8000/retrieveUpc/" + upc;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> searchOptions =
          json.decode(response.body.toString());

      Food food = new Food(
        mealId: widget.mealId,
        foodId: Uuid().v4(),
        brandName: searchOptions['BrandName'],
        foodName: searchOptions['FoodName'],
        servingQuantity: double.parse(searchOptions['ServingQuantity'] == "None"
            ? "0"
            : searchOptions['ServingQuantity']),
        servingUnit: searchOptions['ServingUnit'],
        calories: double.parse(searchOptions['Calories'] == "None"
            ? "0"
            : searchOptions['Calories']),
        fat: double.parse(
            searchOptions['Fat'] == "None" ? "0" : searchOptions['Fat']),
        cholesterol: double.parse(searchOptions['Cholestrol'] == "None"
            ? "0"
            : searchOptions['Cholestrol']),
        sodium: double.parse(
            searchOptions['Sodium'] == "None" ? "0" : searchOptions['Sodium']),
        carbohydrates: double.parse(searchOptions['Carbohydrates'] == "None"
            ? "0"
            : searchOptions['Carbohydrates']),
        fiber: double.parse(
            searchOptions['Fiber'] == "None" ? "0" : searchOptions['Fiber']),
        sugar: double.parse(
            searchOptions['Sugar'] == "None" ? "0" : searchOptions['Sugar']),
        protein: double.parse(searchOptions['Protein'] == "None"
            ? "0"
            : searchOptions['Protein']),
        potassium: double.parse(searchOptions['Potassium'] == "None"
            ? "0"
            : searchOptions['Potassium']),
      );

      return food;
    } else {
      throw Exception("Failed to retrieve search results");
    }
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (e) {
      // ex user denies camera permissions?
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $e";
        });
      }
    } on FormatException {
      setState(() {
        result = "Back button was pressed before scanning";
      });
    } catch (e) {
      setState(() {
        result = "Unknown Error $e";
      });
    }
  }
}

class ButtonOptions extends StatefulWidget {
  List<String> options;
  String mealId; 

  ButtonOptions({this.options, this.mealId});

  @override
  _ButtonOptionsState createState() => _ButtonOptionsState();
}

class _ButtonOptionsState extends State<ButtonOptions> {
  @override
  Widget build(BuildContext context) {
    var buttons = <Widget>[];

    for (var option in widget.options) {
      buttons.add(RaisedButton(
          onPressed: () async {
            var food = await getFoodFromName(option.toString());
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFood(food: food)),
                );
          },
          color: Colors.grey,
          child: Text(option.toString())));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
        ),
        body: ListView(
          children: buttons,
        ));
  }

  Future<Food> getFoodFromName(String name) async {
    var url = "http://localhost:8000/SampleApiCall/" + name;
    print("swag");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("success");
      Map<String, dynamic> searchOptions = json.decode(response.body.toString());
      
      Food food = new Food(
        mealId: widget.mealId,
        foodId: Uuid().v4(),
        brandName: searchOptions['BrandName'],
        foodName: searchOptions['FoodName'],
        servingQuantity: double.parse(searchOptions['ServingQuantity'] == "None" ? "0": searchOptions['ServingQuantity']),
        servingUnit: searchOptions['ServingUnit'],
        calories: double.parse(searchOptions['Calories'] == "None" ? "0": searchOptions['Calories']),
        fat: double.parse(searchOptions['Fat'] == "None" ? "0": searchOptions['Fat']),
        cholesterol: double.parse(searchOptions['Cholestrol'] == "None" ? "0": searchOptions['Cholestrol']),
        sodium: double.parse(searchOptions['Sodium'] == "None" ? "0": searchOptions['Sodium']),
        carbohydrates: double.parse(searchOptions['Carbohydrates'] == "None" ? "0": searchOptions['Carbohydrates']),
        fiber: double.parse(searchOptions['Fiber'] == "None" ? "0": searchOptions['Fiber']),
        sugar: double.parse(searchOptions['Sugar'] == "None" ? "0": searchOptions['Sugar']),
        protein: double.parse(searchOptions['Protein'] == "None" ? "0": searchOptions['Protein']),
        potassium: double.parse(searchOptions['Potassium'] == "None" ? "0": searchOptions['Potassium']),
      );

      return food;
    } else {
      print(response.statusCode.toString());
      throw Exception("Failed to retrieve search results");
    }
  }
}
