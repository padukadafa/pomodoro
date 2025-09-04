import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_provider.dart';

class PresetButtons extends StatelessWidget {
  final Function(int, int) onPresetSelected;

  const PresetButtons({Key? key, required this.onPresetSelected})
    : super(key: key);

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
            'Quick Presets',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: provider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetButton(
                icon: Icons.timer,
                label: 'Classic\n25/5',
                color: Colors.redAccent,
                onPressed: () => onPresetSelected(25, 5),
              ),
              _buildPresetButton(
                icon: Icons.flash_on,
                label: 'Short\n15/3',
                color: Colors.greenAccent,
                onPressed: () => onPresetSelected(15, 3),
              ),
              _buildPresetButton(
                icon: Icons.access_time,
                label: 'Long\n50/10',
                color: Colors.blueAccent,
                onPressed: () => onPresetSelected(50, 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
    );
  }
}
