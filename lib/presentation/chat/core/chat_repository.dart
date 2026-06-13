// lib/presentation/chat/core/chat_repository.dart
// [PARTIE] Repository : communication via Edge Functions Supabase avec token

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/auth/token_service.dart';
import 'chat_models.dart';
import 'chat_constants.dart';
import 'chat_utils.dart';

class ChatRepository {
  // À remplacer par l'URL réelle de ton projet Supabase
  final String _baseUrl = 'https://ton-projet.supabase.co/functions/v1';
  
  // Pour les appels Realtime (non modifiés car natifs à Supabase)
  final SupabaseClient _supabase = Supabase.instance.client;

  // Helper pour les requêtes HTTP authentifiées avec le token
  Future<http.Response> _authenticatedRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final token = await TokenService.getToken();
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    
    switch (method) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      case 'PUT':
        return await http.put(uri, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        throw Exception('Méthode non supportée');
    }
  }

  // Récupérer les conversations
  Future<List<Conversation>> fetchConversations(String userId) async {
    final response = await _authenticatedRequest('conversations?user_id=$userId');
    if (response.statusCode != 200) {
      throw Exception('Erreur fetchConversations: ${response.body}');
    }
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Conversation.fromJson(json)).toList();
  }

  // Récupérer les messages (pagination)
  Future<List<Message>> fetchMessages(String conversationId, {int limit = 50}) async {
    final response = await _authenticatedRequest(
      'messages?conversation_id=$conversationId&limit=$limit'
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur fetchMessages: ${response.body}');
    }
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Message.fromJson(json)).toList();
  }

  // Envoyer un message (générique + éphémère/confidentiel)
  Future<Message> sendMessage(Message message) async {
    final response = await _authenticatedRequest(
      'send_message',
      method: 'POST',
      body: message.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur sendMessage: ${response.body}');
    }
    final Map<String, dynamic> json = jsonDecode(response.body);
    return Message.fromJson(json);
  }

  // Vérifier le code d'un message confidentiel
  Future<bool> verifyConfidentialCode(String messageId, String enteredCode) async {
    final response = await _authenticatedRequest(
      'verify_confidential',
      method: 'POST',
      body: {
        'message_id': messageId,
        'code': enteredCode,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur verifyConfidentialCode: ${response.body}');
    }
    final Map<String, dynamic> json = jsonDecode(response.body);
    return json['valid'] as bool;
  }

  // Marquer un message comme lu
  Future<void> markAsRead(String messageId, String userId) async {
    final response = await _authenticatedRequest(
      'mark_read',
      method: 'POST',
      body: {
        'message_id': messageId,
        'user_id': userId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur markAsRead: ${response.body}');
    }
  }

  // Ajouter une réaction
  Future<void> addReaction(String messageId, String reaction, String userId) async {
    final response = await _authenticatedRequest(
      'add_reaction',
      method: 'POST',
      body: {
        'message_id': messageId,
        'reaction': reaction,
        'user_id': userId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur addReaction: ${response.body}');
    }
  }

  // Supprimer un message (soft delete global ou local)
  Future<void> deleteMessage(String messageId, String userId, {bool forEveryone = false}) async {
    final response = await _authenticatedRequest(
      'delete_message',
      method: 'POST',
      body: {
        'message_id': messageId,
        'user_id': userId,
        'for_everyone': forEveryone,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur deleteMessage: ${response.body}');
    }
  }

  // Mettre à jour la présence (en ligne/hors ligne)
  Future<void> updatePresence(String userId, String status) async {
    final response = await _authenticatedRequest(
      'update_presence',
      method: 'POST',
      body: {
        'user_id': userId,
        'status': status,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur updatePresence: ${response.body}');
    }
  }

  // Stream en temps réel (reste sur SupabaseClient car Realtime est optimisé)
  Stream<Message> listenForNewMessages(String conversationId) {
    return _supabase
        .from(ChatConstants.tableMessages)
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('sent_at', ascending: false)
        .limit(1)
        .map((event) => Message.fromJson(event.first));
  }

  // Récupérer les stories
  Future<List<Story>> fetchStories(String userId) async {
    final response = await _authenticatedRequest('stories?user_id=$userId');
    if (response.statusCode != 200) {
      throw Exception('Erreur fetchStories: ${response.body}');
    }
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Story.fromJson(json)).toList();
  }

  // Récupérer les statistiques du chat
  Future<ChatStats> fetchChatStats(String userId) async {
    final response = await _authenticatedRequest('chat_stats?user_id=$userId');
    if (response.statusCode != 200) {
      throw Exception('Erreur fetchChatStats: ${response.body}');
    }
    final Map<String, dynamic> json = jsonDecode(response.body);
    return ChatStats(
      onlineCount: json['online_count'] ?? 0,
      newMessagesCount: json['new_messages_count'] ?? 0,
      activeMeetingsCount: json['active_meetings_count'] ?? 0,
      securityAlertsCount: json['security_alerts_count'] ?? 0,
    );
  }

  // Méthode utilitaire pour la biométrie (inchangée)
  Future<bool> _authenticateWithBiometrics() async {
    // Implémentez avec le package local_auth
    return true;
  }
}
