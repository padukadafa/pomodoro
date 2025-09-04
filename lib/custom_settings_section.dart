import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';
import 'stepper_section.dart';

class CustomSettingsSection extends StatefulWidget {
  final int workTimeValue;
  final int breakTimeValue;
  final Function(int) onWorkTimeChanged;
  final Function(int) onBreakTimeChanged;

  const CustomSettingsSection({
    Key? key,
    required this.workTimeValue,
    required this.breakTimeValue,
    required this.onWorkTimeChanged,
    required this.onBreakTimeChanged,
  }) : super(key: key);

  @override
  _CustomSettingsSectionState createState() => _CustomSettingsSectionState();
}

class _CustomSettingsSectionState extends State<CustomSettingsSection> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerProvider>(context);
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: provider.isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: provider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 20),
          StepperSection(
            title: 'Work Time',
            value: widget.workTimeValue,
            color: Colors.redAccent,
            onDecrease: widget.workTimeValue > 1
                ? () => widget.onWorkTimeChanged(widget.workTimeValue - 1)
                : null,
            onIncrease: widget.workTimeValue < 60
                ? () => widget.onWorkTimeChanged(widget.workTimeValue + 1)
                : null,
          ),
          SizedBox(height: 30),
          StepperSection(
            title: 'Break Time',
            value: widget.breakTimeValue,
            color: Colors.greenAccent,
            onDecrease: widget.breakTimeValue > 1
                ? () => widget.onBreakTimeChanged(widget.breakTimeValue - 1)
                : null,
            onIncrease: widget.breakTimeValue < 30
                ? () => widget.onBreakTimeChanged(widget.breakTimeValue + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
