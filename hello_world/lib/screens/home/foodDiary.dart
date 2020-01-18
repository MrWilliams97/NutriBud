import 'package:flutter/material.dart';
import 'package:hello_world/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:async';
import 'text_and_icon_button.dart';





class CameraMgr{
  CameraMgr._();
  CameraController _cameraCtrl;

  Future<CameraController> openCamera() async {
    CameraDescription cameraDescription;
    List<CameraDescription> cameras = await availableCameras();
    for (CameraDescription xx in cameras){
      if(xx.lensDirection==CameraLensDirection.front){
        cameraDescription = xx;
        break;
      }
    }
    if(cameraDescription==null){
      return null;
    }
    if (_cameraCtrl != null) {
      return _cameraCtrl;
    }
    _cameraCtrl = new CameraController(cameraDescription, ResolutionPreset.low)..addListener(() {
      if (_cameraCtrl.value.hasError) {
        print("");
      }
    });

    try {
      await _cameraCtrl.initialize();
    } on CameraException catch (e) {
      print(e);
    }
    return _cameraCtrl;
  }
  close()async {
    if (_cameraCtrl != null) {
      return _cameraCtrl;
    }
    _cameraCtrl = null;
  }
}
CameraMgr myCameraMgr = new CameraMgr._();






Future<Post> fetchPost() async {
  final response = await http.get('http://10.0.3.2:5000/SampleApiCall/tomato');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final String Calories;
  final String Fat;
  final String Cholestrol;
  final String Sodium;
  final String Carbohydrates;
  final String Fiber;
  final String Sugar;
  final String Protein;
  final String Potassium;
  final String Sugars;

  Post(
      {this.Calories,
      this.Fat,
      this.Cholestrol,
      this.Sodium,
      this.Carbohydrates,
      this.Fiber,
      this.Sugar,
      this.Protein,
      this.Potassium,
      this.Sugars});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      Calories: json['Calories'],
      Fat: json['Fat'],
      Cholestrol: json['Cholestrol'],
      Sodium: json['Sodium'],
      Carbohydrates: json['Carbohydrates'],
      Fiber: json['Fiber'],
      Sugar: json['Sugar'],
      Protein: json['Protein'],
      Potassium: json['Potassium'],
      Sugars: json['Sugars'],
    );
  }
}

class FoodDiary extends StatefulWidget {
  @override
  _FoodDiaryState createState() => _FoodDiaryState();
}

class _FoodDiaryState extends State<FoodDiary> {
  Future<Post> post;

  @override
  void initState() {
    super.initState();
    myCameraMgr.openCamera();
    // post = fetchPost();
  }

  @override
  void dispose(){
    super.dispose();
    myCameraMgr.close();
  }

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Stack(children: <Widget>[
      Scaffold(
          appBar: AppBar(
            title: Text('AppBar Back Button'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                new Container(
                    height: 150.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.0, left: 10.0),
                          child: Material(
                            type: MaterialType.transparency,
                            child: Center(
                              child: Ink(
                                  decoration: const ShapeDecoration(
                                    color: Colors.red,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    color: Colors.white,
                                    onPressed: () async {
                                      await _authService.signOut();
                                    },
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage("assets/images/food.jpg"),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [new BoxShadow(blurRadius: 40.0)],
                        borderRadius: new BorderRadius.vertical(
                            bottom: new Radius.elliptical(
                                MediaQuery.of(context).size.width, 100.0)))),
                
        FlatButton.icon(
          color: Colors.red,
          icon: Icon(Icons.add_a_photo), //`Icon` to display
          label: Text('Add a Photo'), //`Text` to display
          onPressed: () async{
                CameraController ctrl = await myCameraMgr.openCamera();
                  showDialog(
                    context: context,
                    builder: (BuildContext _){
                      return new Container(
                        height: 1600,
                        width: 1600,
                        child: new DialogCamera(ctrl),
                      );
                    }
                  );
            setState(() {
              post = fetchPost();
            });
            //Code to execute when Floating Action Button is clicked
            //...
          },
        ),



// CameraApp(),

                FutureBuilder<Post>(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                          'Calories: ${snapshot.data.Calories}\n Fat: ${snapshot.data.Fat}\n Cholestrol: ${snapshot.data.Cholestrol}\n Sodium: ${snapshot.data.Sodium}\n Carbohydrates: ${snapshot.data.Carbohydrates}\n Fiber: ${snapshot.data.Fiber}\n Sugar: ${snapshot.data.Sugar}\n Protein: ${snapshot.data.Protein}\n Potassium: ${snapshot.data.Potassium}\n Sugars: ${snapshot.data.Sugars}\n');
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
          )),
    ]));
  }
}

class DialogCamera extends StatelessWidget{
  DialogCamera(this.ctrl);
  final CameraController ctrl;
  @override
  Widget build(BuildContext context) {
    return new Container(
      // margin: new EdgeInsets.all(150.0),
      child: new CameraPreview(this.ctrl),
    );
  }
}