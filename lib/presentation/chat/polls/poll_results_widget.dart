// lib/presentation/chat/polls/poll_results_widget.dart
import 'package:flutter/material.dart';
import '../../../models/poll_models.dart';

class PollResultsWidget extends StatelessWidget {
  final Poll poll;

  const PollResultsWidget({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Row(
            children: [
              const Icon(Icons.poll, size: 16, color: Color(0xFFD4AF37)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  poll.question,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Résultats par option
          ...poll.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final percentage = poll.getPercentage(index);
            final votes = poll.getVotesCount(index);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$votes (${percentage.toStringAsFixed(0)}%)',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    color: _getColorForOption(index),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${poll.totalVotes} vote(s)',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              if (poll.isExpired)
                const Text(
                  'Sondage terminé',
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorForOption(int index) {
    const colors = [Color(0xFFD4AF37), Color(0xFFE67E22), Colors.blue, Colors.green, Colors.purple];
    return colors[index % colors.length];
  }
}
