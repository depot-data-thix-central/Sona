// lib/presentation/chat/online_status/status_selector_sheet.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../../providers/status_provider.dart';

class StatusSelectorSheet extends StatefulWidget {
  const StatusSelectorSheet({super.key});

  @override
  State<StatusSelectorSheet> createState() => _StatusSelectorSheetState();
}

class _StatusSelectorSheetState extends State<StatusSelectorSheet> {
  String _selectedStatus = 'online';
  
  final List<Map<String, dynamic>> _statuses = [
    {'name': 'En ligne', 'value': 'online', 'icon': Icons.circle, 'color': Colors.green, 'desc': 'Visible par tous'},
    {'name': 'Absent', 'value': 'away', 'icon': Icons.access_time, 'color': Colors.orange, 'desc': 'Réponse différée'},
    {'name': 'Occupé', 'value': 'busy', 'icon': Icons.do_not_disturb, 'color': Colors.red, 'desc': 'Ne pas déranger'},
    {'name': 'Hors ligne', 'value': 'offline', 'icon': Icons.circle_outlined, 'color': Colors.grey, 'desc': 'Invisible'},
  ];

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedStatus = prefs.getString('user_status') ?? 'online';
    });
  }

  Future<void> _saveStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_status', status);
    setState(() => _selectedStatus = status);
    
    // Notifier le provider
    final provider = Provider.of<StatusProvider>(context, listen: false);
    await provider.updateStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mon statut',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ..._statuses.map((status) {
            final isSelected = _selectedStatus == status['value'];
            return GestureDetector(
              onTap: () {
                _saveStatus(status['value']);
                Navigator.pop(context, status['value']);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFD4AF37).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: status['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status['name'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          Text(
                            status['desc'],
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, size: 18, color: Color(0xFFD4AF37)),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
