import 'package:flutter/material.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:hello_world/services/database.dart';
import 'package:hello_world/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/services/auth.dart';

void main() => runApp(NutriBudApp());

class NutriBudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
            providers: [StreamProvider(create: (_) => DatabaseService().userSettings), 
            StreamProvider(create: (_) => AuthService().user)] ,
            child: MaterialApp(title: "NutriBud", home: Wrapper()
          )
        );
  }
}
