import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Settings"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
          child:Center(
            child: ListView(
              children: <Widget>[
                DataTable(
                  columns: [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('Your Settings'))
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(
                          Text('Dash'),
                          showEditIcon: true,
                        ),
                        DataCell(Text('2018'))
                      ]
                    )
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}