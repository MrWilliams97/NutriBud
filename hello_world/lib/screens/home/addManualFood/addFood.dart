import "package:flutter/material.dart";
import 'package:hello_world/models/food.dart';

class AddFood extends StatefulWidget {

  Food food;
  
  AddFood({this.food});

  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Food")
      ),
      body: ListView(
        children: <Widget>[
          DataTable(
            columns: [
              DataColumn(label: Text("Nutrient")),
              DataColumn(label: Text("Amount"))
            ],
            rows: <DataRow>[
              DataRow(
                cells: [
                  DataCell(Text("Calories")),
                  DataCell(Text(widget.food.calories.toString()))
                ]
              ),
              DataRow(
                cells: [
                  DataCell(Text("Fat")),
                  DataCell(Text(widget.food.fat.toString()))
                ]
              ),
              DataRow(
                cells: [
                  DataCell(Text("Cholesterol")),
                  DataCell(Text(widget.food.cholestrol.toString()))
                ]
              ),
              DataRow(
                cells: [
                  DataCell(Text("Sodium")),
                  DataCell(Text(widget.food.sodium.toString()))
                ]
              ),
              DataRow(
                cells: [
                  DataCell(Text("Carbohydrates")),
                  DataCell(Text(widget.food.carbohydrates.toString()))
                ]
              ),
              DataRow(
                cells: [
                  DataCell(Text("Fiber")),
                  DataCell(Text(widget.food.fiber.toString()))
                ]
              ),
              DataRow(
                cells: [
                  DataCell(Text("Sugar")),
                  DataCell(Text(widget.food.sugar.toString()))
                ]
              ),
              DataRow(
                cells: [
                  DataCell(Text("Protein")),
                  DataCell(Text(widget.food.protein.toString()))
                ]
              ),
              DataRow(
                cells: [
                  DataCell(Text("Potassium")),
                  DataCell(Text(widget.food.potassium.toString()))
                ]
              ),
            ]
          ),
        ],
      ),
    );
  }

}