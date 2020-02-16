import 'package:hello_world/models/fitnessGoal.dart';

class UserSettings {
  String userId;
  DateTime dateOfBirth;
  bool isMale;
  String firstName; 
  String lastName; 
  String userName;
  double height;
  FitnessGoal ongoingFitnessGoal;

  UserSettings({this.userId, this.dateOfBirth, this.isMale, this.firstName, this.lastName, this.userName, this.height, this.ongoingFitnessGoal});
}