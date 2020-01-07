import 'package:flutter/material.dart';

class Authenticated extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticated> {
  @override
  Widget build(BuildContext context){
    return Container (
      child: Text('authenticated!')
    );
  }
}