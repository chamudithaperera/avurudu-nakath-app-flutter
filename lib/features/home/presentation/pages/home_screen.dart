import 'dart:async';

import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          uiL10n.appTitle,
                          style: const TextStyle(
                            fontFamily: 'KDNAMAL',
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFABF24),
                            shadows: [
                              Shadow(
                                offset: Offset(-1.4, -1.4),
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: Offset(1.4, -1.4),
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: Offset(-1.4, 1.4),
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: Offset(1.4, 1.4),
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: Offset(0, 6),
                                blurRadius: 12,
                                color: Color(0x66000000),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _NextNakathCard(
                      event: nextEvent,
                      formattedDate: _formatDateLabel(context, nextEvent),
                      onTap: () => _showNakathDetail(nextEvent),
                    ),
                    const SizedBox(height: 24),
                    _SectionHeader(title: uiL10n.allNakath),
                    const SizedBox(height: 16),
                    ...List.generate(otherEvents.length, (index) {
                      final event = otherEvents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _NakathEventTile(
                          event: event,
                          dateLabel: _formatDateLabel(context, event),
                          iconAssetPath:
                              'assets/images/nakath icons/nakath${(index % 8) + 1}.png',
                          onTap: () => _showNakathDetail(event),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NextNakathCard extends StatelessWidget {
  final NakathEvent event;
  final String formattedDate;
  final VoidCallback onTap;

  const _NextNakathCard({
    required this.event,
    required this.formattedDate,
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
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFBBF24),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF15130E), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -38,
                top: 18,
                bottom: 18,
                child: Opacity(
                  opacity: 0.17,
                  child: Image.asset(
                    'assets/images/erabadu.png',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDED),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFF111111),
                            width: 1.8,
                          ),
                        ),
                        child: Text(
                          uiL10n.nextUpcoming,
                          style: const TextStyle(
                            fontFamily: 'TharuSansala',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5F433A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      event.getLocalizedTitle(context),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'TharuMahee',
                        fontSize: 50,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF060504),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isFuture)
                      _HomeCountdown(targetTime: targetTime.toLocal())
                    else
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontFamily: 'GemunuX',
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3F2C23),
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

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF7A6945).withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'TharuMahee',
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: Color(0xFF080603),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF7A6945).withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(6),
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
  final VoidCallback onTap;

  const _NakathEventTile({
    required this.event,
    required this.dateLabel,
    required this.iconAssetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1E2AC),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFA69169), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF90774E),
                    width: 2.2,
                  ),
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.getLocalizedTitle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'TharuMahee',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        color: Color(0xFF5E463F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dateLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'GemunuX',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5E463F),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFB4A071),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 22,
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

  const _HomeCountdown({required this.targetTime});

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
          ),
        ),
        const _CountdownDivider(),
        Expanded(
          child: _CountdownUnit(
            value: hours.toString().padLeft(2, '0'),
            label: uiL10n.hours,
          ),
        ),
        const _CountdownDivider(),
        Expanded(
          child: _CountdownUnit(
            value: minutes.toString().padLeft(2, '0'),
            label: uiL10n.minutes,
          ),
        ),
        const _CountdownDivider(),
        Expanded(
          child: _CountdownUnit(
            value: seconds.toString().padLeft(2, '0'),
            label: uiL10n.seconds,
          ),
        ),
      ],
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  final String value;
  final String label;

  const _CountdownUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE7E7E7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF111111), width: 1.6),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'GemunuX',
              fontSize: 38,
              height: 1.0,
              fontWeight: FontWeight.w700,
              color: Color(0xFF62463E),
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'TharuSansala',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B0907),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CountdownDivider extends StatelessWidget {
  const _CountdownDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 4, right: 4, bottom: 30),
      child: Text(
        ':',
        style: TextStyle(
          fontFamily: 'GemunuX',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0B0907),
        ),
      ),
    );
  }
}
