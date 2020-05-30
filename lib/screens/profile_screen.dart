import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImageProvider avatar = AssetImage('assets/images/avatarPlaceholder.png');

  @override
  void initState() {
    super.initState();
    loadAvatar();
  }

  void loadAvatar() async {
    var url = 'https://www.room923.cf/app/users/' +
        PrefService.getString('username') +
        '/assets/avatar.jpg';
    Response response;
    try {
      // print('request');
      response = await http.get(url);
      // print('OK');
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            avatar = NetworkImage(url);
          });
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 260,
              // color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Color(0x22000000),
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(65.0),
                          ),
                        ),
                        child: GestureDetector(
                          child: CircleAvatar(
                            radius: 65.0,
                            backgroundColor: Colors.white,
                            backgroundImage: avatar,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 18,
                        ),
                        child: Text(
                          PrefService.getString('username'),
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xff000000),
                            fontFamily: 'Baloo Thambi 2',
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 5),
                      //   child: Text(
                      //     PrefService.getString('email') == null
                      //         ? ''
                      //         : PrefService.getString('email'),
                      //     style: TextStyle(
                      //       color: Color(0xff898989),
                      //       fontSize: 20,
                      //       letterSpacing: 1.3,
                      //     ),
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      color: Color(0xffdddddd),
                    ),
                    child: PhysicalModel(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 60,
                            color: Colors.transparent,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  child: Container(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Class',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: 'Comic Neue',
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '16',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontFamily: 'Comic Neue',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 60,
                            color: Colors.transparent,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  child: Container(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Grade',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: 'Comic Neue',
                                            ),
                                          ),
                                          Text(
                                            '11',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontFamily: 'Comic Neue',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        PrefService.setBool('logedin', false);
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => route == null);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
