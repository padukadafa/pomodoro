import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';
import 'pomodoro_app_bar.dart';
import 'main_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Auto start fade in
    _animationController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _startTimer(TimerProvider provider) {
    provider.startTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      provider.decrementTime();
      if (provider.currentTime == 0) {
        _showCompletionSnackBar();
        _animationController.forward(from: 0);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    Provider.of<TimerProvider>(context, listen: false).pauseTimer();
  }

  void _resetTimer(TimerProvider provider) {
    _timer?.cancel();
    provider.resetTimer();
  }

  void _showCompletionSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Time\'s up! Switch to ${Provider.of<TimerProvider>(context, listen: false).isWorking ? 'Break' : 'Work'}',
        ),
        duration: Duration(seconds: 3),
        backgroundColor:
            Provider.of<TimerProvider>(context, listen: false).isWorking
            ? Colors.redAccent
            : Colors.greenAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: provider.isDarkMode ? Colors.black : Colors.white,
          appBar: PomodoroAppBar(
            buttonAnimationController: _buttonAnimationController,
          ),
          body: MainContent(
            animationController: _animationController,
            animation: _animation,
            buttonAnimationController: _buttonAnimationController,
            buttonScaleAnimation: _buttonScaleAnimation,
            onStartTimer: _startTimer,
            onPauseTimer: _pauseTimer,
            onResetTimer: _resetTimer,
          ),
        );
      },
    );
  }
}
