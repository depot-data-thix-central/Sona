// lib/presentation/chat/scheduled/schedule_picker_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/scheduled_provider.dart';

class SchedulePickerSheet extends StatefulWidget {
  final String conversationId;

  const SchedulePickerSheet({
    super.key,
    required this.conversationId,
  });

  @override
  State<SchedulePickerSheet> createState() => _SchedulePickerSheetState();
}

class _SchedulePickerSheetState extends State<SchedulePickerSheet> {
  final TextEditingController _messageController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isRecurring = false;
  String _recurringPattern = 'daily';
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _recurringOptions = [
    {'label': 'Une seule fois', 'value': 'once'},
    {'label': 'Quotidien', 'value': 'daily'},
    {'label': 'Hebdomadaire', 'value': 'weekly'},
    {'label': 'Mensuel', 'value': 'monthly'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null && mounted) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _scheduleMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un message')),
      );
      return;
    }

    final scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La date doit être dans le futur')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final scheduledProvider = Provider.of<ScheduledProvider>(context, listen: false);
    final success = await scheduledProvider.scheduleMessage(
      conversationId: widget.conversationId,
      content: message,
      scheduledAt: scheduledDateTime,
      isRecurring: _isRecurring && _recurringPattern != 'once',
      recurringPattern: _recurringPattern != 'once' ? _recurringPattern : null,
    );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message programmé pour ${_formatDate(scheduledDateTime)}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy à HH:mm').format(date);
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
            'Programmer un message',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Message
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Votre message...',
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: const TextStyle(fontSize: 13),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          // Date et heure
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Récurrence
          SwitchListTile(
            title: const Text('Répéter', style: TextStyle(fontSize: 12)),
            value: _isRecurring,
            onChanged: (value) => setState(() => _isRecurring = value),
            activeColor: const Color(0xFFD4AF37),
            contentPadding: EdgeInsets.zero,
          ),
          if (_isRecurring) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _recurringOptions.where((o) => o['value'] != 'once').map((option) {
                final isSelected = _recurringPattern == option['value'];
                return FilterChip(
                  label: Text(option['label'], style: const TextStyle(fontSize: 11)),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _recurringPattern = option['value']),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFFD4AF37).withOpacity(0.15),
                  checkmarkColor: const Color(0xFFD4AF37),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _scheduleMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF0B1B3D),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Programmer', style: TextStyle(fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
