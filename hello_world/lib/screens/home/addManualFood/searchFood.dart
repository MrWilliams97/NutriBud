import "package:flutter/material.dart";
import 'package:hello_world/models/food.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/meal.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:hello_world/screens/home/addManualFood/addFood.dart';
import 'package:hello_world/services/database.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';

import 'package:uuid/uuid.dart';

class SearchFood extends StatefulWidget {
  final String mealId;
  FoodDiary foodDiary;

  SearchFood({this.mealId, this.foodDiary});

  @override
  _SearchFoodState createState() => _SearchFoodState();
}

class _SearchFoodState extends State<SearchFood> {
  Widget searchResults = new Column();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextField(
            decoration: new InputDecoration(
                icon: Icon(Icons.search, color: Colors.white),
                labelText: "Search Food",
                labelStyle: TextStyle(color: Colors.white)),
            style: new TextStyle(color: Colors.white),
            onChanged: (val) async {
              if (val.isNotEmpty) {
                var searchOptions = await fetchSearchOptions(val);
                setState(() {
                  searchResults = _buildSearchResults(searchOptions);
                });
              }
            },
          ),
        ),
        body: ListView(
          children: <Widget>[searchResults],
        ));
  }

  Widget _buildSearchResults(List<dynamic> searchOptions) {
    final widgets = <Widget>[];

    //For each option in search options, create a row for it
    for (var option in searchOptions) {
      Widget leadingWidget = Icon(Icons.fastfood);
      if (option['photo'] != null) {
        leadingWidget = Image.network(option['photo']);
      }

      widgets.add(Card(
        child: Column(
          children: <Widget>[
            ListTile(
                leading: leadingWidget,
                title: Text(option['brandName']),
                subtitle: Text(option['foodName']),
                trailing: Icon(Icons.arrow_right),
                onTap: () async {
                  var food = await fetchFood(option['nixItem']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StreamProvider<List<Meal>>.value(
                                  value: DatabaseService(
                                          uid: widget.foodDiary.userId)
                                      .meals,
                                  child:
                                      StreamProvider<List<UserSettings>>.value(
                                    value: DatabaseService(
                                            uid: widget.foodDiary.userId)
                                        .userSettings,
                                    child: StreamProvider<List<Food>>.value(
                                        value: DatabaseService(
                                                uid: widget.foodDiary.userId)
                                            .foods,
                                        child: AddFood(
                                            food: food,
                                            foodDiary: widget.foodDiary)),
                                  ))));
                })
          ],
        ),
      ));
    }

    return Container(
        color: Colors.white,
        child: Column(
          children: widgets,
        ));
  }

  Future<List<dynamic>> fetchSearchOptions(String searchInput) async {
    var url = "http://ec2-3-15-19-52.us-east-2.compute.amazonaws.com/search/" + searchInput;
    final response = await http.get(url);
    

    if (response.statusCode == 200) {
      List<dynamic> searchOptions = json.decode(response.body);
      return searchOptions;
    } else {
      throw Exception("Failed to retrieve search results");
    }
  }

  Future<Food> fetchFood(String nutritionixId) async {
    var url = "http://ec2-3-15-19-52.us-east-2.compute.amazonaws.com/retrieveFood/" + nutritionixId;
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
}
