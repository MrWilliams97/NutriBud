import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Define a corresponding State class.
// This class holds the data related to the Form.

class UserSettings extends StatefulWidget{
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  String _selectedDate = 'Tap to select date';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2022),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Your Settings'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                DataTable(
                  columns: [
                    DataColumn(label: Text('Account Settings')),
                    DataColumn(label: Text('Your Input')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Your Weight')),
                      DataCell(TextField(
                        decoration: new InputDecoration.collapsed(
                          hintText: 'Enter your Weight',
                        ),
                      )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Your Height')),
                      DataCell(TextField(
                        decoration: new InputDecoration.collapsed(
                          hintText: 'Enter your Height',
                        ),
                      )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Your Date of Birth')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                                _selectedDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))
                            ),
                            onTap: (){
                              _selectDate(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            tooltip: 'Tap to open date picker',
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        ],
                      ),),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}