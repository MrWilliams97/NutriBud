import 'package:hello_world/models/calorieGoal.dart';
import 'package:intl/intl.dart';

class FitnessGoal {
  DateTime startDate;
  DateTime endDate;
  double startWeight;
  double endWeight;
  CalorieGoal calorieGoal;

  FitnessGoal({this.startDate, this.endDate, this.startWeight, this.endWeight, this.calorieGoal});
  Map<String, dynamic> toJson() => {
    'startDate': DateFormat("yyyy-MM-dd").format(startDate),
    'endDate': DateFormat("yyyy-MM-dd").format(endDate),
    'startWeight': startWeight,
    'endWeight': endWeight,
    'calorieGoal': calorieGoal.toJson(),
  };
}