// lib/presentation/chat/widgets/chat_stats_row.dart
import 'package:flutter/material.dart';

class ChatStatsRow extends StatelessWidget {
  final int onlineCount;
  final int newMessagesCount;
  final int activeCallsCount;
  final int securityAlertsCount;

  const ChatStatsRow({
    super.key,
    required this.onlineCount,
    required this.newMessagesCount,
    required this.activeCallsCount,
    required this.securityAlertsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(
            count: onlineCount.toString(),
            label: 'En ligne',
            icon: Icons.circle,
            color: Colors.green,
            size: 8,
          ),
          _StatItem(
            count: newMessagesCount.toString(),
            label: 'Nouveaux messages',
            icon: Icons.mark_email_unread,
            color: const Color(0xFFD4AF37),
            size: 12,
          ),
          _StatItem(
            count: activeCallsCount.toString(),
            label: 'Réunions actives',
            icon: Icons.videocam,
            color: Colors.blue,
            size: 12,
          ),
          _StatItem(
            count: securityAlertsCount.toString(),
            label: 'Alertes sécurité',
            icon: Icons.warning,
            color: Colors.red,
            size: 12,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color color;
  final double size;

  const _StatItem({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: size, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 9, color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }
}
