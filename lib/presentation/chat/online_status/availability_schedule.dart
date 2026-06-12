// lib/presentation/chat/online_status/availability_schedule.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AvailabilitySchedule extends StatefulWidget {
  const AvailabilitySchedule({super.key});

  @override
  State<AvailabilitySchedule> createState() => _AvailabilityScheduleState();
}

class _AvailabilityScheduleState extends State<AvailabilitySchedule> {
  bool _enableSchedule = false;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);
  List<int> _selectedDays = [1, 2, 3, 4, 5]; // Lundi à Vendredi
  String _statusWhenOffline = 'offline';

  final List<String> _weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  final List<Map<String, dynamic>> _offlineStatuses = [
    {'name': 'Hors ligne', 'value': 'offline'},
    {'name': 'Absent', 'value': 'away'},
    {'name': 'Occupé', 'value': 'busy'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableSchedule = prefs.getBool('availability_schedule_enabled') ?? false;
      _selectedDays = prefs.getStringList('availability_days')?.map(int.parse).toList() ?? [1, 2, 3, 4, 5];
      _statusWhenOffline = prefs.getString('status_when_offline') ?? 'offline';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('availability_schedule_enabled', _enableSchedule);
    await prefs.setStringList('availability_days', _selectedDays.map((e) => e.toString()).toList());
    await prefs.setString('status_when_offline', _statusWhenOffline);
  }

  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (time != null && mounted) {
      setState(() => _startTime = time);
      await _saveSettings();
    }
  }

  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (time != null && mounted) {
      setState(() => _endTime = time);
      await _saveSettings();
    }
  }

  void _toggleDay(int index) {
    setState(() {
      if (_selectedDays.contains(index)) {
        _selectedDays.remove(index);
      } else {
        _selectedDays.add(index);
      }
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Planification de disponibilité',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Enregistrer', style: TextStyle(fontSize: 12, color: Color(0xFFD4AF37))),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Enable schedule
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: const Text('Activer la planification', style: TextStyle(fontSize: 13)),
              subtitle: const Text('Changer automatiquement de statut selon l\'horaire', style: TextStyle(fontSize: 10)),
              value: _enableSchedule,
              onChanged: (value) {
                setState(() => _enableSchedule = value);
                _saveSettings();
              },
              activeColor: const Color(0xFFD4AF37),
            ),
          ),
          
          if (_enableSchedule) ...[
            // Heures
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Horaires',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectStartTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: Color(0xFFD4AF37)),
                                const SizedBox(width: 8),
                                Text(
                                  _startTime.format(context),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('-', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectEndTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: Color(0xFFD4AF37)),
                                const SizedBox(width: 8),
                                Text(
                                  _endTime.format(context),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Jours de la semaine
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jours actifs',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final isSelected = _selectedDays.contains(index);
                      return GestureDetector(
                        onTap: () => _toggleDay(index),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _weekDays[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.grey[600],
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            
            // Statut hors horaires
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statut hors horaires',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ..._offlineStatuses.map((status) {
                    final isSelected = _statusWhenOffline == status['value'];
                    return RadioListTile<String>(
                      value: status['value'],
                      groupValue: _statusWhenOffline,
                      onChanged: (value) {
                        setState(() => _statusWhenOffline = value!);
                        _saveSettings();
                      },
                      title: Text(status['name'], style: const TextStyle(fontSize: 12)),
                      activeColor: const Color(0xFFD4AF37),
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
