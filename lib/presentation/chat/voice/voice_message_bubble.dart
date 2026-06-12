// lib/presentation/chat/voice/voice_message_bubble.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/voice_provider.dart';
import 'voice_player_widget.dart';
import 'transcript_view.dart';

class VoiceMessageBubble extends StatelessWidget {
  final String messageId;
  final String audioUrl;
  final int duration;
  final String? transcript;
  final bool isFromMe;
  final DateTime createdAt;

  const VoiceMessageBubble({
    super.key,
    required this.messageId,
    required this.audioUrl,
    required this.duration,
    this.transcript,
    required this.isFromMe,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VoiceProvider>(context);
    final isTranscribing = provider.isTranscribing(messageId);
    final currentTranscript = provider.getTranscript(messageId) ?? transcript;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoicePlayerWidget(
          audioUrl: audioUrl,
          duration: duration,
          isFromMe: isFromMe,
        ),
        const SizedBox(height: 4),
        if (isTranscribing)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Transcription en cours...',
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          )
        else if (currentTranscript != null && currentTranscript.isNotEmpty)
          TranscriptView(
            transcript: currentTranscript,
            isFromMe: isFromMe,
          )
        else if (!isFromMe)
          GestureDetector(
            onTap: () => provider.transcribeAudio(messageId, audioUrl),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.subtitles, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text(
                    'Transcrire',
                    style: TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
