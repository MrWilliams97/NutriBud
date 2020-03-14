import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:hello_world/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  UserSettings currentUser = new UserSettings(isMale: true);
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  DateTime dateOfBirth;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime(2022),
    );
    if (d != null)
      setState(() {
        widget.currentUser.dateOfBirth = d;
      });
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B5103),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    if (user == null) {
      return Text('');
    }

    var userId = user.uid;

    if (userId == null) {
      return Text('');
    }
    widget.currentUser.userId = userId;
    dateOfBirth = widget.currentUser.dateOfBirth;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.9],
              colors: [
                Colors.red,
                Colors.pink,
              ],
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    height: 600.0,
                    child: PageView(
                      //
                      physics: new NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                    child: Image(
                                  image: ExactAssetImage(
                                      'assets/foodimages/somefood.png'),
                                )),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(" It's time to put\nyour health first",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("NutriBud is committed to\n helping you achieve your\n                  goals!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20))
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                    child: Image(
                                  height: 200,
                                  image:
                                      ExactAssetImage('assets/images/flex.png'),
                                )),
                                Text("Set User Profile Settings",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("First Name: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                        width: 200.0,
                                        height: 40.0,
                                        child: TextField(
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter(
                                                RegExp("[a-zA-Z]"))
                                          ],
                                          onChanged: (var value) {
                                            setState(() {
                                              widget.currentUser.firstName = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.white54),
                                              hintText: "Insert First Name"),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Last Name: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                        width: 200.0,
                                        height: 40.0,
                                        child: TextField(
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter(
                                                RegExp("[a-zA-Z]"))
                                          ],
                                          onChanged: (var value) {
                                            setState(() {
                                              widget.currentUser.lastName = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.white54),
                                              hintText: "Insert Last Name"),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Username: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                        width: 200.0,
                                        height: 40.0,
                                        child: TextField(
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          onChanged: (var value) {
                                            setState(() {
                                              widget.currentUser.userName = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.white54),
                                              hintText: "Insert Username"),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Date of Birth: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      color: Colors.white,
                                      tooltip: 'Tap to select Birth Date',
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                    ),
                                    dateOfBirth == null
                                        ? Text(
                                            'Select Birth Date',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : Text(
                                            new DateFormat.yMMMMd("en_US")
                                                .format(widget
                                                    .currentUser.dateOfBirth),
                                            style:
                                                TextStyle(color: Colors.white)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Gender: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    Text("M",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold)),
                                    Switch(
                                      value: !widget.currentUser.isMale,
                                      onChanged: (value) {
                                        setState(() {
                                          widget.currentUser.isMale =
                                              !widget.currentUser.isMale;
                                        });
                                      },
                                      activeTrackColor: Colors.pinkAccent,
                                      activeColor: Colors.pink,
                                    ),
                                    Text("F",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Height (cm): ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                        width: 200.0,
                                        height: 40.0,
                                        child: TextField(
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (var value) {
                                            setState(() {
                                              widget.currentUser.height = double.parse(value);
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.white54),
                                              hintText: "Insert Height"),
                                        )),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                    child: Image(
                                  image: ExactAssetImage(
                                      'assets/images/fitness.png'),
                                )),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Text("Okay! You're all set!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Text("Now let's get started!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                      ],
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator()),
                (_currentPage == 1 && widget.currentUser.firstName != null && widget.currentUser.firstName.isNotEmpty
                                   && widget.currentUser.lastName != null &&widget.currentUser.lastName.isNotEmpty
                                   && widget.currentUser.height != null
                                   && widget.currentUser.userName != null && widget.currentUser.userName.isNotEmpty
                                   && widget.currentUser.dateOfBirth != null) || (_currentPage != _numPages - 1 && _currentPage != 1)
                    ? Expanded(
                        child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: FlatButton(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Next",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold)),
                                    Icon(Icons.arrow_forward,
                                        color: Colors.white),
                                    SizedBox(
                                      height: 150,
                                    )
                                  ]),
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                            )),
                      )
                    : Text(''),
              ],
            ),
          )),
      bottomSheet: _currentPage == _numPages - 1
          ? GestureDetector(
            onTap: () {
              DatabaseService().updateUserSettings(widget.currentUser);
            },
            child: Container(
              height: 80.0,
              width: double.infinity,
              color: Colors.white,
              child: Container(
                  child: Column(children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Text('Get Started',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold))
              ])))
          )
          : Text(''),
    );
  }
}
