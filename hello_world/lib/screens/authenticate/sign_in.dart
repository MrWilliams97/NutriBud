import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool rememberUser = false;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.red),
        ),
        Column(
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
                            _buildSignInTextWidget(),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            _buildEmailWidget(),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            Column(
                              children: <Widget>[
                                _buildPasswordWidget(),
                                _buildForgotPasswordWidget(),
                                _buildRememberMeWidget(),
                                _buildSignInButton(),
                                _buildSignUpWidget()
                              ],
                            ),
                          ]))
                    ]))
          ],
        )
      ]),
    );
  }

  Widget _buildSignInTextWidget() {
    return Text("Sign In",
        style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold));
  }

  Widget _buildForgotPasswordWidget() {
    return Container(
        alignment: Alignment.centerRight,
        child: FlatButton(
            onPressed: () => print("Forgot password pressed"),
            padding: EdgeInsets.only(right: 5.0),
            child: Text("Forgot password?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "OpenSans",
                    color: Colors.white))));
  }

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
            child: TextField(
                onChanged: (val) {
                  setState(() => email = val.trim());
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
          child: TextField(
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

  Widget _buildRememberMeWidget() {
    return Container(
        child: Row(
      children: <Widget>[
        Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: Checkbox(
                value: rememberUser,
                activeColor: Colors.white,
                checkColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    rememberUser = !rememberUser;
                  });
                })),
        Text("Remember Me",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold))
      ],
    ));
  }

  Widget _buildSignUpWidget() {
    return GestureDetector(
        onTap: () async {
          widget.toggleView();
        },
        child: Container(
            padding: EdgeInsets.only(top: 20.0),
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
              TextSpan(
                  text: "Sign Up",
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => widget.toggleView(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold))
            ]))));
  }

  Widget _buildSignInButton() {
    return Container(
        child: RaisedButton(
      child: Text("LOGIN",
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.red,
            fontFamily: "OpenSans",
          )),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.white,
      onPressed: () async {
        await _authService.signInEmailPassword(email, password);
      },
    ));
  }
}
