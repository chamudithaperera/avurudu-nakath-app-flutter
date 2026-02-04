import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/nakath_event.dart';
import 'countdown_timer.dart';
import '../mappers/nakath_localizer.dart';
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';

class NakathHeroCard extends StatelessWidget {
  final NakathEvent event;

  const NakathHeroCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final title = event.getLocalizedTitle(context);
    final uiL10n = UiLocalizations.of(context)!;

    String formattedTime = '';
    if (event.start != null) {
      formattedTime = DateFormat('yyyy-MM-dd hh:mm a').format(event.start!);
    }

    final targetTime =
        event.start ??
        (event.date != null ? DateTime.tryParse(event.date!) : null);
    final isFuture = targetTime != null && targetTime.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3E2723), // Deep Brown
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFECB3), // Light Amber
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFF6F00)), // Star icon
                const SizedBox(width: 8),
                Text(
                  uiL10n.nextUpcoming,
                  style: const TextStyle(
                    color: Color(0xFF3E2723),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 16),
                if (isFuture && targetTime != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CountdownTimer(targetTime: targetTime),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.start != null ? formattedTime : (event.date ?? ''),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ] else ...[
                  Text(
                    event.start != null ? formattedTime : (event.date ?? ''),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Liyawela border concept (bottom)
          Container(
            height: 4,
            width: double.infinity,
            color: const Color(0xFFFFB300),
          ),
        ],
      ),
    );
  }
}
