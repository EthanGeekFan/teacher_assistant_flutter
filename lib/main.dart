import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:teacher_assistant/screens/home_screen.dart';
import 'package:teacher_assistant/screens/login_screen.dart';
import 'package:teacher_assistant/screens/menu_screen.dart';
import 'package:teacher_assistant/screens/profile_screen.dart';
import 'package:teacher_assistant/screens/schedules_screen.dart';
import 'package:teacher_assistant/screens/search_bar.dart';
import 'package:teacher_assistant/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // primaryColor: Color(0xff3399FF),
          // primaryColor: Colors.white,
          // accentColor: Color(0xFF3399FF),
          // primaryColorBrightness: Brightness.dark,
          ),
      darkTheme: ThemeData.dark(),
      // home: HomeScreen(),
      // home: MyHomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/search': (context) => SearchScreen(),
        '/settings': (context) => SettingsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/schedules': (context) => SchedulesScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  final double maxSlide = 300.0;
  final double minDragStartEdge = 50.0;
  final double maxDragStartEdge = 250.0;
  bool _canBeDragged;
  AnimationController animationController;
  bool ipcRefresh = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
  }

  void toggle() =>
      animationController.isDismissed ? {} : animationController.reverse();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragOpenFromRight = animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragOpenFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      // close();
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      // onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          double slide = maxSlide * animationController.value;
          double scale = 1 - (animationController.value * 0.3);
          return Stack(
            children: <Widget>[
              MenuScreen(superAnimationController: animationController),
              Transform(
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale),
                alignment: Alignment.centerLeft,
                child:
                    HomeScreen(superAnimationController: animationController),
              ),
            ],
          );
        },
      ),
    );
  }
}
