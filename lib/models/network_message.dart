class NetworkMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime? createdAt;
  final Map<String, dynamic> raw;

  const NetworkMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.createdAt,
    this.raw = const {},
  });

  factory NetworkMessage.fromJson(Map<String, dynamic> json) {
    return NetworkMessage(
      id: (json['id'] ?? '').toString(),
      conversationId: (json['conversation_id'] ?? '').toString(),
      senderId: (json['sender_id'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      createdAt: json['created_at'] is String
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
    });
}
