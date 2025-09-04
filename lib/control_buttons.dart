import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';

class ControlButtons extends StatefulWidget {
  final AnimationController buttonAnimationController;
  final Animation<double> buttonScaleAnimation;
  final Function(TimerProvider) onStartTimer;
  final VoidCallback onPauseTimer;
  final Function(TimerProvider) onResetTimer;

  const ControlButtons({
    Key? key,
    required this.buttonAnimationController,
    required this.buttonScaleAnimation,
    required this.onStartTimer,
    required this.onPauseTimer,
    required this.onResetTimer,
  }) : super(key: key);

  @override
  _ControlButtonsState createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  void _pauseTimer() {
    widget.onPauseTimer();
  }

  void _resetTimer(TimerProvider provider) {
    widget.onResetTimer(provider);
  }

  void _startTimer(TimerProvider provider) {
    widget.onStartTimer(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: widget.buttonScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.buttonScaleAnimation.value,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (provider.isRunning) {
                        _pauseTimer();
                      } else {
                        _startTimer(provider);
                      }
                      widget.buttonAnimationController.forward().then(
                        (_) => widget.buttonAnimationController.reverse(),
                      );
                    },
                    icon: Icon(
                      provider.isRunning ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(provider.isRunning ? 'Pause' : 'Start'),
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
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
            ),
          ],
        );
      },
    );
  }
}
