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
        Positioned.fill(
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/parchment_texture.png',
              fit: BoxFit.cover,
              color: const Color(0xFFBFA47A),
              colorBlendMode: BlendMode.softLight,
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -120,
          child: Opacity(
            opacity: 0.12,
            child: Image.asset('assets/images/lotus_mandala.png', width: 320),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -140,
          child: Opacity(
            opacity: 0.12,
            child: Image.asset('assets/images/lotus_mandala.png', width: 340),
          ),
        ),
        Positioned(
          top: 40,
          left: -20,
          child: Opacity(
            opacity: 0.15,
            child: Image.asset('assets/images/sun.png', width: 160),
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
