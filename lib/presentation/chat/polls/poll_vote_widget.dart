// lib/presentation/chat/polls/poll_vote_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/poll_provider.dart';
import '../../../models/poll_models.dart';

class PollVoteWidget extends StatefulWidget {
  final Poll poll;
  final String conversationId;

  const PollVoteWidget({
    super.key,
    required this.poll,
    required this.conversationId,
  });

  @override
  State<PollVoteWidget> createState() => _PollVoteWidgetState();
}

class _PollVoteWidgetState extends State<PollVoteWidget> {
  int? _selectedOption;
  List<int> _selectedOptions = [];
  bool _isVoting = false;

  @override
  void initState() {
    super.initState();
    if (widget.poll.hasVoted) {
      _selectedOption = widget.poll.userVote;
      _selectedOptions = widget.poll.userVotes ?? [];
    }
  }

  Future<void> _submitVote() async {
    if (widget.poll.isMultiple) {
      if (_selectedOptions.isEmpty) return;
    } else {
      if (_selectedOption == null) return;
    }

    setState(() => _isVoting = true);

    final pollProvider = Provider.of<PollProvider>(context, listen: false);
    final success = await pollProvider.vote(
      pollId: widget.poll.id,
      optionIndex: widget.poll.isMultiple ? null : _selectedOption,
      optionIndices: widget.poll.isMultiple ? _selectedOptions : null,
    );

    setState(() => _isVoting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote enregistré'), duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = widget.poll.isExpired;

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
                  widget.poll.question,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Options
          ...widget.poll.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final percentage = widget.poll.getPercentage(index);
            final isSelected = widget.poll.isMultiple
                ? _selectedOptions.contains(index)
                : _selectedOption == index;
            final canVote = !isExpired && !widget.poll.hasVoted;

            return GestureDetector(
              onTap: canVote
                  ? () {
                      if (widget.poll.isMultiple) {
                        setState(() {
                          if (_selectedOptions.contains(index)) {
                            _selectedOptions.remove(index);
                          } else {
                            _selectedOptions.add(index);
                          }
                        });
                      } else {
                        setState(() => _selectedOption = index);
                      }
                    }
                  : null,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFD4AF37).withOpacity(0.1) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (widget.poll.isMultiple)
                          Checkbox(
                            value: isSelected,
                            onChanged: canVote ? (_) => _onTapOption(index) : null,
                            activeColor: const Color(0xFFD4AF37),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )
                        else
                          Radio<int>(
                            value: index,
                            groupValue: _selectedOption,
                            onChanged: canVote ? (_) => _onTapOption(index) : null,
                            activeColor: const Color(0xFFD4AF37),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? const Color(0xFFD4AF37) : Colors.black87,
                            ),
                          ),
                        ),
                        if (widget.poll.hasVoted || isExpired)
                          Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                      ],
                    ),
                    if (widget.poll.hasVoted || isExpired)
                      const SizedBox(height: 4),
                    if (widget.poll.hasVoted || isExpired)
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        color: const Color(0xFFD4AF37),
                        minHeight: 4,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.poll.totalVotes} vote(s)',
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
              if (widget.poll.isExpired)
                const Text(
                  'Terminé',
                  style: TextStyle(fontSize: 9, color: Colors.red),
                )
              else if (!widget.poll.hasVoted)
                ElevatedButton(
                  onPressed: _isVoting ? null : _submitVote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: _isVoting
                      ? const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Voter', style: TextStyle(fontSize: 11)),
                )
              else
                const Text(
                  '✓ Vous avez voté',
                  style: TextStyle(fontSize: 9, color: Colors.green),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTapOption(int index) {
    if (widget.poll.isMultiple) {
      setState(() {
        if (_selectedOptions.contains(index)) {
          _selectedOptions.remove(index);
        } else {
          _selectedOptions.add(index);
        }
      });
    } else {
      setState(() => _selectedOption = index);
    }
  }
}
