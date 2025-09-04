import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';

class TimerDisplay extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const TimerDisplay({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  String _formatTime(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, provider, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
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
                    provider.isWorking ? Colors.redAccent : Colors.greenAccent,
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
                    color: provider.isDarkMode ? Colors.black : Colors.white,
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
                        opacity: animation,
                        child: Text(
                          provider.isWorking ? 'Work Time' : 'Break Time',
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
                        scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animationController,
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
        );
      },
    );
  }
}
