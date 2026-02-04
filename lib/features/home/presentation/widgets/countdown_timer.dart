import 'dart:async';
import 'package:flutter/material.dart';
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;

  const CountdownTimer({super.key, required this.targetTime});

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
          'Auspicious Time Started!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
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
                Color(0xFFFFB300), // Amber
                Color(0xFFFF6F00), // Deep Orange
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          constraints: const BoxConstraints(minWidth: 46),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5D4037),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 16),
      child: const Text(
        ':',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3E2723),
        ),
      ),
    );
  }
}
