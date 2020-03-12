import 'package:flutter/material.dart';
import 'package:hello_world/models/calorieGoal.dart';
import 'package:hello_world/models/fitnessGoal.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:hello_world/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Define a corresponding State class.
// This class holds the data related to the Form.

class UserSettingsScreen extends StatefulWidget {
  UserSettings currentUser;

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettingsScreen> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  String _selectedDate = 'Tap to select date';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2022),
    );
    if (d != null)
      setState(() {
        widget.currentUser.dateOfBirth = d;
      });
  }

  _createFirstNameDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Modify First Name"),
            content: TextField(controller: customController),
            actions: <Widget>[
              MaterialButton(
                child: Text('Submit'),
                onPressed: () {
                  setState(() {
                    widget.currentUser.firstName =
                        customController.text.toString();
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _createLastNameDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Modify Last Name"),
            content: TextField(controller: customController),
            actions: <Widget>[
              MaterialButton(
                child: Text('Submit'),
                onPressed: () {
                  setState(() {
                    widget.currentUser.lastName =
                        customController.text.toString();
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _createUsernameDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Modify Username"),
            content: TextField(controller: customController),
            actions: <Widget>[
              MaterialButton(
                child: Text('Submit'),
                onPressed: () {
                  setState(() {
                    widget.currentUser.userName =
                        customController.text.toString();
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _createHeightDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    bool _notDouble = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Modify Height (cm)"),
            content: TextField(
                controller: customController,
                decoration: InputDecoration(
                  errorText: _notDouble ? 'Value must be a number' : null,
                )),
            actions: <Widget>[
              MaterialButton(
                child: Text('Submit'),
                onPressed: () {
                  setState(() {
                    if (double.tryParse(customController.text.toString()) ==
                        null) {
                      _notDouble = true;
                    } else {
                      widget.currentUser.height =
                          double.parse(customController.text.toString());

                      // foodDiary.caloriesBurned = inputString
                      // fo
                      Navigator.of(context).pop();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  _createCalorieGoalDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    TextEditingController goalWeightController = TextEditingController();
    bool _notDouble = false;
    DateTime calorieGoalDate = DateTime.now();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100.0),
              child: AlertDialog(
                title: Text("Create Calorie Goal"),
                content: new ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 250.0),
                  child: Column(children: <Widget>[
                    Text("Insert Current Weight"),
                    TextField(
                        controller: customController,
                        decoration: InputDecoration(
                          errorText:
                              _notDouble ? 'Value must be a number' : null,
                        )),
                    Text("Insert Goal End Date"),
                    Text(
                        new DateFormat.yMMMMd("en_US").format(calorieGoalDate)),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      tooltip: 'Tap to open date picker',
                      onPressed: () async {
                        final DateTime d = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2022),
                        );
                        if (d != null)
                          setState(() {
                            calorieGoalDate = d;
                          });
                      },
                    ),
                    Text("Insert Goal Weight"),
                    TextField(
                        controller: goalWeightController,
                        decoration: InputDecoration(
                          errorText:
                              _notDouble ? 'Value must be a number' : null,
                        ))
                  ]),
                ),
                actions: <Widget>[
                  MaterialButton(
                    child: Text('Submit'),
                    onPressed: () {
                      setState(() {
                        if (double.tryParse(customController.text.toString()) ==
                            null) {
                          _notDouble = true;
                        } else {
                          FitnessGoal fitnessGoal = new FitnessGoal(
                              startDate: DateTime.now(),
                              endDate: calorieGoalDate,
                              startWeight: double.parse(customController.text),
                              endWeight:
                                  double.parse(goalWeightController.text));
                          widget.currentUser.ongoingFitnessGoal = fitnessGoal;
                          _createCalorieBreakdownDialog(context);
                        }
                      });
                    },
                  )
                ],
              ),
            );
          });
        });
  }

  _createCalorieBreakdownDialog(BuildContext context) {
    var kgsInPound = 0.453592;
    var userAge =
        (DateTime.now().difference(widget.currentUser.dateOfBirth).inDays / 365)
            .floor();

    var bmr =
        10 * widget.currentUser.ongoingFitnessGoal.startWeight * kgsInPound +
            6.25 * widget.currentUser.height / 100.0 -
            5 * userAge +
            5;
    
    if (!widget.currentUser.isMale){
      bmr = 10 * widget.currentUser.ongoingFitnessGoal.startWeight * kgsInPound + 6.25 * widget.currentUser.height / 100.0 - 5 * userAge - 161;
    }

    var goalNumberOfDays = widget.currentUser.ongoingFitnessGoal.endDate
        .difference(widget.currentUser.ongoingFitnessGoal.startDate)
        .inDays;
    var calorieConsumption = 3500 *
        (widget.currentUser.ongoingFitnessGoal.endWeight -
            widget.currentUser.ongoingFitnessGoal.startWeight) /
        goalNumberOfDays.toDouble();
    var caloriesNeeded = (bmr + calorieConsumption).floor();

    var carbsSelection = 0.0;
    var fatsSelection = 0.0;
    var proteinSelection = 0.0;
    var disableCarbs = false;
    var disableFats = true;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Create Calorie Breakdown"),
              content: Column(
                children: <Widget>[
                  Text("Calories Required:" + caloriesNeeded.toString()),
                  Text("Carbohydrates (g): " +
                      carbsSelection.toStringAsFixed(2)),
                  Slider(
                    value: carbsSelection.toDouble(),
                    max: caloriesNeeded / 4.0,
                    label: "$carbsSelection",
                    min: 0,
                    onChanged: (double carbs) {
                      setState(() {
                        if (disableCarbs == false) {
                          carbsSelection = carbs;
                        } else {
                          return null;
                        }
                      });
                    },
                    onChangeEnd: (double carbs) {
                      setState(() {
                        if (disableCarbs == false) {
                          carbsSelection = carbs;
                          disableCarbs = true;
                          disableFats = false;
                        }
                      });
                    },
                  ),
                  Text("Fats (g): " + fatsSelection.toStringAsFixed(2)),
                  Slider(
                    value: fatsSelection.toDouble(),
                    max: (caloriesNeeded - carbsSelection * 4.0) / 9.0,
                    min: 0,
                    label: "$fatsSelection",
                    onChanged: (double fats) {
                      setState(() {
                        if (disableFats == false) {
                          fatsSelection = fats;
                        } else {
                          return null;
                        }
                      });
                    },
                    onChangeEnd: (double fats) {
                      setState(() {
                        proteinSelection = (caloriesNeeded -
                                carbsSelection * 4.0 -
                                fatsSelection * 9.0) /
                            4.0;
                      });
                    },
                  ),
                  Text("Protein (g): " + proteinSelection.toStringAsFixed(2)),
                  Slider(
                      value: proteinSelection.toDouble(),
                      max: proteinSelection,
                      min: 0,
                      label: "$proteinSelection",
                      onChanged: (double fats) {
                        setState(() {
                          return null;
                        });
                      },
                      onChangeEnd: (double fats) {}),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text('Submit'),
                  onPressed: () {
                    setState(() {
                      CalorieGoal calorieGoal = new CalorieGoal(
                          carbsPercentage:
                              (carbsSelection * 4.0) / caloriesNeeded,
                          proteinPercentage:
                              (proteinSelection * 4.0) / caloriesNeeded,
                          fatsPercentage:
                              (fatsSelection * 9.0) / caloriesNeeded);
                      widget.currentUser.ongoingFitnessGoal.calorieGoal =
                          calorieGoal;
                    });

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    var userSettings = Provider.of<List<UserSettings>>(context);

    final user = Provider.of<User>(context);
    var userId = user.uid;

    if (userSettings == null) {
      return Text("");
    }

    userSettings = userSettings.where((value) => value != null).toList();

    var userSetting =
        userSettings.where((userSetting) => userSetting.userId == userId);

    if (userSetting == null) {
      return Text("");
    }

    widget.currentUser = userSetting.toList().first;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Your Settings'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                      DataCell(Text('First Name')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(widget.currentUser.firstName.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))),
                            onTap: () {
                              _createFirstNameDialog(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.border_color),
                            tooltip: 'Modify First Name',
                            onPressed: () {
                              _createFirstNameDialog(context);
                            },
                          ),
                        ],
                      )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Last Name')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(widget.currentUser.lastName.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))),
                            onTap: () {
                              _createLastNameDialog(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.border_color),
                            tooltip: 'Modify Last Name',
                            onPressed: () {
                              _createLastNameDialog(context);
                            },
                          ),
                        ],
                      )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Gender')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text("M"),
                          Switch(
                            value: !widget.currentUser.isMale,
                            onChanged: (value) {
                              setState(() {
                                widget.currentUser.isMale = !widget.currentUser.isMale;
                              });
                            },
                            activeTrackColor: Colors.pinkAccent,
                            activeColor: Colors.pink,
                          ),
                          Text("F")
                        ],
                      )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Username')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(widget.currentUser.userName.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))),
                            onTap: () {
                              _createUsernameDialog(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.border_color),
                            tooltip: 'Modify Username',
                            onPressed: () {
                              _createUsernameDialog(context);
                            },
                          ),
                        ],
                      )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Height (cm)')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(widget.currentUser.height.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))),
                            onTap: () {
                              _createHeightDialog(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.border_color),
                            tooltip: 'Modify Height',
                            onPressed: () {
                              _createHeightDialog(context);
                            },
                          ),
                        ],
                      )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Active Calorie Goal')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                                widget.currentUser.ongoingFitnessGoal != null
                                    ? DateFormat("yyyy-MM-dd").format(widget
                                        .currentUser.ongoingFitnessGoal.endDate)
                                    : "",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))),
                            onTap: () {
                              _createCalorieGoalDialog(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.border_color),
                            tooltip: 'Modify Height',
                            onPressed: () {
                              _createCalorieGoalDialog(context);
                            },
                          ),
                        ],
                      )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Your Date of Birth')),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                  new DateFormat.yMMMMd("en_US")
                                      .format(widget.currentUser.dateOfBirth),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF000000))),
                              onTap: () {
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
                        ),
                      ),
                    ]),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Text("Modify Account Settings".toUpperCase()),
                      textColor: Colors.white,
                      color: Colors.red,
                      onPressed: () async {
                        DatabaseService(uid: userId)
                            .updateUserSettings(widget.currentUser);
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
