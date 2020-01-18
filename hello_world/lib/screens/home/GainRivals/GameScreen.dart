import 'package:flutter/material.dart';

// Define a corresponding State class.
// This class holds the data related to the Form.
class GameScreen extends StatelessWidget {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Your Game'),
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
            ],
          ),
        ),
      )
    );
  }
}