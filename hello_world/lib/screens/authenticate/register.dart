import 'package:flutter/material.dart';
import 'package:hello_world/services/auth.dart';
import 'package:flutter/gestures.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.red),
        ),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildLogoWidget(),
              Expanded(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(children: <Widget>[
                              _buildRegisterTextWidget(),
                              Padding(padding: EdgeInsets.only(top: 20.0)),
                              _buildEmailWidget(),
                              Padding(padding: EdgeInsets.only(top: 20.0)),
                              Column(
                                children: <Widget>[
                                  _buildPasswordWidget(),
                                  _buildRegisterButton(),
                                  _buildSignInWidget()
                                ],
                              ),
                            ]))
                      ]))
            ],
          ),
        )
      ]),
    );
  }

  // Builds Register Text Widget
  Widget _buildRegisterTextWidget() {
    return Text("Register",
        style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold));
  }

  // Builds the Logo at the top of the page
  Widget _buildLogoWidget() {
    return Expanded(
      flex: 1,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  backgroundImage: ExactAssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.white,
                  radius: 120.0)
            ]),
      ),
    );
  }

  //Builds Email Widget. Contains validation for email address.
  Widget _buildEmailWidget() {
    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.only(left: 12.5),
                child: Text("Email",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.bold)))),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.0),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 14.0)],
            ),
            height: 60.0,
            child: TextFormField(
                onChanged: (val) {
                  setState(() => email = val.trim());
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please enter an email";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.red, fontSize: 22.0),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Email",
                    hintStyle: TextStyle(color: Colors.redAccent),
                    prefixIcon: Icon(Icons.email, color: Colors.redAccent))))
      ],
    );
  }

  // Builds Password Enter Widget. Contains validation for password length.
  Widget _buildPasswordWidget() {
    return Column(children: <Widget>[
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 12.5),
              child: Text("Password",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.bold)))),
      Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.0),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 14.0)],
          ),
          height: 60.0,
          child: TextFormField(
              validator: (val) {
                if (val.length < 6) {
                  return "The password length must be greater than 5 characters!";
                } else {
                  return null;
                }
              },
              onChanged: (val) {
                setState(() => password = val);
              },
              obscureText: true,
              style: TextStyle(color: Colors.red, fontSize: 22.0),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Password",
                  hintStyle: TextStyle(color: Colors.red),
                  prefixIcon: Icon(Icons.lock, color: Colors.red))))
    ]);
  }

  //Builds the Register Button. Checks validation for Email and Password based on rules defined for them.
  Widget _buildRegisterButton() {
    return Container(
        child: RaisedButton(
      child: Text("REGISTER",
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.red,
            fontFamily: "OpenSans",
          )),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.white,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          dynamic result =
              await _authService.registerEmailPassword(email, password);
          if (result == null) {
            setState(() => error = "Please provide a valid email address");
          }
        }
      },
    ));
  }

  // Builds Text that brings you back to Sign In page
  Widget _buildSignInWidget(){
    return Container(
            padding: EdgeInsets.only(top: 20.0),
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
              TextSpan(
                  text: "Sign In",
                  recognizer: new TapGestureRecognizer()..onTap = () => widget.toggleView(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold))
            ])));
  }
}
