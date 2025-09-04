import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';
import 'settings_screen.dart';

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

  String _formatTime(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: provider.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: provider.isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: provider.isDarkMode ? Colors.white : Colors.black,
              size: 28,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  provider.toggleDarkMode();
                  _buttonAnimationController.forward().then(
                    (_) => _buttonAnimationController.reverse(),
                  );
                },
              ),
              Hero(
                tag: 'settings',
                child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SettingsScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: provider.isDarkMode
                    ? [Colors.black, Colors.grey[900]!, Colors.black]
                    : [Colors.white, Colors.grey[50]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: Offset(0, -1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOut,
                          ),
                        ),
                    child: FadeTransition(
                      opacity: _animation,
                      child: Text(
                        'Pomodoros Completed: ${provider.completedPomodoros}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: provider.isDarkMode
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      width: 250,
                      height: 250,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value:
                                provider.currentTime /
                                (provider.isWorking
                                    ? provider.workTime * 60
                                    : provider.breakTime * 60),
                            strokeWidth: 6,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              provider.isWorking
                                  ? Colors.redAccent
                                  : Colors.greenAccent,
                            ),
                            backgroundColor: provider.isDarkMode
                                ? Colors.white24
                                : Colors.black12,
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: provider.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (provider.isWorking
                                              ? Colors.redAccent
                                              : Colors.greenAccent)
                                          .withOpacity(0.2),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FadeTransition(
                                  opacity: _animation,
                                  child: Text(
                                    provider.isWorking
                                        ? 'Work Time'
                                        : 'Break Time',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: provider.isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                ScaleTransition(
                                  scale: Tween<double>(begin: 0.9, end: 1.0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: _animationController,
                                          curve: Curves.bounceOut,
                                        ),
                                      ),
                                  child: Text(
                                    _formatTime(provider.currentTime),
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w300,
                                      color: provider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _buttonScaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buttonScaleAnimation.value,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (provider.isRunning) {
                                  _pauseTimer();
                                } else {
                                  _startTimer(provider);
                                }
                                _buttonAnimationController.forward().then(
                                  (_) => _buttonAnimationController.reverse(),
                                );
                              },
                              icon: Icon(
                                provider.isRunning
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              label: Text(
                                provider.isRunning ? 'Pause' : 'Start',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: provider.isWorking
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () => _resetTimer(provider),
                        icon: Icon(Icons.refresh),
                        label: Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: provider.isDarkMode
                              ? Colors.grey[700]
                              : Colors.grey[300],
                          foregroundColor: provider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
