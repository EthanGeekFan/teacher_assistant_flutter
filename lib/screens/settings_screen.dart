import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PreferencePage([
            PreferenceTitle('General'),
            DropdownPreference(
              'Theme',
              'theme',
              defaultVal: 'Light',
              values: ['Light', 'Dark'],
            ),
            DropdownPreference(
              'Language',
              'language',
              defaultVal: 'English',
              values: ['English', '简体中文'],
            ),
            PreferenceTitle('Personalization'),
            RadioPreference(
              'Light Theme',
              'light',
              'ui_theme',
              isDefault: true,
            ),
            RadioPreference(
              'Dark Theme',
              'dark',
              'ui_theme',
            ),
          ]),
          Positioned(
            bottom: 40,
            child: FlatButton(
              child: Text(
                'Clear Preferences',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () {
                PrefService.clear();
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  void clearData() {
    PrefService.clear();
  }
}
