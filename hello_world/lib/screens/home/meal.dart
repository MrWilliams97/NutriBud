import "package:flutter/material.dart";
import 'package:hello_world/screens/home/addFood.dart';

class Meal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Meal"),
      ),
      body: Column(
        children: <Widget>[
          _buildAddFoodDropdown(),
        ],
      ),
    );
  }

  Widget _buildAddFoodDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
            color: Colors.blueGrey, style: BorderStyle.solid, width: 2),
      ),
      child: DropdownButton<String>(
        hint: Row(
          children: <Widget>[
            Icon(Icons.add, color: Colors.grey),
            Text("    Add a Food")
          ],
        ),
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black),
        onChanged: (String newValue) {
          if (newValue == "Camera") {
            //
          } else if (newValue == "Lookup") {
          } else if (newValue == "Barcode") {}
        },
        items: [
          DropdownMenuItem(
            value: "Camera",
            child: Row(
              children: <Widget>[Icon(Icons.photo_camera), Text("   Camera")],
            ),
          ),
          DropdownMenuItem(
            value: "Lookup",
            child: Row(
              children: <Widget>[Icon(Icons.search), Text("   Search")],
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
      ),
    );
  }
}
