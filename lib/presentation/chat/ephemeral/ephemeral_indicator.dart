// lib/presentation/chat/ephemeral/ephemeral_indicator.dart
import 'package:flutter/material.dart';

class EphemeralIndicator extends StatelessWidget {
  final int durationSeconds;
  final bool isActive;

  const EphemeralIndicator({
    super.key,
    required this.durationSeconds,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer_outlined,
            size: 10,
            color: Color(0xFFD4AF37),
          ),
          const SizedBox(width: 2),
          Text(
            _formatDuration(durationSeconds),
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${seconds ~/ 60}m';
    return '${seconds ~/ 3600}h';
  }
}
