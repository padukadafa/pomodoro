import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';

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
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: provider.isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Presets',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: provider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPresetButton(
                          icon: Icons.timer,
                          label: 'Classic\n25/5',
                          color: Colors.redAccent,
                          onPressed: () => _setPreset(25, 5),
                        ),
                        _buildPresetButton(
                          icon: Icons.flash_on,
                          label: 'Short\n15/3',
                          color: Colors.greenAccent,
                          onPressed: () => _setPreset(15, 3),
                        ),
                        _buildPresetButton(
                          icon: Icons.access_time,
                          label: 'Long\n50/10',
                          color: Colors.blueAccent,
                          onPressed: () => _setPreset(50, 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: provider.isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: provider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildStepperSection(
                      title: 'Work Time',
                      value: _workTimeValue,
                      color: Colors.redAccent,
                      onDecrease: _workTimeValue > 1
                          ? () => setState(() => _workTimeValue--)
                          : null,
                      onIncrease: _workTimeValue < 60
                          ? () => setState(() => _workTimeValue++)
                          : null,
                      provider: provider,
                    ),
                    SizedBox(height: 30),
                    _buildStepperSection(
                      title: 'Break Time',
                      value: _breakTimeValue,
                      color: Colors.greenAccent,
                      onDecrease: _breakTimeValue > 1
                          ? () => setState(() => _breakTimeValue--)
                          : null,
                      onIncrease: _breakTimeValue < 30
                          ? () => setState(() => _breakTimeValue++)
                          : null,
                      provider: provider,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    provider.setWorkTime(_workTimeValue);
                    provider.setBreakTime(_breakTimeValue);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 10),
                      Text('Save Settings'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: provider.isWorking
                        ? Colors.redAccent
                        : Colors.greenAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
    );
  }

  Widget _buildStepperSection({
    required String title,
    required int value,
    required Color color,
    required VoidCallback? onDecrease,
    required VoidCallback? onIncrease,
    required TimerProvider provider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: provider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle, color: color, size: 32),
              onPressed: onDecrease,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: provider.isDarkMode ? Colors.white24 : Colors.black12,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
                color: provider.isDarkMode ? Colors.grey[700] : Colors.grey[50],
              ),
              child: Text(
                '$value min',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: provider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: color, size: 32),
              onPressed: onIncrease,
            ),
          ],
        ),
      ],
    );
  }
}
