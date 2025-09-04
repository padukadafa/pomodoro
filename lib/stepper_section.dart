import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';

class StepperSection extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  const StepperSection({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    this.onDecrease,
    this.onIncrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerProvider>(context);
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
