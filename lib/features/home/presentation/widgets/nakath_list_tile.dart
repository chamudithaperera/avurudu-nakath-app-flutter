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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8EED1),
            Color(0xFFE8CC8A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC99A3B),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 8),
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
            color: const Color(0xFF8C1B1B).withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFC99A3B), width: 1.2),
          ),
          child: const Icon(
            Icons.access_time_filled_rounded,
            color: Color(0xFF8C1B1B),
            size: 26,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'TharuMahee',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 14,
                color: Color(0xFF8C1B1B),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  timeInfo,
                  style: const TextStyle(
                    fontFamily: 'GemunuX',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Color(0xFF2B1B16),
        ),
        onTap: onTap,
      ),
    );
  }
}
