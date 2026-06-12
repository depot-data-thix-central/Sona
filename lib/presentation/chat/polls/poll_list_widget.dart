// lib/presentation/chat/polls/poll_list_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/poll_provider.dart';
import '../../../models/poll_models.dart';
import 'poll_vote_widget.dart';
import 'poll_results_widget.dart';

class PollListWidget extends StatefulWidget {
  final String conversationId;

  const PollListWidget({
    super.key,
    required this.conversationId,
  });

  @override
  State<PollListWidget> createState() => _PollListWidgetState();
}

class _PollListWidgetState extends State<PollListWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPolls();
  }

  Future<void> _loadPolls() async {
    final pollProvider = Provider.of<PollProvider>(context, listen: false);
    await pollProvider.loadPolls(widget.conversationId);
    setState(() => _isLoading = false);
  }

  void _showCreatePollSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PollCreatorSheet(conversationId: widget.conversationId),
    ).then((_) => _loadPolls());
  }

  @override
  Widget build(BuildContext context) {
    final pollProvider = Provider.of<PollProvider>(context);
    final polls = pollProvider.polls;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sondages',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              TextButton.icon(
                onPressed: _showCreatePollSheet,
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Nouveau', style: TextStyle(fontSize: 11)),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFFD4AF37)),
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (polls.isEmpty)
          GestureDetector(
            onTap: _showCreatePollSheet,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.poll, size: 20, color: Color(0xFFD4AF37)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Créer un sondage',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Recueillez l\'avis du groupe',
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: polls.length,
            itemBuilder: (context, index) {
              final poll = polls[index];
              if (poll.hasVoted || poll.isExpired) {
                return PollResultsWidget(poll: poll);
              } else {
                return PollVoteWidget(poll: poll, conversationId: widget.conversationId);
              }
            },
          ),
      ],
    );
  }
}
