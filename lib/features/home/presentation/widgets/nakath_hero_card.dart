import 'package:flutter/material.dart';
import '../../domain/entities/nakath_event.dart';
import 'countdown_timer.dart';

class NakathHeroCard extends StatelessWidget {
  final NakathEvent event;

  const NakathHeroCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // TODO: Use proper localization
    final title = event.titleKey; // Placeholder

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
                  'Next Auspicious Time',
                  style: TextStyle(
                    color: const Color(0xFF3E2723),
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
                if (event.start != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE0B2), // Light Orange
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CountdownTimer(
                      targetTime: event.start!,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE65100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.start.toString(), // TODO: Format date
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ] else ...[
                  Text(
                    event.date ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
