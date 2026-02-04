import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/nakath_event.dart';
import '../mappers/nakath_localizer.dart';

class NakathListTile extends StatelessWidget {
  final NakathEvent event;
  final VoidCallback onTap;

  const NakathListTile({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = event.getLocalizedTitle(context);
    final theme = Theme.of(context);

    // Format full date and time for better visibility
    String displayDate = event.date ?? '';
    if (displayDate.isEmpty && event.start != null) {
      displayDate = DateFormat('MMM dd, yyyy').format(event.start!);
    }

    String timeInfo = displayDate;
    if (event.start != null) {
      final timeStr = DateFormat('hh:mm a').format(event.start!);
      timeInfo = displayDate.isNotEmpty ? '$displayDate • $timeStr' : timeStr;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.9,
        ), // More opaque for visibility
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.access_time_filled_rounded,
            color: Color(0xFFD84315),
            size: 26,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 17,
            color: Color(0xFF3E2723),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 14,
                color: Color(0xFF8D6E63),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  timeInfo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D4037), // Darker for better visibility
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Color(0xFF3E2723),
        ),
        onTap: onTap,
      ),
    );
  }
}
