import 'dart:ffi';

import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  TimeOfDay timeSaver;

  @override
  void initState() {
    super.initState();
    timeSaver = new TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    print('hello');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add an Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name of the appointment",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'From: ' + timeSaver.format(context),
                    ),
                    FlatButton(
                      child: Text('Edit'),
                      onPressed: () {
                        _selectTime(context);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
    return Container(
      height: 0,
      width: 0,
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());
    if (picked != null) {
      print(picked.format(context));
      setState(() {
        timeSaver = picked;
      });
    }
  }
}
