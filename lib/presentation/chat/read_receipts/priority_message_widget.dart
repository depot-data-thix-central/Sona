// lib/presentation/chat/read_receipts/priority_message_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/read_receipt_provider.dart';

class PriorityMessageWidget extends StatefulWidget {
  final String conversationId;
  final Function(String) onSendPriorityMessage;

  const PriorityMessageWidget({
    super.key,
    required this.conversationId,
    required this.onSendPriorityMessage,
  });

  @override
  State<PriorityMessageWidget> createState() => _PriorityMessageWidgetState();
}

class _PriorityMessageWidgetState extends State<PriorityMessageWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _requireReadReceipt = true;
  bool _isSending = false;

  Future<void> _sendPriorityMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSending = true);

    final provider = Provider.of<ReadReceiptProvider>(context, listen: false);
    final success = await provider.sendPriorityMessage(
      conversationId: widget.conversationId,
      content: content,
      requireReadReceipt: _requireReadReceipt,
    );

    setState(() => _isSending = false);

    if (success && mounted) {
      widget.onSendPriorityMessage(content);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message prioritaire envoyé'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
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
              const Icon(Icons.priority_high, size: 20, color: Colors.red),
              const SizedBox(width: 8),
              const Text(
                'Message prioritaire',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Les messages prioritaires :',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text(
            '• Forcent un accusé de lecture\n• Notifient par notification spéciale\n• Apparaissent en rouge dans le chat',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          
          // Message
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Message prioritaire...',
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: const TextStyle(fontSize: 13),
            maxLines: 3,
            autofocus: true,
          ),
          
          const SizedBox(height: 12),
          
          // Option accusé
          SwitchListTile(
            title: const Text('Forcer accusé de lecture', style: TextStyle(fontSize: 12)),
            subtitle: const Text('Notifier quand le message est lu', style: TextStyle(fontSize: 10)),
            value: _requireReadReceipt,
            onChanged: (value) => setState(() => _requireReadReceipt = value),
            activeColor: const Color(0xFFD4AF37),
            contentPadding: EdgeInsets.zero,
          ),
          
          const SizedBox(height: 20),
          
          // Bouton envoyer
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSending ? null : _sendPriorityMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: _isSending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Envoyer en priorité', style: TextStyle(fontSize: 13)),
            ),
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
