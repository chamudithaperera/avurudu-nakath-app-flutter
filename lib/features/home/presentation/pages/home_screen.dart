import 'dart:async';

import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/widgets/kandyan_background.dart';
import '../../data/datasources/nakath_local_data_source.dart';
import '../../data/repositories/nakath_repository_impl.dart';
import '../../domain/entities/nakath_event.dart';
import '../../domain/usecases/get_all_nakath_events.dart';
import '../mappers/nakath_localizer.dart';
import '../widgets/nakath_detail_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NakathEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    // DI Setup
    final dataSource = NakathLocalDataSourceImpl();
    final repository = NakathRepositoryImpl(localDataSource: dataSource);
    final useCase = GetAllNakathEvents(repository);

    _eventsFuture = useCase().then((events) async {
      // Schedule notifications when data is loaded
      final notificationService = NotificationService();
      await notificationService.init();
      await notificationService.requestPermissions();
      await notificationService.scheduleNotifications(events);
      return events;
    });
  }

  void _showNakathDetail(NakathEvent event) {
    showDialog(
      context: context,
      builder: (context) => NakathDetailPopup(event: event),
    );
  }

  DateTime? _eventMoment(NakathEvent event) {
    if (event.start != null) {
      return event.start;
    }
    if (event.date != null) {
      return DateTime.tryParse('${event.date!}T00:00:00');
    }
    return null;
  }

  String _formatDateLabel(BuildContext context, NakathEvent event) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final time = _eventMoment(event)?.toLocal();
    if (time == null) return '';

    final dateText = DateFormat('yyyy-MM-dd').format(time);
    if (event.start == null) return dateText;

    final timeText = DateFormat('h:mm').format(time);
    final period = switch (localeCode) {
      'si' => time.hour < 12 ? 'පෙ.ව.' : 'ප.ව.',
      'ta' => time.hour < 12 ? 'மு.ப.' : 'பி.ப.',
      _ => time.hour < 12 ? 'AM' : 'PM',
    };

    return '$dateText  $period $timeText';
  }

  @override
  Widget build(BuildContext context) {
    final uiL10n = UiLocalizations.of(context)!;
    final scale = (MediaQuery.sizeOf(context).width / 390).clamp(0.9, 1.08);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: KandyanBackground(
        child: FutureBuilder<List<NakathEvent>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFC99A3B)),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No nakath events found.', style: TextStyle()),
              );
            }

            final events = [...snapshot.data!]
              ..sort((first, second) {
                final firstMoment = _eventMoment(first);
                final secondMoment = _eventMoment(second);

                if (firstMoment == null && secondMoment == null) return 0;
                if (firstMoment == null) return 1;
                if (secondMoment == null) return -1;
                return firstMoment.compareTo(secondMoment);
              });

            final now = DateTime.now();
            final upcoming = events.where((event) {
              final eventTime = _eventMoment(event);
              return eventTime != null && eventTime.isAfter(now);
            }).toList();

            final nextEvent = upcoming.isNotEmpty
                ? upcoming.first
                : events.first;
            final otherEvents = events
                .where((event) => event.id != nextEvent.id)
                .toList();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                18 * scale,
                12 * scale,
                18 * scale,
                30 * scale,
              ),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              uiL10n.appTitle,
                              style: TextStyle(
                                fontFamily: AppFonts.kandyanDisplay,
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFABF24),
                                shadows: [
                                  Shadow(
                                    offset: Offset(-1.1, -1.1),
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(1.1, -1.1),
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(-1.1, 1.1),
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(1.1, 1.1),
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 8,
                                    color: Color(0x44000000),
                                  ),
                                ],
                              ).copyWith(fontSize: 42 * scale),
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * scale),
                        _NextNakathCard(
                          event: nextEvent,
                          formattedDate: _formatDateLabel(context, nextEvent),
                          scale: scale,
                          onTap: () => _showNakathDetail(nextEvent),
                        ),
                        SizedBox(height: 26 * scale),
                        _SectionHeader(title: uiL10n.allNakath, scale: scale),
                        SizedBox(height: 16 * scale),
                        ...List.generate(otherEvents.length, (index) {
                          final event = otherEvents[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12 * scale),
                            child: _NakathEventTile(
                              event: event,
                              dateLabel: _formatDateLabel(context, event),
                              iconAssetPath: _getNakathIconPath(event.id),
                              scale: scale,
                              onTap: () => _showNakathDetail(event),
                            ),
                          );
                        }),
                        SizedBox(height: 24 * scale),
                        Text(
                          'A Product of ChamXdev by Chamuditha Perera\n© Avurudu Nakath App - 2026',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12 * scale,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8D6E63), // Muted brown
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getNakathIconPath(String id) {
    if (id.contains('new_moon')) {
      return 'assets/images/nakath icons/nakath1.png';
    }
    if (id.contains('bathing_last_year')) {
      return 'assets/images/nakath icons/nakath2.png';
    }
    if (id.contains('punya_kalaya')) {
      return 'assets/images/nakath icons/nakath3.png';
    }
    if (id.contains('new_year_dawn')) {
      return 'assets/images/nakath icons/nakath4.png';
    }
    if (id.contains('cooking_food')) {
      return 'assets/images/nakath icons/nakath5.png';
    }
    if (id.contains('eating_working')) {
      return 'assets/images/nakath icons/nakath6.png';
    }
    if (id.contains('anointing_oil')) {
      return 'assets/images/nakath icons/nakath7.png';
    }
    if (id.contains('leaving_for_work')) {
      return 'assets/images/nakath icons/nakath8.png';
    }
    return 'assets/images/nakath icons/nakath1.png';
  }
}

class _NextNakathCard extends StatelessWidget {
  final NakathEvent event;
  final String formattedDate;
  final double scale;
  final VoidCallback onTap;

  const _NextNakathCard({
    required this.event,
    required this.formattedDate,
    required this.scale,
    required this.onTap,
  });

  DateTime? _targetTime() {
    if (event.start != null) return event.start;
    if (event.date != null) return DateTime.tryParse('${event.date!}T00:00:00');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final uiL10n = UiLocalizations.of(context)!;
    final targetTime = _targetTime();
    final isFuture = targetTime != null && targetTime.isAfter(DateTime.now());

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24 * scale),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFBBF24),
            borderRadius: BorderRadius.circular(24 * scale),
            border: Border.all(color: const Color(0xFF15130E), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 14 * scale,
                offset: Offset(0, 6 * scale),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -38,
                top: 14 * scale,
                bottom: 12 * scale,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/images/erabadu.png',
                    width: 140 * scale,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16 * scale,
                  16 * scale,
                  16 * scale,
                  18 * scale,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14 * scale,
                          vertical: 6 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDED),
                          borderRadius: BorderRadius.circular(18 * scale),
                          border: Border.all(
                            color: const Color(0xFF111111),
                            width: 1.3,
                          ),
                        ),
                        child: Text(
                          uiL10n.nextUpcoming,
                          style: TextStyle(
                            fontFamily: AppFonts.localeAwareTextFamily(context),
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5F433A),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16 * scale),
                    Text(
                      event.getLocalizedTitle(context),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.localeAwareTextFamily(context),
                        fontSize: 31 * scale,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF060504),
                      ),
                    ),
                    SizedBox(height: 16 * scale),
                    if (isFuture)
                      _HomeCountdown(
                        targetTime: targetTime.toLocal(),
                        scale: scale,
                      )
                    else
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontFamily: AppFonts.localeAwareTextFamily(context),
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3F2C23),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final double scale;

  const _SectionHeader({required this.title, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2.4 * scale,
            decoration: BoxDecoration(
              color: const Color(0xFF7A6945).withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(6 * scale),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14 * scale),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.localeAwareTextFamily(context),
              fontSize: 27 * scale,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF080603),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 2.4 * scale,
            decoration: BoxDecoration(
              color: const Color(0xFF7A6945).withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(6 * scale),
            ),
          ),
        ),
      ],
    );
  }
}

class _NakathEventTile extends StatelessWidget {
  final NakathEvent event;
  final String dateLabel;
  final String iconAssetPath;
  final double scale;
  final VoidCallback onTap;

  const _NakathEventTile({
    required this.event,
    required this.dateLabel,
    required this.iconAssetPath,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22 * scale),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: 14 * scale,
            vertical: 12 * scale,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF1E2AC),
            borderRadius: BorderRadius.circular(22 * scale),
            border: Border.all(color: const Color(0xFFA69169), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.13),
                blurRadius: 10 * scale,
                offset: Offset(0, 5 * scale),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58 * scale,
                height: 58 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF90774E), width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    iconAssetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: const Color(0xFFD5C495),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFF7A6945),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 13 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.getLocalizedTitle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.localeAwareTextFamily(context),
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: const Color(0xFF5E463F),
                      ),
                    ),
                    SizedBox(height: 6 * scale),
                    Text(
                      dateLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.localeAwareTextFamily(context),
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF5E463F),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10 * scale),
              Container(
                width: 30 * scale,
                height: 30 * scale,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFB4A071),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18 * scale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCountdown extends StatefulWidget {
  final DateTime targetTime;
  final double scale;

  const _HomeCountdown({required this.targetTime, required this.scale});

  @override
  State<_HomeCountdown> createState() => _HomeCountdownState();
}

class _HomeCountdownState extends State<_HomeCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  @override
  void didUpdateWidget(covariant _HomeCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetTime != widget.targetTime) {
      _updateRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    if (!mounted) return;
    final difference = widget.targetTime.difference(DateTime.now());
    setState(() {
      _remaining = difference.isNegative ? Duration.zero : difference;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uiL10n = UiLocalizations.of(context)!;
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return Row(
      children: [
        Expanded(
          child: _CountdownUnit(
            value: days.toString().padLeft(2, '0'),
            label: uiL10n.days,
            scale: widget.scale,
          ),
        ),
        _CountdownDivider(scale: widget.scale),
        Expanded(
          child: _CountdownUnit(
            value: hours.toString().padLeft(2, '0'),
            label: uiL10n.hours,
            scale: widget.scale,
          ),
        ),
        _CountdownDivider(scale: widget.scale),
        Expanded(
          child: _CountdownUnit(
            value: minutes.toString().padLeft(2, '0'),
            label: uiL10n.minutes,
            scale: widget.scale,
          ),
        ),
        _CountdownDivider(scale: widget.scale),
        Expanded(
          child: _CountdownUnit(
            value: seconds.toString().padLeft(2, '0'),
            label: uiL10n.seconds,
            scale: widget.scale,
          ),
        ),
      ],
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  final String value;
  final String label;
  final double scale;

  const _CountdownUnit({
    required this.value,
    required this.label,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 54 * scale,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE7E7E7),
            borderRadius: BorderRadius.circular(14 * scale),
            border: Border.all(color: const Color(0xFF111111), width: 1.2),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.localeAwareTextFamily(context),
              fontSize: 28 * scale,
              height: 1.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF62463E),
            ),
          ),
        ),
        SizedBox(height: 4 * scale),
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.localeAwareTextFamily(context),
                fontSize: 16 * scale,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0B0907),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CountdownDivider extends StatelessWidget {
  final double scale;

  const _CountdownDivider({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 3 * scale,
        right: 3 * scale,
        bottom: 19 * scale,
      ),
      child: Text(
        ':',
        style: TextStyle(
          fontFamily: AppFonts.localeAwareTextFamily(context),
          fontSize: 26 * scale,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0B0907),
        ),
      ),
    );
  }
}
