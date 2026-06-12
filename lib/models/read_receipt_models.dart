// lib/models/read_receipt_models.dart
class ReadReceiptUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isDelivered;
  final bool isRead;
  final DateTime date;

  ReadReceiptUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.isDelivered,
    required this.isRead,
    required this.date,
  });
}

class PriorityMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final bool requireReadReceipt;
  final DateTime createdAt;

  PriorityMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.requireReadReceipt,
    required this.createdAt,
  });

  factory PriorityMessage.fromJson(Map<String, dynamic> json) {
    return PriorityMessage(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      requireReadReceipt: json['require_read_receipt'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
