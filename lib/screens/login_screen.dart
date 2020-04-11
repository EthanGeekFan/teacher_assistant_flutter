import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:teacher_assistant/main.dart';
import 'package:teacher_assistant/widgets/FadeAnimation.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void _onLogin(ctxt, username, password) async {
    Map<String, dynamic> data = {
      'username': username,
      'password': password,
    };
    final response = await http.post(
      'http://192.168.101.99/app/api/login/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      var re = json.decode(response.body);
      if (re['code'] == '60001' &&
          re['message'] == 'Login successful' &&
          re['token'] != '') {
        PrefService.setBool('logedin', true);
        PrefService.setString('username', username);
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => MyHomePage()),
            (route) => route == null);
      } else {
        PrefService.setBool('logedin', false);
        Scaffold.of(ctxt).showSnackBar(SnackBar(
          content: Text(re['message']),
        ));
      }
    } else {
      // throw Exception('Network request error!');
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    _usernameController.text = PrefService.getString('username') != null &&
            PrefService.getString('username') != ''
        ? PrefService.getString('username')
        : '';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Builder(
          builder: (cont) => Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Background.png'),
                          fit: BoxFit.cover)),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                        width: 300,
                        height: 200,
                        child: FadeAnimation(
                          1,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/decoration-1.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: FadeAnimation(
                          1.3,
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Pacifico",
                                  // letterSpacing: 1.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 0.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        1.6,
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .4),
                                blurRadius: 20.0,
                                offset: Offset(0, 10),
                              )
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[100]),
                                    ),
                                  ),
                                  child: TextFormField(
                                    // initialValue: PrefService.getString(
                                    //                 'username') !=
                                    //             null &&
                                    //         PrefService.getString('username') !=
                                    //             ''
                                    //     ? 'y'
                                    //     : 'x',
                                    controller: _usernameController,
                                    validator: (value) {
                                      if (value.length < 3) {
                                        return 'Username must contain at least 3 characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (value.length < 8) {
                                        return "Password must contain at least 8 characters";
                                      }
                                    },
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _onLogin(
                              cont,
                              _usernameController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: FadeAnimation(
                          1.9,
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  // Color.fromRGBO(173, 158, 255, 1),
                                  // Color.fromRGBO(173, 168, 255, .6),
                                  Color(0xdd7655FF),
                                  Color(0x997655FF),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .4),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot');
                        },
                        child: FadeAnimation(
                          2.2,
                          Text(
                            "Forgot your password?",
                            style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: FadeAnimation(
                          2.2,
                          Text(
                            "Your first time?",
                            style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
