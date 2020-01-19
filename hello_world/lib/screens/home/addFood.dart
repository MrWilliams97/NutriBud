import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AddFood extends StatefulWidget {
  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  Widget searchResults = new Container();

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        TextField(
          onSubmitted: (val) async {
            var searchOptions = await fetchSearchOptions(val);
            setState(() {
              searchResults = _buildSearchResults(searchOptions);
            });
          },
        )
        , searchResults
      ],
    );
  }

  Widget _buildSearchResults(String searchOptions){

  }

  Future<String> fetchSearchOptions (String searchInput) async {
    var url = "http://10.0.3.2:5000/search/" + searchInput;
    final response = await http.get(url);

    if (response.statusCode == 200){
      return response.body;
    } else {
      throw Exception("Failed to retrieve search results");
    }
  }
}