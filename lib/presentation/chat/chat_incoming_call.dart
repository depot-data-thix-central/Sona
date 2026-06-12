// lib/presentation/chat/chat_incoming_call.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatIncomingCall extends StatefulWidget {
  final String callerName;
  final String callType; // 'audio' or 'video'
  
  const ChatIncomingCall({
    super.key,
    required this.callerName,
    required this.callType,
  });

  @override
  State<ChatIncomingCall> createState() => _ChatIncomingCallState();
}

class _ChatIncomingCallState extends State<ChatIncomingCall> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0B1B3D),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 80 + (15 * _pulseController.value),
                    height: 80 + (15 * _pulseController.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, size: 35, color: Colors.white),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                widget.callerName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                widget.callType == 'video' ? 'Appel vidéo entrant...' : 'Appel audio entrant...',
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _callButton(
                    icon: Icons.call_end,
                    label: 'Refuser',
                    color: Colors.red,
                    onTap: () => Navigator.pop(context),
                  ),
                  _callButton(
                    icon: widget.callType == 'video' ? Icons.videocam : Icons.call,
                    label: 'Accepter',
                    color: const Color(0xFFD4AF37),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/chat/call');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _callButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }
}
