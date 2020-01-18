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
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.red,
                border: Border.all(
                    color: Colors.lightBlue, style: BorderStyle.solid, width: 2),
              ),
              child: DropdownButton<String>(
                hint: Row(
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white),
                    Text("    Add a Food",
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
                  } else if (newValue == "Lookup") {
                    // Go to search screen
                  } else if (newValue == "Barcode") {
                    // Go to barcode screen
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
              )),
        ],
      ),
    );
  }
}
