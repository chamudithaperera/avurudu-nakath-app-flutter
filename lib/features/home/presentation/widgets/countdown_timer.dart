import 'dart:async';
import 'package:flutter/material.dart';
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;
  final Color? labelColor;

  const CountdownTimer({super.key, required this.targetTime, this.labelColor});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    setState(() {
      _timeLeft = widget.targetTime.difference(now);
      if (_timeLeft.isNegative) {
        _timer.cancel();
        _timeLeft = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft <= Duration.zero) {
      return Center(
        child: Text(
          'Auspicious Time Begun',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    final uiL10n = UiLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeUnit(days.toString().padLeft(2, '0'), uiL10n.days),
        _buildDivider(),
        _buildTimeUnit(hours.toString().padLeft(2, '0'), uiL10n.hours),
        _buildDivider(),
        _buildTimeUnit(minutes.toString().padLeft(2, '0'), uiL10n.minutes),
        _buildDivider(),
        _buildTimeUnit(seconds.toString().padLeft(2, '0'), uiL10n.seconds),
      ],
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFC99A3B),
                Color(0xFF8C1B1B),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFFFF7E6), width: 1),
          ),
          constraints: const BoxConstraints(minWidth: 46),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFFF7E6),
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'GemunuX',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: widget.labelColor ?? const Color(0xFFE9D5A8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 20),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color:
              widget.labelColor?.withValues(alpha: 0.8) ??
              const Color(0xFFE9D5A8),
        ),
      ),
    );
  }
}
