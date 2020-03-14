import 'package:hello_world/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/screens/home/FoodDiary/foodDiaryScreen.dart';
import 'package:hello_world/screens/onboardingScreen.dart';
import 'package:hello_world/services/auth.dart';
import 'package:hello_world/services/database.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/models/userSettings.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var userSettings = Provider.of<List<UserSettings>>(context);

    if (user == null) {
      //Go to Sign in Screen
      return Authenticate();
    }
    if (user != null) {
      var userSettingForUser =
          userSettings.where((i) => i.userId == user.uid);

      if (userSettingForUser.length != 0) {
        return StreamProvider.value(
            value: DatabaseService(uid: user.uid).meals,
            child: FoodDiaryScreen());
      } else {
        return StreamProvider.value(
          value: AuthService().user,
          child: OnboardingScreen()
        );
      }
    }
  }
}
