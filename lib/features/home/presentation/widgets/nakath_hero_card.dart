import 'package:flutter/material.dart';
import '../../domain/entities/nakath_event.dart';
import '../mappers/nakath_localizer.dart';
import 'countdown_timer.dart';
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';

class NakathHeroCard extends StatelessWidget {
  final NakathEvent event;
  final VoidCallback onTap;

  const NakathHeroCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final uiL10n = UiLocalizations.of(context)!;
    final title = event.getLocalizedTitle(context);

    final targetTime =
        event.start ??
        (event.date != null ? DateTime.tryParse(event.date!) : null);
    final isFuture = targetTime != null && targetTime.isAfter(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3E2723), // Deep Brown
                  Color(0xFF5D4037), // Lighter Brown
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFFFA000), // Gold
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Decorative Motif Background
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'assets/images/lotus_mandala.png',
                      width: 150,
                      color: Colors.white,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFA000),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              uiL10n.nextUpcoming.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF3E2723),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.wb_sunny_rounded,
                            color: Color(0xFFFFA000),
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isFuture) ...[
                        const Text(
                          'COUNTDOWN',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CountdownTimer(targetTime: targetTime),
                      ] else ...[
                        Text(
                          event.date ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Decorative Liyawela Border at the bottom
                      Center(
                        child: Image.asset(
                          'assets/images/liyawela_border.png',
                          width: double.infinity,
                          height: 30,
                          color: const Color(0xFFFFA000).withOpacity(0.5),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
