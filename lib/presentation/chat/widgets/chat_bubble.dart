// lib/presentation/chat/widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import '../../models/chat_models.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onLongPress;
  final VoidCallback? onReactionTap;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onLongPress,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isFromMe;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 60 : 0,
          right: isMe ? 0 : 60,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe && message.senderAvatar != null)
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(message.senderAvatar!),
                  ),
                const SizedBox(width: 4),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFD4AF37) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.formattedTime,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                  if (isMe && message.isRead) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, size: 10, color: Colors.green),
                  ] else if (isMe && message.isDelivered) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done, size: 10, color: Colors.grey),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case 'text':
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 13,
            color: message.isFromMe ? Colors.white : Colors.black87,
          ),
        );
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            message.mediaUrl!,
            width: 180,
            fit: BoxFit.cover,
          ),
        );
      case 'audio':
        return Row(
          children: [
            Icon(
              Icons.play_circle,
              size: 28,
              color: const Color(0xFFD4AF37),
            ),
            const SizedBox(width: 8),
            Text(
              '${message.mediaDuration ?? 0} s',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        );
      case 'file':
        return Container(
          width: 180,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.insert_drive_file, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.fileName ?? 'Fichier',
                      style: const TextStyle(fontSize: 11),
                      maxLines: 1,
                    ),
                    Text(
                      '${(message.fileSize ?? 0) / 1024} KB',
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
