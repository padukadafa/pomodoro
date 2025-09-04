import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({Key? key}) : super(key: key);

  @override
  _ParticleBackgroundState createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _wasRunning = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<TimerProvider>(context);
    final isRunning = provider.isRunning;

    if (isRunning != _wasRunning) {
      if (isRunning) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      _wasRunning = isRunning;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, provider, child) {
        return AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: provider.isRunning || _animationController.isAnimating
                  ? CircularParticle(
                      awayRadius: 80,
                      numberOfParticles: 50,
                      speedOfParticles: 1,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      onTapAnimation: true,
                      particleColor: provider.isWorking
                          ? Colors.redAccent.withOpacity(0.5)
                          : Colors.greenAccent.withOpacity(0.5),
                      awayAnimationDuration: Duration(milliseconds: 600),
                      maxParticleSize: 8,
                      isRandSize: true,
                      isRandomColor: false,
                      randColorList: [
                        provider.isWorking
                            ? Colors.redAccent
                            : Colors.greenAccent,
                      ],
                      awayAnimationCurve: Curves.easeInOutBack,
                      enableHover: true,
                      hoverColor: Colors.white,
                      hoverRadius: 90,
                    )
                  : SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
