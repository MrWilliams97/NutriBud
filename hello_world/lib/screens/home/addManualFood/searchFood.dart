import "package:flutter/material.dart";
import 'package:hello_world/models/food.dart';
import 'package:hello_world/screens/home/AddManualFood/addFood.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SearchFood extends StatefulWidget {
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
            decoration: new InputDecoration(icon: Icon(Icons.search, color: Colors.white), labelText: "Search Food", labelStyle: TextStyle(color: Colors.white)),
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
      widgets.add(FlatButton.icon(
          onPressed: () async {
            var food = await fetchFood(option['nixItem']);
             Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFood(food: food)),
                );
          },
          label: Text(option['brandName'] + "    " + option['foodName']),
          icon: Icon(Icons.arrow_right)));
    }

    return Container(
        color: Colors.white,
        child: Column(
          children: widgets,
        ));
  }

  Future<List<dynamic>> fetchSearchOptions(String searchInput) async {
    var url = "http://10.0.3.2:5000/search/" + searchInput;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> searchOptions = json.decode(response.body);
      return searchOptions;
    } else {
      throw Exception("Failed to retrieve search results");
    }
  }

  Future<Food> fetchFood(String nutritionixId) async {
    var url = "http://10.0.3.2:5000/retrieveFood/" + nutritionixId;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> searchOptions = json.decode(response.body);
      
      Food food = new Food(
        servingQuantity: searchOptions[0]['ServingQuantity'],
        servingUnit: searchOptions[0]['ServingUnit'],
        calories: searchOptions[0]['Calories'],
        fat: searchOptions[0]['Fat'],
        cholestrol: searchOptions[0]['Cholestrol'],
        sodium: searchOptions[0]['Sodium'],
        carbohydrates: searchOptions[0]['Carbohydrates'],
        fiber: searchOptions[0]['Fiber'],
        sugar: searchOptions[0]['Sugar'],
        protein: searchOptions[0]['Protein'],
        potassium: searchOptions[0]['Potassium']
      );

      return food;
    } else {
      throw Exception("Failed to retrieve search results");
    }
  }
}
