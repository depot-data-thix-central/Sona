// lib/presentation/chat/widgets/pinned_message.dart
import 'package:flutter/material.dart';
import '../../models/chat_models.dart';

class PinnedMessage extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onTap;

  const PinnedMessage({
    super.key,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFFD4AF37), width: 3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.push_pin, size: 14, color: Color(0xFFD4AF37)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message épinglé',
                  style: TextStyle(fontSize: 9, color: Color(0xFFD4AF37)),
                ),
                Text(
                  message.content,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.arrow_downward,
              size: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
