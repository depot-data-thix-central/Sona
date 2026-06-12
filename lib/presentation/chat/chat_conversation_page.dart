// lib/presentation/chat/chat_conversation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart';

import '../../providers/chat_provider.dart';
import '../../providers/auth_controller.dart';
import '../../models/chat_models.dart';

class ChatConversationPage extends StatefulWidget {
  final String conversationId;
  final Conversation? conversation;

  const ChatConversationPage({
    super.key,
    required this.conversationId,
    this.conversation,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> with AutomaticKeepAliveClientMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isTyping = false;
  Timer? _typingTimer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupRealtime();
    _markAsRead();
  }

  void _loadMessages() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.loadMessages(widget.conversationId);
    _scrollToBottom();
  }

  void _setupRealtime() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.initConversationRealtime(widget.conversationId);
  }

  void _markAsRead() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.markMessagesAsRead(widget.conversationId);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTyping() {
    if (!_isTyping) {
      setState(() => _isTyping = true);
      _sendTypingStatus(true);
    }
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      setState(() => _isTyping = false);
      _sendTypingStatus(false);
    });
  }

  void _sendTypingStatus(bool isTyping) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendTypingStatus(widget.conversationId, isTyping);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.sendMessage(widget.conversationId, text);
    _scrollToBottom();
  }

  Future<void> _sendImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await chatProvider.sendMedia(widget.conversationId, result.files.single.path!, 'image');
      _scrollToBottom();
    }
  }

  Future<void> _sendFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await chatProvider.sendMedia(widget.conversationId, result.files.single.path!, 'file');
      _scrollToBottom();
    }
  }

  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start();
      setState(() => _isRecording = true);
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() => _isRecording = false);
    if (path != null) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await chatProvider.sendMedia(widget.conversationId, path, 'audio');
      _scrollToBottom();
    }
  }

  void _addReaction(String messageId, String emoji) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.addReaction(widget.conversationId, messageId, emoji);
  }

  void _pinMessage(ChatMessage message) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.pinMessage(widget.conversationId, message.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.messages;
    final isTypingFromOther = chatProvider.isTypingInConversation;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(chatProvider),
      body: Column(
        children: [
          if (chatProvider.pinnedMessage != null)
            _buildPinnedMessage(chatProvider.pinnedMessage!),
          Expanded(
            child: _buildMessageList(messages, isTypingFromOther),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatProvider chatProvider) {
    final conv = widget.conversation ?? chatProvider.getConversation(widget.conversationId);
    
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conv?.name ?? 'Chat',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Text(
            conv?.isOnline == true ? 'En ligne' : (conv?.lastSeen != null ? 'Vu ${_formatLastSeen(conv!.lastSeen!)}' : ''),
            style: TextStyle(fontSize: 10, color: conv?.isOnline == true ? Colors.green : Colors.grey),
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.call, size: 20), onPressed: () => _startCall('audio')),
        IconButton(icon: const Icon(Icons.videocam, size: 20), onPressed: () => _startCall('video')),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert, size: 20),
          itemBuilder: (context) => [
            const PopupMenuItem(child: Text('Voir le profil', style: TextStyle(fontSize: 13))),
            const PopupMenuItem(child: Text('Rechercher', style: TextStyle(fontSize: 13))),
            const PopupMenuItem(child: Text('Médias, liens et docs', style: TextStyle(fontSize: 13))),
            const PopupMenuItem(child: Text('Notifications', style: TextStyle(fontSize: 13))),
            const PopupMenuItem(child: Text('Épingler la conversation', style: TextStyle(fontSize: 13))),
            const PopupMenuItem(child: Text('Supprimer', style: TextStyle(fontSize: 13))),
          ],
        ),
      ],
    );
  }

  Widget _buildPinnedMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: const Color(0xFFD4AF37), width: 3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.push_pin, size: 14, color: Color(0xFFD4AF37)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Message épinglé', style: TextStyle(fontSize: 9, color: const Color(0xFFD4AF37))),
                Text(message.content, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _scrollToMessage(message.id),
            child: const Icon(Icons.arrow_downward, size: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages, bool isTypingFromOther) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: messages.length + (isTypingFromOther ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isTypingFromOther) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.isFromMe;
    
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 60 : 0,
          right: isMe ? 0 : 60,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe && message.senderAvatar != null)
                  CircleAvatar(radius: 12, backgroundImage: NetworkImage(message.senderAvatar!)),
                const SizedBox(width: 4),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFD4AF37) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 2)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.type == 'text')
                          Text(message.content, style: TextStyle(fontSize: 13, color: isMe ? Colors.white : Colors.black87)),
                        if (message.type == 'image')
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(message.mediaUrl!, width: 180, fit: BoxFit.cover),
                          ),
                        if (message.type == 'audio')
                          _buildAudioMessage(message),
                        if (message.type == 'file')
                          _buildFileMessage(message),
                        if (message.reactions.isNotEmpty)
                          _buildReactions(message),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message.formattedTime, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                  if (isMe && message.isRead) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, size: 10, color: Colors.green),
                  ] else if (isMe && message.isDelivered) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done, size: 10, color: Colors.grey),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioMessage(ChatMessage message) {
    return Row(
      children: [
        Icon(Icons.play_circle, size: 28, color: const Color(0xFFD4AF37)),
        const SizedBox(width: 8),
        Text('${message.mediaDuration ?? 0} s', style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildFileMessage(ChatMessage message) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.fileName ?? 'Fichier', style: const TextStyle(fontSize: 11), maxLines: 1),
                Text('${(message.fileSize ?? 0) / 1024} KB', style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactions(ChatMessage message) {
    return Wrap(
      spacing: 4,
      children: message.reactions.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(entry.key, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 2),
              Text('${entry.value.length}', style: const TextStyle(fontSize: 9)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(0),
                const SizedBox(width: 4),
                _dot(1),
                const SizedBox(width: 4),
                _dot(2),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text('écrit...', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _dot(int delay) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400 + (delay * 200)),
      curve: Curves.easeInOut,
      width: 6,
      height: 6,
      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, size: 20, color: Colors.grey),
            onPressed: () => _showAttachmentMenu(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onChanged: (_) => _onTyping(),
                      onTap: () => _scrollToBottom(),
                      decoration: const InputDecoration(
                        hintText: 'Tapez un message...',
                        hintStyle: TextStyle(fontSize: 12),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic, size: 20, color: Colors.grey),
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, size: 20, color: Color(0xFFD4AF37)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _showAttachmentMenu() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _attachmentItem(Icons.image, 'Image', _sendImage),
                _attachmentItem(Icons.insert_drive_file, 'Document', _sendFile),
                _attachmentItem(Icons.location_on, 'Position', () {}),
                _attachmentItem(Icons.contact_page, 'Contact', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  void _showMessageOptions(ChatMessage message) {
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
            _messageOption(Icons.reply, 'Répondre', () {}),
            _messageOption(Icons.content_copy, 'Copier', () {}),
            _messageOption(Icons.star_border, 'Épingler', () => _pinMessage(message)),
            _messageOption(Icons.delete_outline, 'Supprimer', () {}),
            _messageOption(Icons.emoji_emotions, 'Réagir', () => _showReactionPicker(message.id)),
          ],
        ),
      ),
    );
  }

  Widget _messageOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.grey[700]),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _showReactionPicker(String messageId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          children: ['❤️', '👍', '😂', '😮', '😢', '😡'].map((emoji) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _addReaction(messageId, emoji);
              },
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _scrollToMessage(String messageId) {
    // Implémenter le scroll vers un message spécifique
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final diff = now.difference(lastSeen);
    if (diff.inMinutes < 1) return 'à l\'instant';
    if (diff.inHours < 1) return 'il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return DateFormat('HH:mm').format(lastSeen);
    return DateFormat('dd/MM').format(lastSeen);
  }

  void _startCall(String type) {
    context.push('/chat/call', extra: {
      'conversationId': widget.conversationId,
      'name': widget.conversation?.name,
      'type': type,
    });
  }
}
