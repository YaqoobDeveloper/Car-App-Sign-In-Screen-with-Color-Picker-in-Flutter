import 'dart:math' as math;

import 'package:flutter/material.dart';

class CarIllustration extends StatelessWidget {
  const CarIllustration({super.key, this.width = 310, this.height = 128});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const CustomPaint(painter: _CarPainter()),
    );
  }
}

class _CarPainter extends CustomPainter {
  const _CarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    Offset at(double x, double y) => Offset(x * w, y * h);

    const groundY = 0.80;
    final wheelR = h * 0.19;

    canvas.drawOval(
      Rect.fromCenter(
        center: at(0.5, groundY + 0.07),
        width: w * 0.96,
        height: h * 0.12,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final body = Path()
      ..moveTo(w * 0.03, h * 0.76)
      ..lineTo(w * 0.02, h * 0.56)
      ..quadraticBezierTo(w * 0.03, h * 0.44, w * 0.12, h * 0.42)
      ..lineTo(w * 0.25, h * 0.38)
      ..cubicTo(w * 0.34, h * 0.14, w * 0.42, h * 0.08, w * 0.56, h * 0.09)
      ..cubicTo(w * 0.64, h * 0.10, w * 0.70, h * 0.26, w * 0.76, h * 0.35)
      ..lineTo(w * 0.94, h * 0.43)
      ..quadraticBezierTo(w * 0.99, h * 0.46, w * 0.985, h * 0.60)
      ..lineTo(w * 0.97, h * 0.76)
      ..close();

    canvas.drawPath(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6A6C73), Color(0xFF2E2F35), Color(0xFF17181C)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(Offset.zero & size),
    );

    canvas.drawLine(
      at(0.07, 0.50),
      at(0.95, 0.51),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..strokeWidth = 1.2,
    );

    final glass = Path()
      ..moveTo(w * 0.29, h * 0.38)
      ..cubicTo(w * 0.36, h * 0.20, w * 0.43, h * 0.15, w * 0.555, h * 0.155)
      ..cubicTo(w * 0.62, h * 0.16, w * 0.67, h * 0.28, w * 0.705, h * 0.36)
      ..close();

    canvas
      ..drawPath(
        glass,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3C4048), Color(0xFF101115)],
          ).createShader(glass.getBounds()),
      )
      ..drawLine(
        at(0.50, 0.15),
        at(0.50, 0.38),
        Paint()
          ..color = const Color(0xFF26272C)
          ..strokeWidth = w * 0.012,
      )
      ..drawLine(
        at(0.50, 0.40),
        at(0.51, 0.72),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.35)
          ..strokeWidth = 1,
      )
      ..drawRRect(
        RRect.fromLTRBR(
          w * 0.905,
          h * 0.455,
          w * 0.975,
          h * 0.505,
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFFEFF3F8),
      )
      ..drawRRect(
        RRect.fromLTRBR(
          w * 0.022,
          h * 0.47,
          w * 0.06,
          h * 0.53,
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFD8423A),
      );

    final spoke = Paint()
      ..color = const Color(0xFF3A3B40)
      ..strokeWidth = wheelR * 0.12
      ..strokeCap = StrokeCap.round;

    for (final x in [0.215, 0.795]) {
      final c = at(x, groundY - 0.19);
      canvas
        ..drawCircle(c, wheelR * 1.14, Paint()..color = const Color(0xFF0C0D0F))
        ..drawCircle(c, wheelR, Paint()..color = const Color(0xFF16171A))
        ..drawCircle(
          c,
          wheelR * 0.64,
          Paint()
            ..shader = const RadialGradient(
              colors: [Color(0xFFB8BAC0), Color(0xFF6E7077)],
            ).createShader(Rect.fromCircle(center: c, radius: wheelR * 0.64)),
        );
      for (var i = 0; i < 5; i++) {
        final angle = i * 2 * math.pi / 5 - math.pi / 2;
        canvas.drawLine(
          c,
          c + Offset(math.cos(angle), math.sin(angle)) * wheelR * 0.56,
          spoke,
        );
      }
      canvas.drawCircle(
        c,
        wheelR * 0.18,
        Paint()..color = const Color(0xFF26272C),
      );
    }
  }

  @override
  bool shouldRepaint(_CarPainter oldDelegate) => false;
}
