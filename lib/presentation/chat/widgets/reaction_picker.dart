// lib/presentation/chat/widgets/reaction_picker.dart
import 'package:flutter/material.dart';

class ReactionPicker extends StatelessWidget {
  final Function(String) onReactionSelected;

  const ReactionPicker({
    super.key,
    required this.onReactionSelected,
  });

  static const List<String> emojis = [
    '❤️',
    '👍',
    '😂',
    '😮',
    '😢',
    '😡',
    '🎉',
    '🙏',
    '🔥',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: emojis.map((emoji) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onReactionSelected(emoji);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ReactionBadge extends StatelessWidget {
  final Map<String, List<String>> reactions;
  final String messageId;
  final Function(String) onTap;

  const ReactionBadge({
    super.key,
    required this.reactions,
    required this.messageId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => onTap(messageId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Wrap(
          spacing: 4,
          children: reactions.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.key, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 2),
                Text(
                  '${entry.value.length}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
