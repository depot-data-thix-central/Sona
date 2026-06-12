// lib/providers/group_provider.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/group_service.dart';
import '../models/group_models.dart';

class GroupProvider extends ChangeNotifier {
  late GroupService _service;
  
  List<Group> _groups = [];
  List<GroupMember> _members = [];
  Group? _currentGroup;
  bool _isLoading = false;
  
  GroupProvider() {
    _service = GroupService(Supabase.instance.client);
  }
  
  // ============================================================
  // GETTERS
  // ============================================================
  
  List<Group> get groups => _groups;
  List<GroupMember> get members => _members;
  Group? get currentGroup => _currentGroup;
  bool get isLoading => _isLoading;
  
  // ============================================================
  // MÉTHODES
  // ============================================================
  
  Future<void> loadGroups() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _groups = await _service.getGroups();
    } catch (e) {
      debugPrint('Error loading groups: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadGroupMembers(String groupId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _members = await _service.getGroupMembers(groupId);
      _currentGroup = _groups.firstWhere((g) => g.id == groupId);
    } catch (e) {
      debugPrint('Error loading group members: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createGroup(String name, String? avatarUrl) async {
    try {
      final group = await _service.createGroup(name, avatarUrl);
      await loadGroups();
      return true;
    } catch (e) {
      debugPrint('Error creating group: $e');
      return false;
    }
  }
  
  Future<bool> updateGroupRole(String groupId, String userId, String role) async {
    try {
      await _service.updateRole(groupId, userId, role);
      await loadGroupMembers(groupId);
      return true;
    } catch (e) {
      debugPrint('Error updating role: $e');
      return false;
    }
  }
  
  Future<bool> removeMember(String groupId, String userId) async {
    try {
      await _service.removeMember(groupId, userId);
      await loadGroupMembers(groupId);
      return true;
    } catch (e) {
      debugPrint('Error removing member: $e');
      return false;
    }
  }
  
  Future<bool> addMembers(String groupId, List<String> userIds) async {
    try {
      await _service.addMembers(groupId, userIds);
      await loadGroupMembers(groupId);
      return true;
    } catch (e) {
      debugPrint('Error adding members: $e');
      return false;
    }
  }
  
  Future<bool> updateGroupSettings(String groupId, Map<String, dynamic> settings) async {
    try {
      await _service.updateSettings(groupId, settings);
      await loadGroups();
      return true;
    } catch (e) {
      debugPrint('Error updating settings: $e');
      return false;
    }
  }
  
  Future<bool> leaveGroup(String groupId) async {
    try {
      await _service.leaveGroup(groupId);
      await loadGroups();
      return true;
    } catch (e) {
      debugPrint('Error leaving group: $e');
      return false;
    }
  }
  
  Future<bool> deleteGroup(String groupId) async {
    try {
      await _service.deleteGroup(groupId);
      await loadGroups();
      return true;
    } catch (e) {
      debugPrint('Error deleting group: $e');
      return false;
    }
  }
}
