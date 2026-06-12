// lib/presentation/chat/chat_call_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ChatCallPage extends StatefulWidget {
  const ChatCallPage({super.key});

  @override
  State<ChatCallPage> createState() => _ChatCallPageState();
}

class _ChatCallPageState extends State<ChatCallPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoOn = true;
  Duration _callDuration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _callDuration = Duration(seconds: _callDuration.inSeconds + 1));
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1B3D),
      body: Stack(
        children: [
          // Video background
          Container(color: Colors.black),
          
          // Self video preview (small)
          Positioned(
            top: 60,
            right: 16,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: const Center(child: Icon(Icons.videocam_off, size: 30, color: Colors.white54)),
            ),
          ),
          
          // Call info
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 100 + (20 * _pulseController.value),
                      height: 100 + (20 * _pulseController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text('Aminata Diallo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(_formatDuration(_callDuration), style: const TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 8),
                const Text('Appel en cours...', style: TextStyle(fontSize: 12, color: Colors.white54)),
              ],
            ),
          ),
          
          // Call controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _callButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: _isMuted ? 'Micro off' : 'Micro',
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _callButton(
                    icon: Icons.call_end,
                    label: 'Raccrocher',
                    color: Colors.red,
                    onTap: () => Navigator.pop(context),
                  ),
                  _callButton(
                    icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                    label: _isSpeakerOn ? 'Haut-parleur' : 'Écouteur',
                    onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                  ),
                  _callButton(
                    icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
                    label: _isVideoOn ? 'Vidéo' : 'Caméra off',
                    onTap: () => setState(() => _isVideoOn = !_isVideoOn),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _callButton({required IconData icon, required String label, required VoidCallback onTap, Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color == Colors.red ? Colors.red : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color == Colors.red ? Colors.white : Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }
}
