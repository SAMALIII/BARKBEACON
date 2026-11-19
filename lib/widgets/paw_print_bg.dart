import 'package:flutter/material.dart';

/// Wrap any screen body with this to get the subtle paw-print background.
///
/// Usage:
///   Scaffold(
///     body: PawBackground(
///       child: SafeArea(child: ...),
///     ),
///   )
class PawBackground extends StatelessWidget {
  final Widget child;
  final Color color;
  final double opacity;

  const PawBackground({
    super.key,
    required this.child,
    this.color = const Color(0xFF142B52), // navy
    this.opacity = 0.06,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: CustomPaint(
            painter: PawPatternPainter(color: color.withOpacity(opacity)),
          ),
        ),
        child,
      ],
    );
  }
}

/// Repeating, slightly rotated paw prints.
class PawPatternPainter extends CustomPainter {
  final Color color;
  const PawPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double spacing = 96;
    const double pawSize = 28;
    final paw = PawPainter(color: color);

    int row = 0;
    for (double y = 24; y < size.height + spacing; y += spacing, row++) {
      final xShift = row.isEven ? 0.0 : spacing / 2;
      int col = 0;
      for (double x = xShift + 20;
          x < size.width + spacing;
          x += spacing, col++) {
        final angle = (((row * 3 + col * 5) % 7) - 3) * 0.18;
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(angle);
        canvas.translate(-pawSize / 2, -pawSize / 2);
        paw.paint(canvas, const Size(pawSize, pawSize));
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant PawPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// A single solid paw print (also used for the profile avatar).
class PawPainter extends CustomPainter {
  final Color color;
  const PawPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    void toe(double cx, double cy, double tw, double th, double angle) {
      canvas.save();
      canvas.translate(cx * w, cy * h);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: tw * w,
          height: th * h,
        ),
        paint,
      );
      canvas.restore();
    }

    // Four toes
    toe(0.14, 0.45, 0.20, 0.30, -0.50);
    toe(0.36, 0.17, 0.21, 0.32, -0.12);
    toe(0.64, 0.17, 0.21, 0.32, 0.12);
    toe(0.86, 0.45, 0.20, 0.30, 0.50);

    // Main pad
    final pad = Path()
      ..moveTo(0.50 * w, 0.42 * h)
      ..cubicTo(0.62 * w, 0.42 * h, 0.70 * w, 0.55 * h, 0.80 * w, 0.66 * h)
      ..cubicTo(0.90 * w, 0.77 * h, 0.86 * w, 0.92 * h, 0.70 * w, 0.93 * h)
      ..cubicTo(0.60 * w, 0.94 * h, 0.55 * w, 0.88 * h, 0.50 * w, 0.88 * h)
      ..cubicTo(0.45 * w, 0.88 * h, 0.40 * w, 0.94 * h, 0.30 * w, 0.93 * h)
      ..cubicTo(0.14 * w, 0.92 * h, 0.10 * w, 0.77 * h, 0.20 * w, 0.66 * h)
      ..cubicTo(0.30 * w, 0.55 * h, 0.38 * w, 0.42 * h, 0.50 * w, 0.42 * h)
      ..close();
    canvas.drawPath(pad, paint);
  }

  @override
  bool shouldRepaint(covariant PawPainter oldDelegate) =>
      oldDelegate.color != color;
}

