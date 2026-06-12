// lib/presentation/chat/online_status/status_presets.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusPresets extends StatefulWidget {
  const StatusPresets({super.key});

  @override
  State<StatusPresets> createState() => _StatusPresetsState();
}

class _StatusPresetsState extends State<StatusPresets> {
  List<Map<String, dynamic>> _presets = [];
  final TextEditingController _newPresetController = TextEditingController();

  final List<Map<String, dynamic>> _defaultPresets = [
    {'text': 'En réunion', 'emoji': '💼', 'color': '#FF6B6B'},
    {'text': 'En déplacement', 'emoji': '✈️', 'color': '#4ECDC4'},
    {'text': 'En vacances', 'emoji': '🏖️', 'color': '#FFE66D'},
    {'text': 'Télétravail', 'emoji': '🏠', 'color': '#95E77E'},
    {'text': 'Ne pas déranger', 'emoji': '🔕', 'color': '#FF9F43'},
    {'text': 'Disponible', 'emoji': '✅', 'color': '#10AC84'},
    {'text': 'En pause', 'emoji': '☕', 'color': '#A55EEA'},
    {'text': 'En ligne', 'emoji': '💻', 'color': '#0ABDE3'},
  ];

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('status_presets');
    if (saved != null && saved.isNotEmpty) {
      setState(() {
        _presets = saved.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
      });
    } else {
      setState(() {
        _presets = List.from(_defaultPresets);
      });
    }
  }

  Future<void> _savePresets() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _presets.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('status_presets', encoded);
  }

  void _addPreset() {
    final text = _newPresetController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _presets.add({
        'text': text,
        'emoji': '📝',
        'color': '#D4AF37',
      });
      _newPresetController.clear();
    });
    _savePresets();
  }

  void _removePreset(int index) {
    setState(() {
      _presets.removeAt(index);
    });
    _savePresets();
  }

  void _editPreset(int index) {
    final preset = _presets[index];
    final controller = TextEditingController(text: preset['text']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le statut', style: TextStyle(fontSize: 16)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Texte du statut'),
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _presets[index] = {...preset, 'text': controller.text};
              });
              _savePresets();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
            child: const Text('Modifier', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _usePreset(Map<String, dynamic> preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_status', '${preset['emoji']} ${preset['text']}');
    if (mounted) {
      Navigator.pop(context, preset);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statut mis à jour'), duration: const Duration(seconds: 1)),
      );
    }
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
          'Statuts prédéfinis',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Add new preset
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newPresetController,
                    decoration: const InputDecoration(
                      hintText: 'Nouveau statut...',
                      hintStyle: TextStyle(fontSize: 12),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20, color: Color(0xFFD4AF37)),
                  onPressed: _addPreset,
                ),
              ],
            ),
          ),
          
          // Presets list
          Expanded(
            child: ListView.builder(
              itemCount: _presets.length,
              itemBuilder: (context, index) {
                final preset = _presets[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Text(preset['emoji'], style: const TextStyle(fontSize: 24)),
                    title: Text(preset['text'], style: const TextStyle(fontSize: 13)),
                    subtitle: Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Color(int.parse(preset['color'].substring(1, 7), radix: 16)).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                          onPressed: () => _editPreset(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check_circle, size: 18, color: Color(0xFFD4AF37)),
                          onPressed: () => _usePreset(preset),
                        ),
                        if (_presets.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                            onPressed: () => _removePreset(index),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper pour JSON
Map<String, dynamic> jsonDecode(String source) {
  final parts = source.replaceAll('{', '').replaceAll('}', '').split(',');
  final map = <String, dynamic>{};
  for (var part in parts) {
    final kv = part.split(':');
    if (kv.length == 2) {
      map[kv[0].trim()] = kv[1].trim().replaceAll('"', '');
    }
  }
  return map;
}

String jsonEncode(Map<String, dynamic> map) {
  return '{${map.entries.map((e) => '"${e.key}":"${e.value}"').join(',')}}';
}
