// lib/presentation/chat/group_admin/add_members_sheet.dart
import 'package:flutter/material.dart';

class AddMembersSheet extends StatefulWidget {
  final String groupId;
  final List<String> currentMemberIds;
  final Function(List<String> selectedUserIds) onAdd;

  const AddMembersSheet({
    super.key,
    required this.groupId,
    required this.currentMemberIds,
    required this.onAdd,
  });

  @override
  State<AddMembersSheet> createState() => _AddMembersSheetState();
}

class _AddMembersSheetState extends State<AddMembersSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<String> _selectedUserIds = [];
  bool _isLoading = true;

  // Contacts simulés
  final List<Contact> _allContacts = [
    Contact(id: '1', name: 'Jean Dupont', avatar: null, isFriend: true),
    Contact(id: '2', name: 'Marie Koné', avatar: null, isFriend: true),
    Contact(id: '3', name: 'Paul Yao', avatar: null, isFriend: false),
    Contact(id: '4', name: 'Sarah Touré', avatar: null, isFriend: true),
    Contact(id: '5', name: 'David Kouadio', avatar: null, isFriend: false),
  ];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      _contacts = _allContacts
          .where((c) => !widget.currentMemberIds.contains(c.id))
          .toList();
      _isLoading = false;
    });
  }

  List<Contact> get _filteredContacts {
    if (_searchController.text.isEmpty) return _contacts;
    return _contacts.where((c) =>
      c.name.toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  void _toggleSelection(String userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
    });
  }

  void _addMembers() {
    if (_selectedUserIds.isNotEmpty) {
      widget.onAdd(_selectedUserIds);
      Navigator.pop(context);
    }
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
          Row(
            children: [
              const Text(
                'Ajouter des membres',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (_selectedUserIds.isNotEmpty)
                TextButton(
                  onPressed: _addMembers,
                  child: Text(
                    'Ajouter (${_selectedUserIds.length})',
                    style: const TextStyle(fontSize: 12, color: Color(0xFFD4AF37)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Search bar
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Rechercher un contact...',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Contacts list
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_filteredContacts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.people_outline, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text(
                      'Aucun contact trouvé',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final isSelected = _selectedUserIds.contains(contact.id);
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: contact.avatar != null
                          ? NetworkImage(contact.avatar!)
                          : null,
                      child: contact.avatar == null
                          ? const Icon(Icons.person, size: 20)
                          : null,
                    ),
                    title: Text(
                      contact.name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      contact.isFriend ? 'Contact' : 'Inviter à rejoindre THIX',
                      style: TextStyle(fontSize: 10, color: contact.isFriend ? Colors.green : Colors.orange),
                    ),
                    trailing: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[200],
                        border: Border.all(
                          color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[300]!,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    onTap: () => _toggleSelection(contact.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class Contact {
  final String id;
  final String name;
  final String? avatar;
  final bool isFriend;

  Contact({
    required this.id,
    required this.name,
    this.avatar,
    required this.isFriend,
  });
}
