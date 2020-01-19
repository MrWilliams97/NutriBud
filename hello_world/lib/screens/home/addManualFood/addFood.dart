import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AddFood extends StatefulWidget {
  
  final String nutritionixId;

  AddFood({this.nutritionixId});

  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood>{
  @override
  Widget build(BuildContext context){
    
  }

  Future<List<dynamic>> fetchFood(String nutritionixId) async {
    var url = "http://10.0.3.2:5000/retrieveFood/" + nutritionixId;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> searchOptions = json.decode(response.body);
      return searchOptions;
    } else {
      throw Exception("Failed to retrieve search results");
    }
  }
}