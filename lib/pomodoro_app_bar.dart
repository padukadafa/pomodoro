import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';
import 'settings_screen.dart';

class PomodoroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AnimationController buttonAnimationController;

  const PomodoroAppBar({Key? key, required this.buttonAnimationController})
    : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, provider, child) {
        return AppBar(
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
                buttonAnimationController.forward().then(
                  (_) => buttonAnimationController.reverse(),
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
        );
      },
    );
  }
}
