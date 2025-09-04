import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';
import 'particle_background.dart';
import 'timer_display.dart';
import 'control_buttons.dart';

class MainContent extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final AnimationController buttonAnimationController;
  final Animation<double> buttonScaleAnimation;
  final Function(TimerProvider) onStartTimer;
  final VoidCallback onPauseTimer;
  final Function(TimerProvider) onResetTimer;

  const MainContent({
    Key? key,
    required this.animationController,
    required this.animation,
    required this.buttonAnimationController,
    required this.buttonScaleAnimation,
    required this.onStartTimer,
    required this.onPauseTimer,
    required this.onResetTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: provider.isDarkMode
                  ? [Colors.black, Colors.grey[900]!, Colors.black]
                  : [Colors.white, Colors.grey[50]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              ParticleBackground(),
              Center(
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
                              parent: animationController,
                              curve: Curves.easeOut,
                            ),
                          ),
                      child: FadeTransition(
                        opacity: animation,
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
                    TimerDisplay(
                      animationController: animationController,
                      animation: animation,
                    ),
                    SizedBox(height: 40),
                    ControlButtons(
                      buttonAnimationController: buttonAnimationController,
                      buttonScaleAnimation: buttonScaleAnimation,
                      onStartTimer: onStartTimer,
                      onPauseTimer: onPauseTimer,
                      onResetTimer: onResetTimer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
