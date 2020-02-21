import 'package:hello_world/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/screens/home/foodDiaryScreen.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context){

    final user = Provider.of<User>(context);

    if (user == null){
      //Go to Sign in Screen
      return Authenticate();
    } else {
      //Go to the Home Screen of NutriBud
      return StreamProvider.value(
        value: DatabaseService(uid: user.uid).meals,
        child: FoodDiaryScreen()
      );
    }
  }
}