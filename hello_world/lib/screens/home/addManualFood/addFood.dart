import "package:flutter/material.dart";
import 'package:hello_world/models/food.dart';

class AddFood extends StatefulWidget {

  Food food;
  
  AddFood({this.food});

  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood>{
  @override
  Widget build(BuildContext context){
    return ListView();
  }

}