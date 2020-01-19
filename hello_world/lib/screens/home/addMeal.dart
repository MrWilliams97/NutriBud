import 'package:flutter/material.dart';


class AddMeal extends StatefulWidget {
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  //THIS WILL BE STORED IN THE DATABASE
  List<DataRow> foods = [];

  @override
  Widget build(BuildContext context) {
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
                _buildInfoCard(),
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
                      _addFoodItem('Camera');
                    });
                  } else if (newValue == "Lookup") {
                    // Go to search screen
                    setState(() {
                      _addFoodItem('Manual');
                    });
                  } else if (newValue == "Barcode") {
                    // Go to barcode screen
                    setState(() {
                      _addFoodItem('Barcode');
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
                      children: <Widget>[Icon(Icons.search), Text("   Manual Search")],
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
            rows: foods,
          ),
        ],
      ),
    );
  }

  void _addFoodItem(String food) {
    //adds a food item to the list
    print('added: ' + food);
    foods.add(
      DataRow(cells: [
        DataCell(Text(food)),
        DataCell(Text('details'), onTap: () {
          print("tapped motherfucker.");
        }),
      ]),
    );
  }

  Widget _buildInfoCard() {
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
                  Text('200'),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}