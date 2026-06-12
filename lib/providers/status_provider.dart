// lib/providers/status_provider.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class StatusProvider extends ChangeNotifier {
  String _currentStatus = 'online';
  String? _customStatus;
  bool _isLoading = false;
  Timer? _statusTimer;
  
  StatusProvider() {
    _loadStatus();
    _startPeriodicUpdate();
  }
  
  // ============================================================
  // GETTERS
  // ============================================================
  
  String get currentStatus => _currentStatus;
  String? get customStatus => _customStatus;
  bool get isLoading => _isLoading;
  
  // ============================================================
  // MÉTHODES
  // ============================================================
  
  Future<void> _loadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentStatus = prefs.getString('user_status') ?? 'online';
      _customStatus = prefs.getString('custom_status');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading status: $e');
    }
  }
  
  void _startPeriodicUpdate() {
    _statusTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _updateLastSeen();
    });
  }
  
  Future<void> _updateLastSeen() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase.from('user_status').upsert({
          'user_id': user.id,
          'last_seen': DateTime.now().toIso8601String(),
          'status': _currentStatus,
          'custom_status': _customStatus,
        });
      }
    } catch (e) {
      debugPrint('Error updating last seen: $e');
    }
  }
  
  Future<void> updateStatus(String status) async {
    _currentStatus = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_status', status);
    await _updateLastSeen();
    notifyListeners();
  }
  
  Future<void> updateCustomStatus(String? status) async {
    _customStatus = status;
    final prefs = await SharedPreferences.getInstance();
    if (status != null) {
      await prefs.setString('custom_status', status);
    } else {
      await prefs.remove('custom_status');
    }
    await _updateLastSeen();
    notifyListeners();
  }
  
  String getDisplayStatus() {
    if (_customStatus != null && _customStatus!.isNotEmpty) {
      return _customStatus!;
    }
    switch (_currentStatus) {
      case 'online': return 'En ligne';
      case 'away': return 'Absent';
      case 'busy': return 'Occupé';
      default: return 'Hors ligne';
    }
  }
  
  Color getStatusColor() {
    switch (_currentStatus) {
      case 'online': return Colors.green;
      case 'away': return Colors.orange;
      case 'busy': return Colors.red;
      default: return Colors.grey;
    }
  }
  
  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }
}
