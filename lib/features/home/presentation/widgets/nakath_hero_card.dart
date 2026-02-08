import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:avurudu_nakath_app/core/theme/app_fonts.dart';
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

    String displayDate = event.date ?? '';
    if (displayDate.isEmpty && event.start != null) {
      displayDate = DateFormat('MMMM dd, yyyy').format(event.start!);
      if (event.start != null) {
        displayDate += ' • ${DateFormat('hh:mm a').format(event.start!)}';
      }
    }

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
                  Color(0xFFFFF7E6),
                  Color(0xFFF8EED1),
                  Color(0xFFF1D48E),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: const Color(0xFF8C1B1B), width: 2),
            ),
            child: Stack(
              children: [
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
                              color: const Color(0xFFC99A3B),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFFF7E6),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              uiL10n.nextUpcoming.toUpperCase(),
                              style: TextStyle(
                                fontFamily: AppFonts.localeAwareTextFamily(
                                  context,
                                ),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.wb_sunny_rounded,
                            color: Color(0xFFC99A3B),
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: AppFonts.localeAwareTextFamily(context),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isFuture) ...[
                        CountdownTimer(targetTime: targetTime),
                      ] else ...[
                        Text(
                          displayDate,
                          style: TextStyle(
                            fontFamily: AppFonts.localeAwareTextFamily(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      const SizedBox(height: 12),
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
