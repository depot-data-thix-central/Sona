// lib/models/archive_models.dart
class ArchivedConversation {
  final String id;
  final String name;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  ArchivedConversation({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });
}

class ArchivedMedia {
  final String id;
  final String type; // 'image', 'video'
  final String? url;
  final String? thumbnailUrl;
  final DateTime archivedAt;

  ArchivedMedia({
    required this.id,
    required this.type,
    this.url,
    this.thumbnailUrl,
    required this.archivedAt,
  });
}

class ArchivedFile {
  final String id;
  final String name;
  final String type; // 'pdf', 'doc', 'xls', 'ppt', 'other'
  final int size; // bytes
  final DateTime archivedAt;

  ArchivedFile({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.archivedAt,
  });
}

class ArchivedLink {
  final String id;
  final String title;
  final String url;
  final String? previewImage;
  final DateTime archivedAt;

  ArchivedLink({
    required this.id,
    required this.title,
    required this.url,
    this.previewImage,
    required this.archivedAt,
  });
}
