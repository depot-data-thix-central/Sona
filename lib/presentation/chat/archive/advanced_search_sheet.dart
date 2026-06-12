// lib/presentation/chat/archive/advanced_search_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/archive_provider.dart';

class AdvancedSearchSheet extends StatefulWidget {
  const AdvancedSearchSheet({super.key});

  @override
  State<AdvancedSearchSheet> createState() => _AdvancedSearchSheetState();
}

class _AdvancedSearchSheetState extends State<AdvancedSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'all';
  String _selectedDate = 'anytime';
  String _selectedSender = 'anyone';
  String _selectedChat = 'all';
  bool _hasMedia = false;
  bool _isSearching = false;
  
  final List<Map<String, dynamic>> _types = [
    {'label': 'Tous', 'value': 'all', 'icon': Icons.all_inclusive},
    {'label': 'Messages', 'value': 'message', 'icon': Icons.chat},
    {'label': 'Photos', 'value': 'photo', 'icon': Icons.image},
    {'label': 'Vidéos', 'value': 'video', 'icon': Icons.videocam},
    {'label': 'Fichiers', 'value': 'file', 'icon': Icons.insert_drive_file},
    {'label': 'Liens', 'value': 'link', 'icon': Icons.link},
    {'label': 'Audio', 'value': 'audio', 'icon': Icons.mic},
  ];
  
  final List<Map<String, String>> _dateRanges = [
    {'label': 'À tout moment', 'value': 'anytime'},
    {'label': "Aujourd'hui", 'value': 'today'},
    {'label': 'Cette semaine', 'value': 'week'},
    {'label': 'Ce mois', 'value': 'month'},
    {'label': 'Cette année', 'value': 'year'},
    {'label': 'Personnalisé', 'value': 'custom'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() => _isSearching = true);
    
    final provider = Provider.of<ArchiveProvider>(context, listen: false);
    await provider.searchArchives(
      query: _searchController.text,
      type: _selectedType,
      dateRange: _selectedDate,
      sender: _selectedSender,
      chat: _selectedChat,
      hasMedia: _hasMedia,
    );
    
    setState(() => _isSearching = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recherche avancée',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Filters
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type de contenu
                  const Text('Type de contenu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _types.map((type) {
                      final isSelected = _selectedType == type['value'];
                      return FilterChip(
                        label: Text(type['label'], style: const TextStyle(fontSize: 11)),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedType = type['value']),
                        avatar: Icon(type['icon'], size: 14),
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFFD4AF37).withOpacity(0.15),
                        checkmarkColor: const Color(0xFFD4AF37),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Période
                  const Text('Période', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _dateRanges.map((range) {
                      final isSelected = _selectedDate == range['value'];
                      return FilterChip(
                        label: Text(range['label'], style: const TextStyle(fontSize: 11)),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedDate = range['value']),
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFFD4AF37).withOpacity(0.15),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Filtres supplémentaires
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('Messages avec médias', style: TextStyle(fontSize: 12)),
                          value: _hasMedia,
                          onChanged: (value) => setState(() => _hasMedia = value ?? false),
                          activeColor: const Color(0xFFD4AF37),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Expéditeur', style: TextStyle(fontSize: 12)),
                          subtitle: Text(_selectedSender == 'anyone' ? 'Tout le monde' : _selectedSender),
                          trailing: const Icon(Icons.chevron_right, size: 16),
                          onTap: () => _selectSender(),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Conversation', style: TextStyle(fontSize: 12)),
                          subtitle: Text(_selectedChat == 'all' ? 'Toutes' : _selectedChat),
                          trailing: const Icon(Icons.chevron_right, size: 16),
                          onTap: () => _selectChat(),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSearching ? null : _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: const Color(0xFF0B1B3D),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: _isSearching
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Rechercher', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectSender() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Expéditeur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Tout le monde'),
              onTap: () {
                setState(() => _selectedSender = 'anyone');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Moi'),
              onTap: () {
                setState(() => _selectedSender = 'me');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Aminata Diallo'),
              onTap: () {
                setState(() => _selectedSender = 'Aminata Diallo');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectChat() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Conversation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Toutes'),
              onTap: () {
                setState(() => _selectedChat = 'all');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Aminata Diallo'),
              onTap: () {
                setState(() => _selectedChat = 'Aminata Diallo');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Équipe Marketing'),
              onTap: () {
                setState(() => _selectedChat = 'Équipe Marketing');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
