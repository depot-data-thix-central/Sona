// lib/models/location_models.dart
class LiveLocation {
  final String id;
  final String conversationId;
  final String userId;
  final String userName;
  final double latitude;
  final double longitude;
  final DateTime expiresAt;
  final String? address;
  final bool isActive;
  final DateTime sharedAt;

  LiveLocation({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    required this.expiresAt,
    this.address,
    required this.isActive,
    required this.sharedAt,
  });

  factory LiveLocation.fromJson(Map<String, dynamic> json) {
    final userData = json['users'] as Map<String, dynamic>?;
    return LiveLocation(
      id: json['id'],
      conversationId: json['conversation_id'],
      userId: json['user_id'],
      userName: userData?['display_name'] as String? ?? 'Utilisateur',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      expiresAt: DateTime.parse(json['expires_at']),
      address: json['address'],
      isActive: json['is_active'] ?? true,
      sharedAt: DateTime.parse(json['shared_at']),
    );
  }

  bool get isExpired => expiresAt.isBefore(DateTime.now());
}
