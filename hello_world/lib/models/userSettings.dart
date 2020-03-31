import 'package:hello_world/models/fitnessGoal.dart';

class UserSettings {
  String userId;
  DateTime dateOfBirth;
  bool isMale;
  String firstName = ""; 
  String lastName = ""; 
  String userName = "";
  double height;
  FitnessGoal ongoingFitnessGoal;
  Map<String, double> weightEntries = new Map<String, double>();

  UserSettings({this.userId, this.dateOfBirth, this.isMale, this.firstName, this.lastName, 
                this.userName, this.height, this.ongoingFitnessGoal, this.weightEntries});

}