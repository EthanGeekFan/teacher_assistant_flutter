import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teacher_assistant/widgets/FadeAnimation.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool usernameValidIndicator = true;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  void _onSignup(ctxt, email, username, password) async {
    Map<String, dynamic> data = {
      'email': email,
      'username': username,
      'password': password,
    };
    try {
      final response = await http.post(
        'https://www.room923.cf/app/api/login/signup.php',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var re = json.decode(response.body);
        if (re['code'] == '60001' && re['message'] == 'Signup successful') {
          // PrefService.setBool('logedin', true);
          // PrefService.setString('username', username);
          Navigator.pushNamedAndRemoveUntil(
              context, '/', (route) => route == null);
        } else {
          print(re);
          // PrefService.setBool('logedin', false);
          Scaffold.of(ctxt).showSnackBar(SnackBar(
            content: Text(re['message']),
          ));
        }
      } else {
        // throw Exception('Network request error!');
        Scaffold.of(ctxt).showSnackBar(SnackBar(
          content: Text('Request error: ' + response.statusCode.toString()),
        ));
      }
    } catch (e) {
      Scaffold.of(ctxt).showSnackBar(SnackBar(
        content: Text('Internet Connection Error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (cont) => SingleChildScrollView(
          child: Container(
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
                                "Sign Up",
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
                      Positioned(
                        left: 5,
                        top: 30,
                        child: FadeAnimation(
                          0.5,
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
                                    controller: _emailController,
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'Invalid Email';
                                      else
                                        return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
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
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[100]),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _usernameController,
                                    validator: (value) {
                                      if (value.length < 3) {
                                        return 'Username must contain at least 3 characters';
                                      } else if (value.split(' ').length > 1) {
                                        return 'Username must not contain blank space';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (username) async {
                                      Map<String, dynamic> data = {
                                        'username': username,
                                      };
                                      final response = await http.post(
                                        'http://192.168.101.99/app/api/login/usrValidate.php',
                                        headers: <String, String>{
                                          'Content-Type':
                                              'application/json; charset=UTF-8',
                                        },
                                        body: jsonEncode(data),
                                      );

                                      if (response.statusCode == 200) {
                                        var res = json.decode(response.body);
                                        if (res['valid'] == true) {
                                          setState(() {
                                            usernameValidIndicator = true;
                                          });
                                          return;
                                        } else if (res['valid'] == false) {
                                          setState(() {
                                            usernameValidIndicator = false;
                                          });
                                        } else {
                                          setState(() {
                                            usernameValidIndicator = false;
                                          });
                                        }
                                      } else {
                                        // throw Exception('Network request error!');
                                        Scaffold.of(cont).showSnackBar(SnackBar(
                                          content: Text('Network error: ' +
                                              response.statusCode.toString()),
                                        ));
                                      }
                                    },
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: usernameValidIndicator
                                          ? Colors.green
                                          : Colors.red,
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
                                      } else {
                                        return null;
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
                            _onSignup(
                              cont,
                              _emailController.text,
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
                                "Sign Up",
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
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => route == null);
                        },
                        child: FadeAnimation(
                          2.2,
                          Text(
                            "Already have an account?",
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
