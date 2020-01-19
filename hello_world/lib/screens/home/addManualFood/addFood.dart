import "package:flutter/material.dart";
import 'package:hello_world/models/food.dart';
import 'package:hello_world/screens/home/addMeal.dart';

class AddFood extends StatefulWidget {
  Food food;

  AddFood({this.food});

  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red, title: Text("Food")),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(widget.food.brandName + " - " + widget.food.foodName),
              Text(widget.food.servingUnit)
            ],
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              initialValue: widget.food.servingQuantity.toString(),
              onChanged: (value) {
                setState(() {
                  var oldServingQuantity = widget.food.servingQuantity;
                  widget.food.servingQuantity = double.parse(value);
                  var factor = widget.food.servingQuantity / oldServingQuantity;

                  widget.food.calories = widget.food.calories * factor;
                  widget.food.fat = widget.food.fat * factor;
                  widget.food.cholestrol = widget.food.cholestrol * factor;
                  widget.food.sodium = widget.food.sodium * factor;
                  widget.food.carbohydrates =
                      widget.food.carbohydrates * factor;
                  widget.food.fiber = widget.food.fiber * factor;
                  widget.food.sugar = widget.food.sugar * factor;
                  widget.food.protein = widget.food.protein * factor;
                  widget.food.potassium = widget.food.potassium * factor;
                });
              }),
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
              DataCell(Text(widget.food.cholestrol.toString()))
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
          onPressed: () {
            Navigator.of(context)
              .popUntil(ModalRoute.withName("/AddMeal"));
          },
          color: Colors.red,
          textColor: Colors.white,
          child: Text("Add Food".toUpperCase(), style: TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
}
