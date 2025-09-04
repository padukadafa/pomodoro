import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider with ChangeNotifier {
  int _workTime = 25 * 60; // 25 menit dalam detik
  int _breakTime = 5 * 60; // 5 menit dalam detik
  int _currentTime = 25 * 60;
  bool _isWorking = true;
  bool _isRunning = false;
  int _completedPomodoros = 0;
  bool _isDarkMode = false;

  TimerProvider() {
    _loadSettings();
  }

  int get currentTime => _currentTime;
  bool get isWorking => _isWorking;
  bool get isRunning => _isRunning;
  int get completedPomodoros => _completedPomodoros;
  bool get isDarkMode => _isDarkMode;
  int get workTime => _workTime ~/ 60;
  int get breakTime => _breakTime ~/ 60;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _workTime = (prefs.getInt('workTime') ?? 25) * 60;
    _breakTime = (prefs.getInt('breakTime') ?? 5) * 60;
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _completedPomodoros = prefs.getInt('completedPomodoros') ?? 0;
    _currentTime = _workTime;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('workTime', _workTime ~/ 60);
    await prefs.setInt('breakTime', _breakTime ~/ 60);
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setInt('completedPomodoros', _completedPomodoros);
  }

  void startTimer() {
    _isRunning = true;
    notifyListeners();
  }

  void pauseTimer() {
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _isRunning = false;
    _currentTime = _isWorking ? _workTime : _breakTime;
    notifyListeners();
  }

  void switchMode() {
    _isWorking = !_isWorking;
    if (!_isWorking) {
      _completedPomodoros++;
      _saveSettings(); // Save completed pomodoros
    }
    _currentTime = _isWorking ? _workTime : _breakTime;
    notifyListeners();
  }

  void decrementTime() {
    if (_currentTime > 0) {
      _currentTime--;
      notifyListeners();
    } else {
      switchMode();
    }
  }

  void setWorkTime(int minutes) {
    _workTime = minutes * 60;
    if (_isWorking) {
      _currentTime = _workTime;
    }
    _saveSettings();
    notifyListeners();
  }

  void setBreakTime(int minutes) {
    _breakTime = minutes * 60;
    if (!_isWorking) {
      _currentTime = _breakTime;
    }
    _saveSettings();
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveSettings();
    notifyListeners();
  }
}
