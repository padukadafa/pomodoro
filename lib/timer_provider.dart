import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  int _workTime = 25 * 60; // 25 menit dalam detik
  int _breakTime = 5 * 60; // 5 menit dalam detik
  int _currentTime = 25 * 60;
  bool _isWorking = true;
  bool _isRunning = false;
  int _completedPomodoros = 0;
  bool _isDarkMode = false;

  int get currentTime => _currentTime;
  bool get isWorking => _isWorking;
  bool get isRunning => _isRunning;
  int get completedPomodoros => _completedPomodoros;
  bool get isDarkMode => _isDarkMode;
  int get workTime => _workTime ~/ 60;
  int get breakTime => _breakTime ~/ 60;

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
    notifyListeners();
  }

  void setBreakTime(int minutes) {
    _breakTime = minutes * 60;
    if (!_isWorking) {
      _currentTime = _breakTime;
    }
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
