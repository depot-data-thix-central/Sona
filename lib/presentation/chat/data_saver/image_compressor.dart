// lib/presentation/chat/data_saver/image_compressor.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageCompressor {
  // Compresser une image
  static Future<File?> compressImage(File imageFile, {int quality = 70}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      
      if (originalImage == null) return null;
      
      // Redimensionner si trop grand
      img.Image? compressedImage = originalImage;
      if (originalImage.width > 1920) {
        compressedImage = img.copyResize(originalImage, width: 1920);
      }
      
      // Compresser
      final compressedBytes = img.encodeJpg(compressedImage, quality: quality);
      
      // Sauvegarder
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);
      
      return tempFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return null;
    }
  }
  
  // Compresser avec différents niveaux
  static Future<File?> compressWithQuality(File imageFile, String quality) async {
    int qualityValue;
    switch (quality) {
      case 'high':
        qualityValue = 85;
        break;
      case 'medium':
        qualityValue = 60;
        break;
      case 'low':
        qualityValue = 30;
        break;
      default:
        qualityValue = 70;
    }
    return await compressImage(imageFile, quality: qualityValue);
  }
  
  // Obtenir la taille de l'image
  static Future<int> getImageSize(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return bytes.length;
  }
  
  // Formater la taille
  static String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class ImageCompressorWidget extends StatefulWidget {
  final File imageFile;
  final Function(File compressedFile) onCompressed;

  const ImageCompressorWidget({
    super.key,
    required this.imageFile,
    required this.onCompressed,
  });

  @override
  State<ImageCompressorWidget> createState() => _ImageCompressorWidgetState();
}

class _ImageCompressorWidgetState extends State<ImageCompressorWidget> {
  String _selectedQuality = 'high';
  bool _isCompressing = false;
  int? _originalSize;
  int? _compressedSize;
  File? _compressedFile;

  final List<Map<String, dynamic>> _qualityOptions = [
    {'label': 'Haute qualité', 'value': 'high', 'desc': 'Meilleure qualité, fichier plus lourd'},
    {'label': 'Qualité moyenne', 'value': 'medium', 'desc': 'Bon équilibre qualité/poids'},
    {'label': 'Basse qualité', 'value': 'low', 'desc': 'Économie de données maximale'},
  ];

  @override
  void initState() {
    super.initState();
    _loadOriginalSize();
  }

  Future<void> _loadOriginalSize() async {
    final size = await ImageCompressor.getImageSize(widget.imageFile);
    setState(() => _originalSize = size);
  }

  Future<void> _compress() async {
    setState(() {
      _isCompressing = true;
      _compressedSize = null;
    });

    final compressed = await ImageCompressor.compressWithQuality(widget.imageFile, _selectedQuality);
    
    if (compressed != null) {
      final size = await ImageCompressor.getImageSize(compressed);
      setState(() {
        _compressedFile = compressed;
        _compressedSize = size;
        _isCompressing = false;
      });
    } else {
      setState(() => _isCompressing = false);
    }
  }

  void _apply() {
    if (_compressedFile != null) {
      widget.onCompressed(_compressedFile!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Compresser l\'image', style: TextStyle(fontSize: 16)),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Original size
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Taille originale', style: TextStyle(fontSize: 11)),
                      Text(
                        _originalSize != null ? ImageCompressor.formatSize(_originalSize!) : '...',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Quality options
            ..._qualityOptions.map((option) {
              final isSelected = _selectedQuality == option['value'];
              return RadioListTile<String>(
                value: option['value'],
                groupValue: _selectedQuality,
                onChanged: (value) => setState(() => _selectedQuality = value!),
                title: Text(option['label'], style: const TextStyle(fontSize: 12)),
                subtitle: Text(option['desc'], style: const TextStyle(fontSize: 9)),
                activeColor: const Color(0xFFD4AF37),
                contentPadding: EdgeInsets.zero,
              );
            }),
            
            const SizedBox(height: 12),
            
            // Compressed size
            if (_compressedSize != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.compress, size: 20, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Taille compressée', style: TextStyle(fontSize: 11)),
                          Text(
                            ImageCompressor.formatSize(_compressedSize!),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${((1 - (_compressedSize! / _originalSize!)) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            
            if (_isCompressing)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCompressing ? null : _compress,
          child: Text(_compressedSize != null ? 'Recompresser' : 'Compresser', style: const TextStyle(fontSize: 12)),
        ),
        ElevatedButton(
          onPressed: _compressedFile == null ? null : _apply,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
          child: const Text('Appliquer', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
