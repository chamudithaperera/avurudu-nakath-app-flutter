import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/nakath_event.dart';
import '../mappers/nakath_localizer.dart';
import 'countdown_timer.dart';
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';

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
              color: const Color(0xFFFFFDE7), // Light Cream Background
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF3E2723), // Deep Brown Border
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
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
                          Color(0xFFFFECB3), // Light Amber
                          Color(0xFFFFD54F), // Amber
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF3E2723), width: 2),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.wb_sunny_rounded,
                          size: 48,
                          color: Color(0xFFE65100),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                            letterSpacing: 0.5,
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(
                                  0xFF3E2723,
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
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF8D6E63),
                                    letterSpacing: 1.2,
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
                            color: const Color(
                              0xFFFFB300,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(
                                0xFFFFB300,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                color: Color(0xFFBF360C),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  formattedTime,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF4E342E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Traditional Liyawela Divider
                        Image.asset(
                          'assets/images/liyawela_border.png',
                          height: 40,
                          color: const Color(0xFF3E2723).withValues(alpha: 0.6),
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),

                        // Description Text
                        Text(
                          description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Color(0xFF3E2723),
                            letterSpacing: 0.2,
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
                          backgroundColor: const Color(0xFF3E2723),
                          foregroundColor: const Color(0xFFFFF8E1),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          uiL10n.close.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
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
                color: const Color(0xFFFFB300),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3E2723), width: 2.5),
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
