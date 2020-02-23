import 'package:flutter/material.dart';
import 'package:hello_world/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:hello_world/services/auth.dart';

void main() => runApp(NutriBudApp());

class NutriBudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return StreamProvider.value(
      value: AuthService().user,
      child: MaterialApp(
        title: "NutriBud",
        home: Wrapper()
      )
    );
  }
}