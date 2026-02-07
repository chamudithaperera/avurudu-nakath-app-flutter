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
        const Positioned.fill(child: ColoredBox(color: Color(0xFFFDEE94))),
        Positioned(
          top: -68,
          left: -76,
          child: Opacity(
            opacity: 0.33,
            child: Image.asset(
              'assets/images/sun.png',
              width: 230,
              height: 230,
            ),
          ),
        ),
        Positioned(
          top: 92,
          right: -36,
          child: Opacity(
            opacity: 0.28,
            child: Image.asset('assets/images/erabadu.png', width: 210),
          ),
        ),
        Positioned(
          bottom: 192,
          left: -28,
          child: Opacity(
            opacity: 0.16,
            child: Image.asset('assets/images/Kiribath.png', width: 120),
          ),
        ),
        Positioned(
          bottom: 4,
          left: -14,
          child: Opacity(
            opacity: 0.22,
            child: Image.asset('assets/images/Kiribath.png', width: 122),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('assets/images/panchagame.png', width: 148),
            ),
          ),
        ),
        Positioned(
          bottom: -4,
          right: -18,
          child: Opacity(
            opacity: 0.22,
            child: Image.asset('assets/images/sweets.png', width: 136),
          ),
        ),
        Positioned.fill(
          child: Padding(padding: padding, child: child),
        ),
      ],
    );
  }
}
