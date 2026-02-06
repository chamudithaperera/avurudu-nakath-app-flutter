import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/nakath_event.dart';
import '../mappers/nakath_localizer.dart';
import 'countdown_timer.dart';
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class NakathDetailPopup extends StatelessWidget {
  final NakathEvent event;

  const NakathDetailPopup({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final uiL10n = UiLocalizations.of(context)!;
    final title = event.getLocalizedTitle(context);
    final description = event.getLocalizedDescription(context);

    String formattedTime = '';
    if (event.start != null) {
      formattedTime = DateFormat('yyyy-MM-dd hh:mm a').format(event.start!);
      if (event.end != null) {
        final endTime = DateFormat('hh:mm a').format(event.end!);
        formattedTime += ' to $endTime';
      }
    } else {
      formattedTime = event.date ?? '';
    }

    final targetTime =
        event.start ??
        (event.date != null ? DateTime.tryParse(event.date!) : null);
    final isFuture = targetTime != null && targetTime.isAfter(DateTime.now());

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8EED1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFC99A3B),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decorative Header with Gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFC99A3B),
                          Color(0xFF8C1B1B),
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF2B1B16), width: 2),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.wb_sunny_rounded,
                          size: 48,
                          color: Color(0xFFFFF7E6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFFF7E6),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content Body
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Countdown Section (If Future)
                        if (isFuture) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7E6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(
                                  0xFF2B1B16,
                                ).withValues(alpha: 0.2),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  uiL10n.nextUpcoming.toUpperCase(),
                                  style: GoogleFonts.cinzel(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF8C1B1B),
                                    letterSpacing: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CountdownTimer(targetTime: targetTime),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Time Detail Row
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC99A3B).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(
                                0xFFC99A3B,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                color: Color(0xFF8C1B1B),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  formattedTime,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF4E2A1E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        const SizedBox(height: 8),
                        Divider(
                          color: const Color(0xFF2B1B16).withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: 24),

                        // Description Text
                        Text(
                          description,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            height: 1.7,
                            color: const Color(0xFF2B1B16),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B1B16),
                          foregroundColor: const Color(0xFFFFF7E6),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: Color(0xFFC99A3B),
                              width: 1.4,
                            ),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          uiL10n.close.toUpperCase(),
                          style: GoogleFonts.cinzel(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Decorative Emblem
          Positioned(
            top: -12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFC99A3B),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2B1B16), width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
