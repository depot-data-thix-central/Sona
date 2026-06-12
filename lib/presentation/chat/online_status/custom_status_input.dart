// lib/presentation/chat/online_status/custom_status_input.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomStatusInput extends StatefulWidget {
  const CustomStatusInput({super.key});

  @override
  State<CustomStatusInput> createState() => _CustomStatusInputState();
}

class _CustomStatusInputState extends State<CustomStatusInput> {
  final TextEditingController _controller = TextEditingController();
  String _currentStatus = '';
  bool _showEmojiPicker = false;
  String _selectedEmoji = '😊';

  final List<String> _recentStatuses = [
    'En réunion',
    'En déplacement',
    'En vacances',
    'Télétravail',
    'Ne pas déranger',
    'Disponible',
  ];

  final List<String> _emojis = [
    '😊', '😴', '💼', '🏠', '✈️', '🏖️', '📱', '💻', '🎧', '📞', '⚡', '🎯', '💪', '🤝', '🙏', '❤️'
  ];

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentStatus = prefs.getString('custom_status') ?? '';
      _controller.text = _currentStatus;
    });
  }

  Future<void> _saveStatus() async {
    final status = _controller.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_status', status);
    setState(() => _currentStatus = status);
    
    if (mounted) {
      Navigator.pop(context, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statut mis à jour'), duration: const Duration(seconds: 1)),
      );
    }
  }

  void _clearStatus() {
    _controller.clear();
    _saveStatus();
  }

  void _addEmoji(String emoji) {
    setState(() {
      _controller.text += emoji;
      _showEmojiPicker = false;
    });
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
          'Statut personnalisé',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: _saveStatus,
            child: const Text('Enregistrer', style: TextStyle(fontSize: 12, color: Color(0xFFD4AF37))),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Current status display
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_selectedEmoji, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Que faites-vous ?',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 14),
                        maxLength: 30,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions, size: 20, color: Color(0xFFD4AF37)),
                      onPressed: () => setState(() => _showEmojiPicker = !_showEmojiPicker),
                    ),
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                        onPressed: _clearStatus,
                      ),
                  ],
                ),
                if (_showEmojiPicker)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _emojis.map((emoji) {
                        return GestureDetector(
                          onTap: () => _addEmoji(emoji),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(emoji, style: const TextStyle(fontSize: 24)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
          
          // Recent statuses
          if (_recentStatuses.isNotEmpty)
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
                    'Récents',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recentStatuses.map((status) {
                      return GestureDetector(
                        onTap: () {
                          _controller.text = status;
                          _saveStatus();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(status, style: const TextStyle(fontSize: 11)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          
          // Current status preview
          if (_controller.text.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.visibility, size: 16, color: Color(0xFFD4AF37)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Aperçu',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_selectedEmoji} ${_controller.text}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
