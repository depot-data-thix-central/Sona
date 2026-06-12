// lib/presentation/chat/data_saver/auto_download_settings.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoDownloadSettings extends StatefulWidget {
  const AutoDownloadSettings({super.key});

  @override
  State<AutoDownloadSettings> createState() => _AutoDownloadSettingsState();
}

class _AutoDownloadSettingsState extends State<AutoDownloadSettings> {
  String _photosOnMobile = 'wifi';
  String _videosOnMobile = 'never';
  String _documentsOnMobile = 'wifi';
  String _photosOnWifi = 'always';
  String _videosOnWifi = 'wifi';
  String _documentsOnWifi = 'always';
  int _maxFileSize = 50; // MB

  final List<Map<String, dynamic>> _downloadOptions = [
    {'label': 'Toujours', 'value': 'always'},
    {'label': 'Wi-Fi uniquement', 'value': 'wifi'},
    {'label': 'Jamais', 'value': 'never'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _photosOnMobile = prefs.getString('auto_download_photos_mobile') ?? 'wifi';
      _videosOnMobile = prefs.getString('auto_download_videos_mobile') ?? 'never';
      _documentsOnMobile = prefs.getString('auto_download_documents_mobile') ?? 'wifi';
      _photosOnWifi = prefs.getString('auto_download_photos_wifi') ?? 'always';
      _videosOnWifi = prefs.getString('auto_download_videos_wifi') ?? 'wifi';
      _documentsOnWifi = prefs.getString('auto_download_documents_wifi') ?? 'always';
      _maxFileSize = prefs.getInt('max_auto_download_size') ?? 50;
    });
  }

  Future<void> _saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _saveMaxSize(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('max_auto_download_size', value);
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
          'Téléchargement auto',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          // Section mobile
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Données mobiles',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                _buildOptionRow('Photos', _photosOnMobile, (value) {
                  setState(() => _photosOnMobile = value);
                  _saveSetting('auto_download_photos_mobile', value);
                }),
                const Divider(height: 1),
                _buildOptionRow('Vidéos', _videosOnMobile, (value) {
                  setState(() => _videosOnMobile = value);
                  _saveSetting('auto_download_videos_mobile', value);
                }),
                const Divider(height: 1),
                _buildOptionRow('Documents', _documentsOnMobile, (value) {
                  setState(() => _documentsOnMobile = value);
                  _saveSetting('auto_download_documents_mobile', value);
                }),
              ],
            ),
          ),
          
          // Section Wi-Fi
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Wi-Fi',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                _buildOptionRow('Photos', _photosOnWifi, (value) {
                  setState(() => _photosOnWifi = value);
                  _saveSetting('auto_download_photos_wifi', value);
                }),
                const Divider(height: 1),
                _buildOptionRow('Vidéos', _videosOnWifi, (value) {
                  setState(() => _videosOnWifi = value);
                  _saveSetting('auto_download_videos_wifi', value);
                }),
                const Divider(height: 1),
                _buildOptionRow('Documents', _documentsOnWifi, (value) {
                  setState(() => _documentsOnWifi = value);
                  _saveSetting('auto_download_documents_wifi', value);
                }),
              ],
            ),
          ),
          
          // Taille maximale
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
                  'Taille maximale des fichiers',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('${_maxFileSize} MB', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Slider(
                        value: _maxFileSize.toDouble(),
                        min: 1,
                        max: 500,
                        divisions: 50,
                        onChanged: (value) {
                          setState(() => _maxFileSize = value.toInt());
                          _saveMaxSize(value.toInt());
                        },
                        activeColor: const Color(0xFFD4AF37),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Les fichiers plus gros ne seront pas téléchargés automatiquement',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow(String title, String currentValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Row(
            children: _downloadOptions.map((option) {
              final isSelected = currentValue == option['value'];
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () => onChanged(option['value']),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      option['label'],
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
