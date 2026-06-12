// lib/presentation/chat/group_admin/group_settings_page.dart
import 'package:flutter/material.dart';

class GroupSettingsPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String? groupAvatar;
  final String currentUserRole;

  const GroupSettingsPage({
    super.key,
    required this.groupId,
    required this.groupName,
    this.groupAvatar,
    required this.currentUserRole,
  });

  @override
  State<GroupSettingsPage> createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  bool _notificationsEnabled = true;
  bool _onlyAdminsCanSend = false;
  bool _approveNewMembers = false;
  String _selectedChatWallpaper = 'default';

  final List<Map<String, dynamic>> _wallpapers = [
    {'name': 'Défaut', 'value': 'default', 'color': null},
    {'name': 'Sombre', 'value': 'dark', 'color': Color(0xFF1A1A1A)},
    {'name': 'Clair', 'value': 'light', 'color': Color(0xFFF5F5F5)},
    {'name': 'Bleu', 'value': 'blue', 'color': Color(0xFFE3F2FD)},
    {'name': 'Vert', 'value': 'green', 'color': Color(0xFFE8F5E9)},
  ];

  final bool isAdmin = widget.currentUserRole == 'admin';

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
          'Paramètres du groupe',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          // Info groupe
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: widget.groupAvatar != null
                          ? NetworkImage(widget.groupAvatar!)
                          : null,
                      child: widget.groupAvatar == null
                          ? const Icon(Icons.group, size: 40)
                          : null,
                    ),
                    if (isAdmin)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.groupName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (isAdmin)
                  TextButton(
                    onPressed: () => _showEditNameDialog(),
                    child: const Text(
                      'Modifier le nom',
                      style: TextStyle(fontSize: 11, color: Color(0xFFD4AF37)),
                    ),
                  ),
              ],
            ),
          ),
          
          // Notifications
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: const Text('Notifications', style: TextStyle(fontSize: 13)),
              subtitle: const Text('Recevoir les notifications du groupe', style: TextStyle(fontSize: 10)),
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
              activeColor: const Color(0xFFD4AF37),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          
          // Admin settings (only for admins)
          if (isAdmin) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('Admins uniquement', style: TextStyle(fontSize: 13)),
                subtitle: const Text('Seuls les admins peuvent envoyer des messages', style: TextStyle(fontSize: 10)),
                value: _onlyAdminsCanSend,
                onChanged: (value) => setState(() => _onlyAdminsCanSend = value),
                activeColor: const Color(0xFFD4AF37),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('Approbation des membres', style: TextStyle(fontSize: 13)),
                subtitle: const Text('Approuver les nouveaux membres', style: TextStyle(fontSize: 10)),
                value: _approveNewMembers,
                onChanged: (value) => setState(() => _approveNewMembers = value),
                activeColor: const Color(0xFFD4AF37),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ],
          
          // Fond d'écran
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
                    'Fond d\'écran',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _wallpapers.length,
                    itemBuilder: (context, index) {
                      final wallpaper = _wallpapers[index];
                      final isSelected = _selectedChatWallpaper == wallpaper['value'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedChatWallpaper = wallpaper['value']),
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: wallpaper['color'] ?? Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              wallpaper['name'],
                              style: TextStyle(
                                fontSize: 10,
                                color: wallpaper['color'] != null ? Colors.black87 : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          
          // Danger zone (only for admins)
          if (isAdmin)
            Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_add, size: 20, color: Color(0xFFD4AF37)),
                    title: const Text('Inviter des membres', style: TextStyle(fontSize: 13)),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                    onTap: () => _showInviteDialog(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, size: 20, color: Colors.orange),
                    title: const Text('Quitter le groupe', style: TextStyle(fontSize: 13)),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                    onTap: () => _showLeaveDialog(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete, size: 20, color: Colors.red),
                    title: const Text('Supprimer le groupe', style: TextStyle(fontSize: 13)),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                    onTap: () => _showDeleteDialog(),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showEditNameDialog() {
    final controller = TextEditingController(text: widget.groupName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le nom', style: TextStyle(fontSize: 16)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nom du groupe'),
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
            child: const Text('Enregistrer', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
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
              'Inviter des membres',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Nom, email ou numéro',
                hintStyle: TextStyle(fontSize: 12),
                prefixIcon: Icon(Icons.search, size: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Inviter', style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter le groupe', style: TextStyle(fontSize: 16)),
        content: const Text(
          'Voulez-vous vraiment quitter ce groupe ?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Quitter', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le groupe', style: TextStyle(fontSize: 16)),
        content: const Text(
          'Cette action est irréversible. Tout le contenu sera supprimé.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
