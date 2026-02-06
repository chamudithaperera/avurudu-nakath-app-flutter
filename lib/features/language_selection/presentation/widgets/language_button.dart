import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final String label;
  final String subLabel; // Optional, maybe for English translation
  final VoidCallback onTap;
  final bool isSelected;

  const LanguageButton({
    super.key,
    required this.label,
    this.subLabel = '',
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8EED1),
                  Color(0xFFE8CC8A),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFC99A3B),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.6),
                  blurRadius: 12,
                  offset: const Offset(-4, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2B1B16),
                    letterSpacing: 1,
                  ),
                ),
                if (subLabel.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subLabel,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF4E2A1E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
