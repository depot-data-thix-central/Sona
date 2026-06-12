// lib/presentation/chat/voice/speed_control_widget.dart
import 'package:flutter/material.dart';

class SpeedControlWidget extends StatelessWidget {
  final double currentSpeed;
  final Function(double) onSpeedChanged;

  const SpeedControlWidget({
    super.key,
    required this.currentSpeed,
    required this.onSpeedChanged,
  });

  final List<Map<String, dynamic>> _speeds = const [
    {'label': '0.5x', 'value': 0.5},
    {'label': '0.75x', 'value': 0.75},
    {'label': '1x', 'value': 1.0},
    {'label': '1.25x', 'value': 1.25},
    {'label': '1.5x', 'value': 1.5},
    {'label': '1.75x', 'value': 1.75},
    {'label': '2x', 'value': 2.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const Text(
            'Vitesse de lecture',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _speeds.map((speed) {
              final isSelected = currentSpeed == speed['value'];
              return GestureDetector(
                onTap: () => onSpeedChanged(speed['value']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    speed['label'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
