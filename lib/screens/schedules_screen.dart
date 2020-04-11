import 'dart:async';
import 'package:preferences/preferences.dart';
import 'package:teacher_assistant/models/schedule.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:teacher_assistant/functions/switch_days.dart';
import 'package:teacher_assistant/functions/time_machine.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;

class SchedulesScreen extends StatefulWidget {
  SchedulesScreen({Key key, this.dateSwitcher}) : super(key: key);

  Switcher dateSwitcher;

  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  int selectedIndex = 0;
  final List<String> categories = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  Switcher dateSwitcher;
  // List<Future<Schedule>> futureSchedules;
  BuildContext bigContext;

  @override
  void initState() {
    super.initState();
    if (widget.dateSwitcher == null) {
      dateSwitcher = new Switcher(lastIndex: 0, currentIndex: 0);
    } else {
      dateSwitcher = widget.dateSwitcher;
    }
    futureSchedules = new List();
    for (var i = 1; i < 8; i++) {
      futureSchedules.add(fetchSchedule(i));
    }
  }

  @override
  void setState(void Function() fn) {
    super.setState(fn);
    Future<Schedule> newerFutureSchedule = fetchSchedule(selectedIndex);
    newerFutureSchedule.then((schedule) {
      futureSchedules[selectedIndex].then((schedule) {
        var olderSchedule = schedule.schedule;
        if (!listEquals(olderSchedule, schedule.schedule)) {
          futureSchedules[selectedIndex] = newerFutureSchedule;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Schedules',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30.0,
            // color: Colors.black,
            onPressed: () {
              addNewScheduleItem(context);
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 80.0,
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        dateSwitcher.switchTo(index);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 13.0,
                        vertical: 20,
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: index == selectedIndex
                              ? Colors.white
                              : Colors.white60,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // color: bgScheme.accents[selectedIndex],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: PhysicalModel(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            if (PrefService.getBool('logedin') == true) {
                              return FutureBuilder<Schedule>(
                                future: futureSchedules[selectedIndex],
                                builder: (context, snapshot) {
                                  bigContext = context;
                                  if (snapshot.hasData) {
                                    if (snapshot.data.message == 'Success' &&
                                        snapshot.data.code == '66666') {
                                      var schedule = snapshot.data.schedule;
                                      var scheduleTime =
                                          snapshot.data.scheduleTime;
                                      return Container(
                                        child: RefreshIndicator(
                                          onRefresh: () {
                                            setState(() {});
                                            return futureSchedules[
                                                selectedIndex];
                                          },
                                          child: ReorderableListView(
                                            children: <Widget>[
                                              for (var index = 0;
                                                  index <
                                                      snapshot
                                                          .data.schedule.length;
                                                  index++)
                                                Dismissible(
                                                  key: ValueKey(index),
                                                  onDismissed: (direction) {
                                                    var removedName;
                                                    var removedTime;
                                                    removedName = schedule
                                                        .removeAt(index);
                                                    if (scheduleTime != null) {
                                                      removedTime = scheduleTime
                                                          .removeAt(index);
                                                    }
                                                    setState(() {});
                                                    refreshData(
                                                        index: selectedIndex,
                                                        schedule: schedule);
                                                    Scaffold.of(bigContext)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                        'Deleted ' +
                                                            removedName,
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          // fontSize: 20,
                                                        ),
                                                      ),
                                                      duration:
                                                          Duration(seconds: 2),
                                                      backgroundColor:
                                                          Colors.white,
                                                      elevation: 1,
                                                      action: SnackBarAction(
                                                        label: 'Undo',
                                                        onPressed: () {
                                                          schedule.insert(index,
                                                              removedName);
                                                          if (removedTime !=
                                                              null) {
                                                            scheduleTime.insert(
                                                                index,
                                                                removedTime);
                                                          }
                                                          setState(() {});
                                                          refreshData(
                                                              index:
                                                                  selectedIndex,
                                                              schedule:
                                                                  schedule);
                                                        },
                                                      ),
                                                    ));
                                                  },
                                                  background: Container(
                                                    color: Colors.red,
                                                    // 这里使用 ListTile 因为可以快速设置左右两端的Icon
                                                    child: Center(
                                                      child: ListTile(
                                                        leading: Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  secondaryBackground:
                                                      Container(
                                                    color: Colors.green,
                                                    // 这里使用 ListTile 因为可以快速设置左右两端的Icon
                                                    child: Center(
                                                      child: ListTile(
                                                        trailing: Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      // color: Colors.yellow,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 10.0,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            radius: 35.0,
                                                            // backgroundColor: bgcolor,
                                                            backgroundColor:
                                                                Colors.blue,
                                                            foregroundColor:
                                                                Colors.white,
                                                            child: Text(
                                                              schedule[index]
                                                                  [0],
                                                              style: TextStyle(
                                                                fontSize: 30.0,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 0.0,
                                                            ),
                                                            child: Text(
                                                              scheduleTime ==
                                                                      null
                                                                  ? index <
                                                                          schedule_time
                                                                              .length
                                                                      ? schedule_time[
                                                                          index]
                                                                      : 'Unknown'
                                                                  : scheduleTime[
                                                                              index] ==
                                                                          ""
                                                                      ? index < schedule_time.length
                                                                          ? schedule_time[
                                                                              index]
                                                                          : 'Unknown'
                                                                      : scheduleTime[
                                                                          index],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25.0,
                                                                letterSpacing:
                                                                    1.0,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ],
                                            onReorder:
                                                (int oldIndex, int newIndex) {
                                              if (oldIndex < newIndex) {
                                                newIndex -= 1;
                                              }
                                              var child =
                                                  schedule.removeAt(oldIndex);
                                              schedule.insert(newIndex, child);
                                              if (scheduleTime != null) {
                                                var item = scheduleTime
                                                    .removeAt(oldIndex);
                                                scheduleTime.insert(
                                                    newIndex, item);
                                              }
                                              setState(() {});
                                              refreshData(
                                                  index: selectedIndex,
                                                  schedule: schedule);
                                            },
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("An API Error Occured: " +
                                            snapshot.data.message),
                                      );
                                    }
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text("A Network Error Occured"),
                                    );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 30.0,
                                      ),
                                      child: Container(
                                        child: Text(
                                          'Oops',
                                          style: TextStyle(
                                            fontSize: 70,
                                            color: Colors.black,
                                            fontFamily: 'Sarina',
                                            // letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'You are not logged in.',
                                      style: TextStyle(
                                        fontSize: 30.0,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/',
                                            (route) => route == null);
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 23.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void addNewScheduleItem(BuildContext ctx) {
    final _formKey = GlobalKey<FormState>();
    final format = DateFormat("HH:mm");
    TextEditingController _nameController = new TextEditingController();
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext context) {
        TimeOfDay timeStart = new TimeOfDay.now();
        TimeOfDay timeEnd = TimeOfDay.fromDateTime(DateTime.now().add(Duration(
          minutes: 40,
        )));
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Add an Appointment'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "Name of the appointment",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "The name cannot be empty";
                        }
                        return null;
                      },
                      onChanged: (value) => _formKey.currentState.validate(),
                      onEditingComplete: () {
                        _formKey.currentState.validate();
                      },
                    ),
                    DateTimeField(
                      readOnly: true,
                      initialValue: DateTimeField.convert(timeStart),
                      decoration: InputDecoration(
                        hintText: "It starts at...",
                        labelText: "From",
                      ),
                      format: format,
                      validator: (value) {
                        if (value == null) {
                          return "This field is required";
                        }
                        return null;
                      },
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return time == null
                            ? currentValue
                            : DateTimeField.convert(time);
                      },
                      onChanged: (value) {
                        setState(() {
                          timeStart = TimeOfDay.fromDateTime(value);
                        });
                      },
                    ),
                    DateTimeField(
                      readOnly: true,
                      initialValue: DateTimeField.convert(timeEnd),
                      decoration: InputDecoration(
                        hintText: "It ends at...",
                        labelText: "To",
                      ),
                      format: format,
                      validator: (value) {
                        TimeOfDay time = TimeOfDay.fromDateTime(value);
                        if (value == null) {
                          return "This field is required";
                        }
                        if (toDouble(time) < toDouble(timeStart)) {
                          return "It has to be later than the start time";
                        }
                        return null;
                      },
                      onShowPicker: (ctx, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );

                        return time == null
                            ? currentValue
                            : DateTimeField.convert(time);
                      },
                      onChanged: (value) {
                        setState(() {
                          timeEnd = TimeOfDay.fromDateTime(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  if (_formKey.currentState.validate()) {
                    popBack(
                        context,
                        new Item(
                            name: _nameController.text,
                            timeStart: timeStart,
                            timeEnd: timeEnd));
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
      },
    );
  }

  void popBack(BuildContext contxt, Item newItem) {
    setState(() {
      futureSchedules[selectedIndex].then((oldSchedule) {
        oldSchedule.schedule.add(newItem.name);
        if (oldSchedule.scheduleTime == null) {
          print('initializing time schedule');
          DateTime now = DateTime.now();
          oldSchedule.scheduleTime =
              List.generate(oldSchedule.schedule.length - 1, (int index) {
            return "";
          });
        }
        oldSchedule.scheduleTime.add(DateFormat("HH:mm").format(new DateTime(
              now.year,
              now.month,
              now.day,
              newItem.timeStart.hour,
              newItem.timeStart.minute,
            )) +
            ' - ' +
            DateFormat("HH:mm").format(new DateTime(
              now.year,
              now.month,
              now.day,
              newItem.timeEnd.hour,
              newItem.timeEnd.minute,
            )));
        refreshData(index: selectedIndex, schedule: oldSchedule.schedule);
      });
    });
    // http.post(url)
  }

  void refreshData(
      {int index,
      List<String> schedule,
      String successMes = 'Update Successful',
      String failMes = 'Update Failed'}) {
    var status = modSchedule(
      index,
      schedule,
    );
    status.then((response) {
      String message;
      if (response.code == "66666" && response.message == "Success") {
        message = successMes;
      } else {
        message = failMes;

        Scaffold.of(bigContext).showSnackBar(SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              // fontSize: 20,
            ),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.white,
          elevation: 0.5,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ));
      }
    });
  }
}

class Item {
  String name;
  TimeOfDay timeStart;
  TimeOfDay timeEnd;

  Item({this.name, this.timeStart, this.timeEnd});
}

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
