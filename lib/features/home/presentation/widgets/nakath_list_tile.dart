import 'package:flutter/material.dart';
import '../../domain/entities/nakath_event.dart';

class NakathListTile extends StatelessWidget {
  final NakathEvent event;
  final VoidCallback onTap;

  const NakathListTile({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD7CCC8), // Light Brown
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon / Type indicator
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1), // Pale Amber
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Color(0xFFFFB300),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.titleKey, // Placeholder
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.start != null
                            ? event.start.toString()
                            : (event.date ?? ''),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron
                const Icon(Icons.chevron_right, color: Color(0xFFA1887F)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
