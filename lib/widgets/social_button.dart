import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Continue with $label',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: icon,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialPill extends StatelessWidget {
  const SocialPill({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Continue with $label',
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          side: const BorderSide(color: AppColors.border, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 34});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.22;
    final ring = (Offset.zero & size).deflate(stroke / 2);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    double rad(double degrees) => degrees * math.pi / 180;

    canvas
      ..drawArc(
        ring,
        rad(40),
        rad(80),
        false,
        arc..color = const Color(0xFF34A853),
      )
      ..drawArc(
        ring,
        rad(120),
        rad(95),
        false,
        arc..color = const Color(0xFFFBBC05),
      )
      ..drawArc(
        ring,
        rad(215),
        rad(90),
        false,
        arc..color = const Color(0xFFEA4335),
      )
      ..drawArc(
        ring,
        rad(305),
        rad(55),
        false,
        arc..color = const Color(0xFF4285F4),
      )
      ..drawRect(
        Rect.fromLTRB(
          size.width / 2,
          (size.height - stroke) / 2,
          size.width,
          (size.height + stroke) / 2,
        ),
        Paint()..color = const Color(0xFF4285F4),
      );
  }

  @override
  bool shouldRepaint(_GooglePainter oldDelegate) => false;
}

class FacebookLogo extends StatelessWidget {
  const FacebookLogo({super.key, this.size = 30});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'f',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.72,
          height: 1.25,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
