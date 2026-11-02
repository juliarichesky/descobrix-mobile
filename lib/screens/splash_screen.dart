import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 680;

            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _SplashBackgroundPainter()),
                ),
                Column(
                  children: [
                    Expanded(
                      flex: compact ? 6 : 7,
                      child: Padding(
                        padding: EdgeInsets.only(top: compact ? 22 : 44),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: compact ? 82 : 96,
                              height: compact ? 76 : 88,
                              child: const CustomPaint(painter: _AtomPainter()),
                            ),
                            SizedBox(height: compact ? 6 : 10),
                            Text(
                              'Descobrix',
                              style: textTheme.displayLarge?.copyWith(
                                fontSize: compact ? 30 : 34,
                                letterSpacing: -1.1,
                              ),
                            ),
                            SizedBox(height: compact ? 8 : 12),
                            Text(
                              'Explore. Descubra.\nColecione. Desafie.',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: AppColors.navy,
                                fontSize: compact ? 14 : 15,
                                height: 1.38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: compact ? 5 : 6,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const CustomPaint(painter: _OceanPainter()),
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: compact ? 16 : 28,
                            child: Column(
                              children: [
                                AppButton(
                                  label: 'Entrar',
                                  variant: AppButtonVariant.navy,
                                  onPressed: () {},
                                ),
                                const SizedBox(height: 12),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: AppColors.blue,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: AppButton(
                                    label: 'Criar conta',
                                    variant: AppButtonVariant.outline,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AtomPainter extends CustomPainter {
  const _AtomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final orbits = [
      (angle: -0.58, color: AppColors.pink),
      (angle: 0.58, color: AppColors.blue),
      (angle: math.pi / 2, color: AppColors.navySoft),
    ];

    for (final orbit in orbits) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(orbit.angle);
      orbitPaint.color = orbit.color;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.width * 0.94,
          height: size.height * 0.36,
        ),
        orbitPaint,
      );
      canvas.restore();
    }

    canvas.drawCircle(
      center,
      size.shortestSide * 0.105,
      Paint()..color = AppColors.pink,
    );
    canvas.drawCircle(
      center,
      size.shortestSide * 0.16,
      Paint()
        ..color = AppColors.pinkLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _AtomPainter oldDelegate) => false;
}

class _SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.background);

    final pinkGlow = Paint()..color = const Color(0x18F45B95);
    final blueGlow = Paint()..color = const Color(0x122D9BD5);
    canvas.drawCircle(
      Offset(size.width * 0.07, size.height * 0.47),
      size.width * 0.26,
      pinkGlow,
    );
    canvas.drawCircle(
      Offset(size.width * 0.94, size.height * 0.50),
      size.width * 0.27,
      pinkGlow,
    );
    canvas.drawCircle(
      Offset(size.width * 0.83, size.height * 0.63),
      size.width * 0.3,
      blueGlow,
    );
  }

  @override
  bool shouldRepaint(covariant _SplashBackgroundPainter oldDelegate) => false;
}

class _OceanPainter extends CustomPainter {
  const _OceanPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final oceanTop = size.height * 0.30;
    final oceanRect = Rect.fromLTWH(0, oceanTop, size.width, size.height);
    canvas.drawRect(
      oceanRect,
      Paint()..shader = AppColors.oceanGradient.createShader(oceanRect),
    );

    _drawWave(
      canvas,
      size,
      y: size.height * 0.28,
      amplitude: 14,
      color: const Color(0xFFFFD8E6),
      fillBelow: true,
    );
    _drawWave(
      canvas,
      size,
      y: size.height * 0.39,
      amplitude: 11,
      color: const Color(0xFFBCEBF6),
      fillBelow: true,
    );
    _drawWave(
      canvas,
      size,
      y: size.height * 0.54,
      amplitude: 10,
      color: const Color(0xFF83C8EA),
      fillBelow: true,
    );
    _drawWave(
      canvas,
      size,
      y: size.height * 0.72,
      amplitude: 8,
      color: const Color(0xFF54A8DD),
      fillBelow: false,
    );
    _drawSubmarine(canvas, size, Offset(size.width * 0.5, size.height * 0.30));
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double y,
    required double amplitude,
    required Color color,
    required bool fillBelow,
  }) {
    final path = Path()..moveTo(0, y);
    path.cubicTo(
      size.width * 0.16,
      y - amplitude,
      size.width * 0.28,
      y + amplitude,
      size.width * 0.46,
      y,
    );
    path.cubicTo(
      size.width * 0.65,
      y - amplitude,
      size.width * 0.78,
      y + amplitude,
      size.width,
      y,
    );

    if (fillBelow) {
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, Paint()..color = color);
    } else {
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  void _drawSubmarine(Canvas canvas, Size size, Offset center) {
    final scale = math.min(size.width / 360, size.height / 240);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    final hull = Path()
      ..moveTo(-91, 2)
      ..cubicTo(-82, -16, 70, -19, 91, 2)
      ..cubicTo(83, 17, -71, 20, -91, 2)
      ..close();
    canvas.drawPath(hull, Paint()..color = AppColors.navy);
    canvas.drawPath(
      hull,
      Paint()
        ..color = const Color(0xFF436A9C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    final top = Path()
      ..moveTo(-60, -8)
      ..cubicTo(-27, -26, 39, -26, 66, -7)
      ..cubicTo(40, -1, -30, 0, -60, -8)
      ..close();
    canvas.drawPath(top, Paint()..color = const Color(0xFF315982));

    final conningTower = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-18, -35, 36, 25),
      const Radius.circular(5),
    );
    canvas.drawRRect(conningTower, Paint()..color = AppColors.navy);
    canvas.drawRect(
      const Rect.fromLTWH(-11, -43, 3, 9),
      Paint()..color = AppColors.navy,
    );
    canvas.drawRect(
      const Rect.fromLTWH(7, -43, 3, 9),
      Paint()..color = AppColors.navy,
    );
    canvas.drawLine(
      const Offset(-11, -43),
      const Offset(-7, -47),
      Paint()
        ..color = AppColors.navy
        ..strokeWidth = 2,
    );

    final windowPaint = Paint()..color = AppColors.blue;
    for (final x in [-43.0, -20.0, 3.0, 26.0]) {
      canvas.drawCircle(Offset(x, -4), 3.2, windowPaint);
    }
    canvas.drawPath(
      Path()
        ..moveTo(78, -5)
        ..lineTo(100, -14)
        ..lineTo(94, 6)
        ..close(),
      Paint()..color = AppColors.pink,
    );
    canvas.drawPath(
      Path()
        ..moveTo(-71, -3)
        ..lineTo(-92, -13)
        ..lineTo(-84, 7)
        ..close(),
      Paint()..color = AppColors.blueDeep,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OceanPainter oldDelegate) => false;
}
