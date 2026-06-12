// lib/models/scheduled_models.dart
class ScheduledMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime scheduledAt;
  final bool isRecurring;
  final String? recurringPattern;
  final String status; // 'pending', 'sent', 'cancelled'

  ScheduledMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.scheduledAt,
    required this.isRecurring,
    this.recurringPattern,
    required this.status,
  });

  factory ScheduledMessage.fromJson(Map<String, dynamic> json) {
    return ScheduledMessage(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      scheduledAt: DateTime.parse(json['scheduled_at']),
      isRecurring: json['is_recurring'] ?? false,
      recurringPattern: json['recurring_pattern'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'scheduled_at': scheduledAt.toIso8601String(),
      'is_recurring': isRecurring,
      'recurring_pattern': recurringPattern,
      'status': status,
    };
  }
}
