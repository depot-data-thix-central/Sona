// lib/presentation/chat/themes/bubble_customizer.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BubbleCustomizer extends StatefulWidget {
  const BubbleCustomizer({super.key});

  @override
  State<BubbleCustomizer> createState() => _BubbleCustomizerState();
}

class _BubbleCustomizerState extends State<BubbleCustomizer> {
  String _bubbleStyle = 'rounded';
  Color _myBubbleColor = const Color(0xFFD4AF37);
  Color _otherBubbleColor = Colors.white;
  double _borderRadius = 16;
  bool _showAvatar = true;
  bool _showTime = true;
  bool _showReadReceipt = true;

  final List<Map<String, dynamic>> _bubbleStyles = [
    {'name': 'Arrondi', 'value': 'rounded', 'icon': Icons.circle},
    {'name': 'Carré', 'value': 'square', 'icon': Icons.square},
    {'name': 'Message', 'value': 'message', 'icon': Icons.message},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bubbleStyle = prefs.getString('bubble_style') ?? 'rounded';
      _myBubbleColor = Color(prefs.getInt('my_bubble_color') ?? 0xFFD4AF37);
      _otherBubbleColor = Color(prefs.getInt('other_bubble_color') ?? 0xFFFFFFFF);
      _borderRadius = prefs.getDouble('bubble_border_radius') ?? 16;
      _showAvatar = prefs.getBool('show_avatar') ?? true;
      _showTime = prefs.getBool('show_time') ?? true;
      _showReadReceipt = prefs.getBool('show_read_receipt') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is Color) {
      await prefs.setInt(key, value.value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else {
      await prefs.setString(key, value);
    }
  }

  Future<void> _selectColor(String type) async {
    final color = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir une couleur', style: const TextStyle(fontSize: 16)),
        content: SizedBox(
          width: 200,
          height: 200,
          child: ColorPicker(
            initialColor: type == 'my' ? _myBubbleColor : _otherBubbleColor,
            onColorSelected: (color) => Navigator.pop(context, color),
          ),
        ),
      ),
    );
    if (color != null) {
      setState(() {
        if (type == 'my') {
          _myBubbleColor = color;
          _saveSetting('my_bubble_color', color);
        } else {
          _otherBubbleColor = color;
          _saveSetting('other_bubble_color', color);
        }
      });
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
          'Personnaliser les bulles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          // Preview
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildPreviewBubble(true, 'Bonjour !'),
                const SizedBox(height: 12),
                _buildPreviewBubble(false, 'Salut ! Comment ça va ?'),
                const SizedBox(height: 12),
                _buildPreviewBubble(true, 'Très bien merci !'),
              ],
            ),
          ),
          
          // Bubble style
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
                  'Style des bulles',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _bubbleStyles.map((style) {
                    final isSelected = _bubbleStyle == style['value'];
                    return GestureDetector(
                      onTap: () {
                        setState(() => _bubbleStyle = style['value']);
                        _saveSetting('bubble_style', style['value']);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(style['icon'], size: 24, color: isSelected ? Colors.white : Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            style['name'],
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? const Color(0xFFD4AF37) : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // Colors
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildColorItem('Mes messages', _myBubbleColor, () => _selectColor('my')),
                const SizedBox(height: 16),
                _buildColorItem('Messages reçus', _otherBubbleColor, () => _selectColor('other')),
              ],
            ),
          ),
          
          // Border radius
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
                  'Arrondi des bulles',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 16, color: Colors.grey),
                    Expanded(
                      child: Slider(
                        value: _borderRadius,
                        min: 4,
                        max: 28,
                        onChanged: (value) {
                          setState(() => _borderRadius = value);
                          _saveSetting('bubble_border_radius', value);
                        },
                        activeColor: const Color(0xFFD4AF37),
                      ),
                    ),
                    const Icon(Icons.rounded_corner, size: 16, color: Color(0xFFD4AF37)),
                  ],
                ),
              ],
            ),
          ),
          
          // Options
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Afficher les avatars', style: TextStyle(fontSize: 13)),
                  value: _showAvatar,
                  onChanged: (value) {
                    setState(() => _showAvatar = value);
                    _saveSetting('show_avatar', value);
                  },
                  activeColor: const Color(0xFFD4AF37),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Afficher l\'heure', style: TextStyle(fontSize: 13)),
                  value: _showTime,
                  onChanged: (value) {
                    setState(() => _showTime = value);
                    _saveSetting('show_time', value);
                  },
                  activeColor: const Color(0xFFD4AF37),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Afficher les accusés', style: TextStyle(fontSize: 13)),
                  value: _showReadReceipt,
                  onChanged: (value) {
                    setState(() => _showReadReceipt = value);
                    _saveSetting('show_read_receipt', value);
                  },
                  activeColor: const Color(0xFFD4AF37),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorItem(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 12)),
          ),
          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPreviewBubble(bool isMe, String text) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe && _showAvatar)
          const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 14)),
        if (!isMe && _showAvatar) const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isMe ? _myBubbleColor : _otherBubbleColor,
            borderRadius: _getBorderRadius(isMe),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMe ? Colors.white : Colors.black87,
            ),
          ),
        ),
        if (isMe && _showAvatar)
          const SizedBox(width: 8),
        if (isMe && _showAvatar)
          const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 14)),
      ],
    );
  }

  BorderRadius _getBorderRadius(bool isMe) {
    if (_bubbleStyle == 'square') {
      return BorderRadius.circular(4);
    }
    final radius = Radius.circular(_borderRadius);
    if (isMe) {
      return BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: Radius.circular(4),
      );
    } else {
      return BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: Radius.circular(4),
        bottomRight: radius,
      );
    }
  }
}

// Simple Color Picker Widget
class ColorPicker extends StatelessWidget {
  final Color initialColor;
  final Function(Color) onColorSelected;

  const ColorPicker({super.key, required this.initialColor, required this.onColorSelected});

  final List<Color> _presetColors = const [
    Color(0xFFD4AF37), // Or
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _presetColors.length,
            itemBuilder: (context, index) {
              final color = _presetColors[index];
              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: initialColor == color ? const Color(0xFFD4AF37) : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
