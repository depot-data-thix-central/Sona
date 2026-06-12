// lib/services/location_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/location_models.dart';

class LocationService {
  final SupabaseClient _supabase;

  LocationService(this._supabase);

  String get currentUserId => _supabase.auth.currentUser?.id ?? '';

  Future<List<LiveLocation>> getActiveLocations() async {
    try {
      final response = await _supabase
          .from('live_locations')
          .select('*, users:user_id(display_name)')
          .eq('is_active', true)
          .gt('expires_at', DateTime.now().toIso8601String());

      return (response as List).map((e) => LiveLocation.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting locations: $e');
      return [];
    }
  }

  Future<LiveLocation?> getLocationById(String id) async {
    try {
      final response = await _supabase
          .from('live_locations')
          .select('*, users:user_id(display_name)')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return LiveLocation.fromJson(response);
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Future<void> createLocation({
    required String conversationId,
    required double latitude,
    required double longitude,
    DateTime? expiresAt,
    String? address,
  }) async {
    await _supabase.from('live_locations').insert({
      'conversation_id': conversationId,
      'user_id': currentUserId,
      'latitude': latitude,
      'longitude': longitude,
      'expires_at': expiresAt?.toIso8601String(),
      'address': address,
      'is_active': true,
      'shared_at': DateTime.now().toIso8601String(),
    });
  }
}
