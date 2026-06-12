// lib/presentation/chat/home_widgets/widget_preview.dart
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class WidgetPreview extends StatefulWidget {
  const WidgetPreview({super.key});

  @override
  State<WidgetPreview> createState() => _WidgetPreviewState();
}

class _WidgetPreviewState extends State<WidgetPreview> {
  String _selectedWidget = RecentConversationWidget.widgetName;
  
  final List<Map<String, dynamic>> _widgets = [
    {'name': 'Conversation récente', 'value': RecentConversationWidget.widgetName, 'icon': Icons.chat},
    {'name': 'Statut', 'value': StatusWidget.widgetName, 'icon': Icons.circle},
    {'name': 'Appel rapide', 'value': QuickCallWidget.widgetName, 'icon': Icons.call},
    {'name': 'Sondage', 'value': PollWidget.widgetName, 'icon': Icons.poll},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Aperçu des widgets',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Simulate home screen
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: const Color(0xFF0B1B3D),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                children: [
                  // Wallpaper simulation
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      image: const DecorationImage(
                        image: NetworkImage('https://picsum.photos/400/800'),
                        fit: BoxFit.cover,
                        opacity: 0.3,
                      ),
                    ),
                  ),
                  // Time
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: const Center(
                      child: Text(
                        '9:41',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  // Widget preview
                  Positioned(
                    top: 60,
                    left: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
                      ),
                      child: _buildSelectedPreview(),
                    ),
                  ),
                  // Dock icons
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _dockIcon(Icons.chat, 'Chats'),
                        _dockIcon(Icons.phone, 'Appels'),
                        _dockIcon(Icons.contacts, 'Contacts'),
                        _dockIcon(Icons.settings, 'Paramètres'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Widget selector
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choisir un widget',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _widgets.map((widget) {
                      final isSelected = _selectedWidget == widget['value'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedWidget = widget['value']),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(widget['icon'], size: 14, color: isSelected ? Colors.white : Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                widget['name'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected ? Colors.white : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _addWidgetToHomeScreen(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Ajouter à l\'écran d\'accueil', style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: const Color(0xFF0B1B3D),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSelectedPreview() {
    switch (_selectedWidget) {
      case 'recent_conversation':
        return RecentConversationWidget.buildPreview();
      case 'chat_status':
        return StatusWidget.buildPreview();
      case 'quick_call':
        return QuickCallWidget.buildPreview();
      case 'chat_poll':
        return PollWidget.buildPreview();
      default:
        return RecentConversationWidget.buildPreview();
    }
  }
  
  Widget _dockIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white70)),
      ],
    );
  }
  
  Future<void> _addWidgetToHomeScreen() async {
    // Instruction pour ajouter le widget
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter le widget', style: TextStyle(fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '1. Retournez à l\'écran d\'accueil',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              '2. Appuyez longuement sur l\'écran',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              '3. Sélectionnez "Widgets"',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              '4. Cherchez "THIX Chat"',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              '5. Choisissez la taille et ajoutez',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
