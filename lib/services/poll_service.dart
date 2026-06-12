// lib/services/poll_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/poll_models.dart';

class PollService {
  final SupabaseClient _supabase;

  PollService(this._supabase);

  String get currentUserId => _supabase.auth.currentUser?.id ?? '';

  Future<List<Poll>> getPolls(String conversationId) async {
    try {
      final response = await _supabase
          .from('polls')
          .select('*')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false);

      final polls = <Poll>[];
      for (var e in response as List) {
        final userVote = await _getUserVote(e['id']);
        polls.add(Poll.fromJson(e, userVote));
      }
      return polls;
    } catch (e) {
      debugPrint('Error getting polls: $e');
      return [];
    }
  }

  Future<int?> _getUserVote(String pollId) async {
    try {
      final response = await _supabase
          .from('poll_votes')
          .select('option_index')
          .eq('poll_id', pollId)
          .eq('user_id', currentUserId)
          .maybeSingle();
      return response?['option_index'] as int?;
    } catch (e) {
      return null;
    }
  }

  Future<void> createPoll({
    required String conversationId,
    required String question,
    required List<String> options,
    bool isAnonymous = false,
    bool isMultiple = false,
    DateTime? expiresAt,
  }) async {
    await _supabase.from('polls').insert({
      'conversation_id': conversationId,
      'question': question,
      'options': options,
      'is_anonymous': isAnonymous,
      'is_multiple': isMultiple,
      'expires_at': expiresAt?.toIso8601String(),
      'created_by': currentUserId,
    });
  }

  Future<void> vote({
    required String pollId,
    int? optionIndex,
    List<int>? optionIndices,
  }) async {
    if (optionIndices != null) {
      for (var index in optionIndices) {
        await _supabase.from('poll_votes').insert({
          'poll_id': pollId,
          'user_id': currentUserId,
          'option_index': index,
        });
      }
    } else if (optionIndex != null) {
      await _supabase.from('poll_votes').insert({
        'poll_id': pollId,
        'user_id': currentUserId,
        'option_index': optionIndex,
      });
    }
  }

  Future<Map<int, int>> getPollResults(String pollId) async {
    final votes = await _supabase
        .from('poll_votes')
        .select('option_index')
        .eq('poll_id', pollId);

    final results = <int, int>{};
    for (var v in votes as List) {
      final index = v['option_index'] as int;
      results[index] = (results[index] ?? 0) + 1;
    }
    return results;
  }

  Future<void> closePoll(String pollId) async {
    await _supabase
        .from('polls')
        .update({'expires_at': DateTime.now().toIso8601String()})
        .eq('id', pollId);
  }
}
