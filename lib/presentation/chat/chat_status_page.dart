// lib/presentation/chat/chat_status_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/chat_provider.dart';
import '../../providers/auth_controller.dart';
import 'chat_status_update.dart';

class ChatStatusPage extends StatefulWidget {
  const ChatStatusPage({super.key});

  @override
  State<ChatStatusPage> createState() => _ChatStatusPageState();
}

class _ChatStatusPageState extends State<ChatStatusPage> with AutomaticKeepAliveClientMixin {
  int _selectedNavIndex = 3; // Statut sélectionné

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.loadMyStories();
    await chatProvider.loadContactsStatus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final chatProvider = Provider.of<ChatProvider>(context);
    final auth = Provider.of<AuthController>(context);
    final currentUser = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildMyStatus(currentUser, chatProvider.myStories),
          _buildStatusUpdates(chatProvider.contactsStatus),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _updateStatus(),
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add, size: 20, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Statut',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B1B3D)),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF0B1B3D)),
          onPressed: () => _showMenu(),
        ),
      ],
    );
  }

  Widget _buildMyStatus(AppUser? currentUser, List<Story> myStories) {
    final hasStory = myStories.isNotEmpty;
    final lastStory = hasStory ? myStories.first : null;
    
    return GestureDetector(
      onTap: hasStory ? () => _viewMyStories() : () => _updateStatus(),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: hasStory ? const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFAA7C11)]) : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: currentUser?.photoUrl != null ? NetworkImage(currentUser!.photoUrl!) : null,
                      child: currentUser?.photoUrl == null ? const Icon(Icons.person, size: 24) : null,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Color(0xFFD4AF37), shape: BoxShape.circle),
                    child: const Icon(Icons.add, size: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser?.displayName ?? 'Mon statut',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasStory ? 'Appuyez pour voir votre statut' : 'Ajouter une mise à jour',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                  if (hasStory && lastStory != null)
                    Text(
                      'Il y a ${_formatTimeAgo(lastStory.createdAt)}',
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusUpdates(List<UserStatusUpdate> updates) {
    if (updates.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text('Aucune mise à jour de statut', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              const SizedBox(height: 8),
              Text('Les statuts de vos contacts apparaîtront ici', style: TextStyle(fontSize: 11, color: Colors.grey[400])),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: updates.length,
        itemBuilder: (context, index) => _buildStatusUpdateItem(updates[index]),
      ),
    );
  }

  Widget _buildStatusUpdateItem(UserStatusUpdate update) {
    final hasNew = update.stories.any((s) => !s.isViewed);
    
    return GestureDetector(
      onTap: () => _viewStatus(update),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: hasNew ? const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFAA7C11)]) : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: update.userAvatar != null ? NetworkImage(update.userAvatar!) : null,
                      child: update.userAvatar == null ? const Icon(Icons.person, size: 22) : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    update.userName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTimeAgo(update.lastUpdate),
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            if (hasNew)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Color(0xFFD4AF37), shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          HapticFeedback.lightImpact();
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/chat'); break;
            case 2: context.push('/chat/spaces'); break;
            case 3: break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 20), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline, size: 20), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view, size: 20), label: 'Spaces'),
          BottomNavigationBarItem(icon: Icon(Icons.circle, size: 20), label: 'Statut'),
        ],
      ),
    );
  }

  void _updateStatus() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatStatusUpdatePage()),
    ).then((_) => _loadData());
  }

  void _viewMyStories() {
    // Afficher les stories de l'utilisateur
  }

  void _viewStatus(UserStatusUpdate update) {
    // Afficher les stories du contact
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.visibility_off, size: 20),
              title: const Text('Masquer mon statut', style: TextStyle(fontSize: 13)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off, size: 20),
              title: const Text('Désactiver les notifications', style: TextStyle(fontSize: 13)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 1) return 'il y a ${diff.inDays}j';
    if (diff.inHours >= 1) return 'il y a ${diff.inHours}h';
    if (diff.inMinutes >= 1) return 'il y a ${diff.inMinutes}min';
    return 'maintenant';
  }
}
