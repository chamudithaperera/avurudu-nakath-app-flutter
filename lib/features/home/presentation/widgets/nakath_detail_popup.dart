import 'dart:async';

import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/nakath_event.dart';
import '../mappers/nakath_localizer.dart';

class NakathDetailPopup extends StatelessWidget {
  final NakathEvent event;

  const NakathDetailPopup({super.key, required this.event});

  DateTime? _targetTime() {
    if (event.start != null) {
      return event.start;
    }
    if (event.date != null) {
      return DateTime.tryParse('${event.date!}T00:00:00');
    }
    return null;
  }

  String _popupImagePath() {
    final id = event.id;
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

  String _formatMoment(BuildContext context, DateTime value) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final local = value.toLocal();
    final date = DateFormat('yyyy-MM-dd').format(local);
    final time = DateFormat('h:mm').format(local);
    final period = switch (localeCode) {
      'si' => local.hour < 12 ? 'පෙ.ව.' : 'ප.ව.',
      'ta' => local.hour < 12 ? 'மு.ப.' : 'பி.ப.',
      _ => local.hour < 12 ? 'AM' : 'PM',
    };
    return '$date  $period $time';
  }

  String _formattedTimeText(BuildContext context) {
    final start = _targetTime();
    if (start == null) return '';
    return _formatMoment(context, start);
  }

  @override
  Widget build(BuildContext context) {
    final uiL10n = UiLocalizations.of(context)!;
    final title = event.getLocalizedTitle(context);
    final description = event.getLocalizedDescription(context);
    final scale = (MediaQuery.sizeOf(context).width / 390).clamp(0.85, 1.08);
    final targetTime = _targetTime();
    final formattedTime = _formattedTimeText(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 22 * scale,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 820 * scale, maxWidth: 520),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1E2AC),
            borderRadius: BorderRadius.circular(28 * scale),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 24,
                offset: Offset(0, 14 * scale),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26 * scale),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                22 * scale,
                28 * scale,
                22 * scale,
                24 * scale,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 156 * scale,
                    height: 156 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF9F8353),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _popupImagePath(),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: const Color(0xFFD5C495),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Color(0xFF7A6945),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18 * scale),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'TharuMahee',
                      fontSize: 28 * scale,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5A423A),
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 6 * scale),
                  Text(
                    formattedTime,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'GemunuX',
                      fontSize: 24 * scale,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5A423A),
                    ),
                  ),
                  SizedBox(height: 16 * scale),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      14 * scale,
                      14 * scale,
                      14 * scale,
                      10 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24),
                      borderRadius: BorderRadius.circular(22 * scale),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 14,
                          offset: Offset(0, 8 * scale),
                        ),
                      ],
                    ),
                    child: _PopupCountdown(
                      targetTime: targetTime,
                      scale: scale,
                      labels: (
                        uiL10n.days,
                        uiL10n.hours,
                        uiL10n.minutes,
                        uiL10n.seconds,
                      ),
                    ),
                  ),
                  SizedBox(height: 18 * scale),
                  Text(
                    description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'TharuSansala',
                      fontSize: 21 * scale,
                      fontWeight: FontWeight.w700,
                      height: 1.26,
                      color: const Color(0xFF080603),
                    ),
                  ),
                  SizedBox(height: 28 * scale),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B4A3D),
                        foregroundColor: Colors.white,
                        elevation: 7,
                        shadowColor: Colors.black54,
                        padding: EdgeInsets.symmetric(vertical: 14 * scale),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18 * scale),
                        ),
                      ),
                      child: Text(
                        uiL10n.close,
                        style: TextStyle(
                          fontFamily: 'TharuSansala',
                          fontSize: 30 * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PopupCountdown extends StatefulWidget {
  final DateTime? targetTime;
  final double scale;
  final (String, String, String, String) labels;

  const _PopupCountdown({
    required this.targetTime,
    required this.scale,
    required this.labels,
  });

  @override
  State<_PopupCountdown> createState() => _PopupCountdownState();
}

class _PopupCountdownState extends State<_PopupCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  @override
  void didUpdateWidget(covariant _PopupCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetTime != widget.targetTime) {
      _update();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _update() {
    if (!mounted) return;
    final target = widget.targetTime;
    if (target == null) {
      setState(() => _remaining = Duration.zero);
      return;
    }
    final diff = target.toLocal().difference(DateTime.now());
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;
    final scale = widget.scale;
    final labels = widget.labels;

    return Row(
      children: [
        Expanded(
          child: _PopupCountdownUnit(
            value: days.toString().padLeft(2, '0'),
            label: labels.$1,
            scale: scale,
          ),
        ),
        _PopupDivider(scale: scale),
        Expanded(
          child: _PopupCountdownUnit(
            value: hours.toString().padLeft(2, '0'),
            label: labels.$2,
            scale: scale,
          ),
        ),
        _PopupDivider(scale: scale),
        Expanded(
          child: _PopupCountdownUnit(
            value: minutes.toString().padLeft(2, '0'),
            label: labels.$3,
            scale: scale,
          ),
        ),
        _PopupDivider(scale: scale),
        Expanded(
          child: _PopupCountdownUnit(
            value: seconds.toString().padLeft(2, '0'),
            label: labels.$4,
            scale: scale,
          ),
        ),
      ],
    );
  }
}

class _PopupCountdownUnit extends StatelessWidget {
  final String value;
  final String label;
  final double scale;

  const _PopupCountdownUnit({
    required this.value,
    required this.label,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 62 * scale,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(16 * scale),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'GemunuX',
                fontSize: 34 * scale,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF654941),
                height: 1,
              ),
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
                fontFamily: 'TharuSansala',
                fontSize: 24 * scale,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopupDivider extends StatelessWidget {
  final double scale;

  const _PopupDivider({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4 * scale,
        right: 4 * scale,
        bottom: 28 * scale,
      ),
      child: Text(
        ':',
        style: TextStyle(
          fontFamily: 'GemunuX',
          fontSize: 30 * scale,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
