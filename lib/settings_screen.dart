import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';
import 'preset_buttons.dart';
import 'custom_settings_section.dart';
import 'save_button.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _workTimeValue = 25;
  int _breakTimeValue = 5;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TimerProvider>(context, listen: false);
    _workTimeValue = provider.workTime;
    _breakTimeValue = provider.breakTime;
  }

  void _setPreset(int work, int breakTime) {
    setState(() {
      _workTimeValue = work;
      _breakTimeValue = breakTime;
    });
  }

  void _updateWorkTime(int value) {
    setState(() {
      _workTimeValue = value;
    });
  }

  void _updateBreakTime(int value) {
    setState(() {
      _breakTimeValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerProvider>(context);
    return Scaffold(
      backgroundColor: provider.isDarkMode
          ? Colors.grey[900]
          : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: provider.isDarkMode
            ? Colors.grey[900]
            : Colors.grey[100],
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            color: provider.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(
          color: provider.isDarkMode ? Colors.white : Colors.black,
        ),
        leading: Hero(
          tag: 'settings',
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: provider.isDarkMode
                ? [Colors.grey[900]!, Colors.black, Colors.grey[900]!]
                : [Colors.grey[100]!, Colors.white, Colors.grey[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customize Timer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: provider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 30),
              PresetButtons(onPresetSelected: _setPreset),
              SizedBox(height: 30),
              CustomSettingsSection(
                workTimeValue: _workTimeValue,
                breakTimeValue: _breakTimeValue,
                onWorkTimeChanged: _updateWorkTime,
                onBreakTimeChanged: _updateBreakTime,
              ),
              SizedBox(height: 40),
              SaveButton(
                workTimeValue: _workTimeValue,
                breakTimeValue: _breakTimeValue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
