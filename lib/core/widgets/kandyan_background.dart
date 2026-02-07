import 'package:flutter/material.dart';

class KandyanBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const KandyanBackground({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2B1B16),
                  Color(0xFF4E2A1E),
                  Color(0xFF7A2E22),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -140,
          right: -140,
          child: Opacity(
            opacity: 0.2,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFFC99A3B), Color(0x002B1B16)],
                  radius: 0.7,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -160,
          left: -160,
          child: Opacity(
            opacity: 0.2,
            child: Container(
              width: 340,
              height: 340,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF8C1B1B), Color(0x002B1B16)],
                  radius: 0.7,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: -20,
          child: Opacity(
            opacity: 0.18,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC99A3B), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x99C99A3B),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.wb_sunny_rounded,
                  size: 68,
                  color: Color(0xFFC99A3B),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            padding: padding,
            child: child,
          ),
        ),
      ],
    );
  }
}
