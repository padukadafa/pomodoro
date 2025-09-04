import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';

class SaveButton extends StatelessWidget {
  final int workTimeValue;
  final int breakTimeValue;

  const SaveButton({
    Key? key,
    required this.workTimeValue,
    required this.breakTimeValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerProvider>(context);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          provider.setWorkTime(workTimeValue);
          provider.setBreakTime(breakTimeValue);
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.save),
            SizedBox(width: 10),
            Text('Save Settings'),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: provider.isWorking
              ? Colors.redAccent
              : Colors.greenAccent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
