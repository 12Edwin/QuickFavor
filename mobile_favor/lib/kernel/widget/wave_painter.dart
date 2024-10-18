import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final BuildContext context;
  final double waveHeight;

  WavePainter({required this.context, required this.waveHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).primaryColor
      ..style = PaintingStyle.fill;

    final path = Path();

    path.lineTo(0, (size.height * 0.45) + waveHeight);
    path.quadraticBezierTo(
      size.width * 0.15,
      (size.height * 0.27) + waveHeight,
      size.width * 0.45,
      (size.height * 0.37) + waveHeight,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      (size.height * 0.5) + waveHeight,
      size.width * 1,
      (size.height * 0.35) + waveHeight,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}