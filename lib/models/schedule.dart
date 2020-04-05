import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Schedule {
  String message;
  String code;
  List<String> schedule;
  int weekday;
  String modDate;

  List<String> scheduleTime;

  Schedule({
    this.message,
    this.code,
    this.weekday,
    this.schedule,
    this.modDate,
    this.scheduleTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      message: json['message'],
      code: json['Code'],
      weekday: json['data']['weekday'],
      schedule: List.from(json['data']['schedule']),
      modDate: json['data']['mod_date'],
      scheduleTime: json['data']['scheduleTime'],
    );
  }
}

Future<Schedule> fetchSchedule(int weekday) async {
  var week = weekday + 1;
  if (week > 7) {
    week = 1;
  }
  final response = await http.get(
      'https://www.room923.cf/app/api/getSchedule/?weekday=' + week.toString());

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Schedule.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load schedule');
  }
}

class ModSchedule {
  String message;
  String code;
  dynamic data;

  ModSchedule({this.message, this.code, this.data});

  factory ModSchedule.fromJson(Map<String, dynamic> json) {
    return ModSchedule(
      message: json['message'],
      code: json['Code'],
      data: json['post'],
    );
  }
}

Future<ModSchedule> modSchedule(int weekday, List<String> schedule) async {
  var week = weekday + 1;
  if (week > 7) {
    week = 1;
  }

  String scheduleString = "";

  for (var i = 0; i < schedule.length; i++) {
    scheduleString += schedule[i];
    if (i != schedule.length - 1) {
      scheduleString += ',';
    }
  }

  final response = await http.post(
    'https://www.room923.cf/app/api/modSchedule/json.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'weekday': week,
      'schedule': scheduleString,
    }),
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return ModSchedule.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to modify schedule');
  }
}

List<Future<Schedule>> futureSchedules;
List<Future<Schedule>> specificFutureSchedules;
