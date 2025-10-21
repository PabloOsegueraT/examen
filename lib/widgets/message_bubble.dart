import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final DateTime date;
  final bool mine;

  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.date,
    required this.mine,
  });

  @override
  Widget build(BuildContext context) {
    final align =
    mine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color =
    mine ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceVariant;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: mine ? const Radius.circular(16) : const Radius.circular(4),
      bottomRight: mine ? const Radius.circular(4)  : const Radius.circular(16),
    );

    final time = DateFormat('dd/MM HH:mm').format(date);

    return Column(
      crossAxisAlignment: align,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            mine ? 'Tú' : sender,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: radius,
          ),
          child: Column(
            crossAxisAlignment: align,
            children: [
              Text(text),
              const SizedBox(height: 6),
              Text(
                time,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ],
    );
  }
}