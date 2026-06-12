// lib/presentation/chat/translation/translated_bubble.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/translation_provider.dart';

class TranslatedBubble extends StatelessWidget {
  final String messageId;
  final String originalText;
  final String originalLanguage;
  final bool isFromMe;
  final Widget child;

  const TranslatedBubble({
    super.key,
    required this.messageId,
    required this.originalText,
    required this.originalLanguage,
    required this.isFromMe,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TranslationProvider>(context);
    final isTranslated = provider.isTranslated(messageId);
    final translatedText = provider.getTranslation(messageId);
    final targetLang = provider.targetLanguage;
    final autoTranslate = provider.autoTranslate;

    // Auto-traduction si activée
    if (autoTranslate && !isTranslated && originalLanguage != targetLang) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.translateMessage(
          messageId: messageId,
          text: originalText,
          sourceLang: originalLanguage,
          targetLang: targetLang,
        );
      });
    }

    return Column(
      crossAxisAlignment: isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        child,
        if (isTranslated && translatedText != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isFromMe
                  ? const Color(0xFFD4AF37).withOpacity(0.15)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isFromMe
                    ? const Color(0xFFD4AF37).withOpacity(0.3)
                    : Colors.grey[200]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.translate, size: 10, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 4),
                    Text(
                      'Traduit en ${_getLanguageName(targetLang)}',
                      style: const TextStyle(fontSize: 8, color: Color(0xFFD4AF37)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  translatedText,
                  style: TextStyle(
                    fontSize: 11,
                    color: isFromMe ? Colors.white70 : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getLanguageName(String code) {
    const languages = {
      'fr': 'Français',
      'en': 'Anglais',
      'ar': 'Arabe',
      'es': 'Espagnol',
      'de': 'Allemand',
      'it': 'Italien',
      'pt': 'Portugais',
      'ru': 'Russe',
      'zh': 'Chinois',
      'ja': 'Japonais',
    };
    return languages[code] ?? code;
  }
}
