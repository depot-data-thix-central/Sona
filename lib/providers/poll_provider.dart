// lib/providers/poll_provider.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/poll_service.dart';
import '../models/poll_models.dart';

class PollProvider extends ChangeNotifier {
  late PollService _service;
  
  List<Poll> _polls = [];
  bool _isLoading = false;
  
  PollProvider() {
    _service = PollService(Supabase.instance.client);
  }
  
  // ============================================================
  // GETTERS
  // ============================================================
  
  List<Poll> get polls => _polls;
  bool get isLoading => _isLoading;
  
  // ============================================================
  // MÉTHODES
  // ============================================================
  
  Future<void> loadPolls(String conversationId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _polls = await _service.getPolls(conversationId);
    } catch (e) {
      debugPrint('Error loading polls: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createPoll({
    required String conversationId,
    required String question,
    required List<String> options,
    bool isAnonymous = false,
    bool isMultiple = false,
    DateTime? expiresAt,
  }) async {
    try {
      await _service.createPoll(
        conversationId: conversationId,
        question: question,
        options: options,
        isAnonymous: isAnonymous,
        isMultiple: isMultiple,
        expiresAt: expiresAt,
      );
      await loadPolls(conversationId);
      return true;
    } catch (e) {
      debugPrint('Error creating poll: $e');
      return false;
    }
  }
  
  Future<bool> vote({
    required String pollId,
    int? optionIndex,
    List<int>? optionIndices,
  }) async {
    try {
      await _service.vote(
        pollId: pollId,
        optionIndex: optionIndex,
        optionIndices: optionIndices,
      );
      return true;
    } catch (e) {
      debugPrint('Error voting: $e');
      return false;
    }
  }
}
