import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum SubmarinePieceKind { hull, tower, propeller, reactor, sonar, laboratory }

class SubmarinePiece {
  const SubmarinePiece({
    required this.name,
    required this.kind,
    required this.description,
    required this.unlocked,
  });

  final String name;
  final SubmarinePieceKind kind;
  final String description;
  final bool unlocked;
}

class SubmarineScreen extends StatelessWidget {
  const SubmarineScreen({super.key});

  static const List<SubmarinePiece> _pieces = <SubmarinePiece>[
    SubmarinePiece(
      name: 'Casco',
      kind: SubmarinePieceKind.hull,
      description: 'O casco protege o interior do submarino e ajuda a suportar a pressão da água.',
      unlocked: true,
    ),
    SubmarinePiece(
      name: 'Torre',
      kind: SubmarinePieceKind.tower,
      description: 'A torre abriga instrumentos de observação e comunicação do submarino.',
      unlocked: true,
    ),
    SubmarinePiece(
      name: 'Hélice',
      kind: SubmarinePieceKind.propeller,
      description:
          'A hélice transforma a rotação do motor em movimento para frente.',
      unlocked: true,
    ),
    SubmarinePiece(
      name: 'Reator',
      kind: SubmarinePieceKind.reactor,
      description: '',
      unlocked: false,
    ),
    SubmarinePiece(
      name: 'Sonar',
      kind: SubmarinePieceKind.sonar,
      description: '',
      unlocked: false,
    ),
    SubmarinePiece(
      name: 'Laboratório',
      kind: SubmarinePieceKind.laboratory,
      description: '',
      unlocked: false,
    ),
  ];

  int get _unlockedCount => _pieces.where((piece) => piece.unlocked).length;

  void _showPiece(BuildContext context, SubmarinePiece piece) {
    if (!piece.unlocked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Esta peça ainda não foi desbloqueada. Continue explorando o Descobrix!',
            ),
          ),
        );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(piece.name),
          content: Text(piece.description),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeader(context, textTheme),
              const SizedBox(height: 2),
              const _SubmarineIllustration(),
              const SizedBox(height: 4),
              _buildPieces(context, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme) {
    return SizedBox(
      height: 52,
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Voltar',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 36, height: 44),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
            color: AppColors.navy,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              'Meu submarino',
              style: textTheme.headlineMedium?.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '$_unlockedCount/6 peças',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieces(BuildContext context, TextTheme textTheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final cardWidth = (constraints.maxWidth - spacing * 3) / 4;
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: 14,
          children: <Widget>[
            for (final piece in _pieces)
              SizedBox(
                width: cardWidth,
                child: _PieceCard(
                  piece: piece,
                  textTheme: textTheme,
                  onTap: () => _showPiece(context, piece),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SubmarineIllustration extends StatelessWidget {
  const _SubmarineIllustration();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.42,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: const CustomPaint(painter: _SubmarinePainter()),
      ),
    );
  }
}

class _PieceCard extends StatelessWidget {
  const _PieceCard({
    required this.piece,
    required this.textTheme,
    required this.onTap,
  });

  final SubmarinePiece piece;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = piece.unlocked
        ? AppColors.blueDeep
        : AppColors.textDisabled;
    return Semantics(
      button: true,
      label: piece.unlocked
          ? '${piece.name}, desbloqueada'
          : '${piece.name}, bloqueada',
      hint: piece.unlocked
          ? 'Toque para ver a explicação da peça'
          : 'Toque para saber como desbloquear',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: <Widget>[
            Container(
              height: 68,
              decoration: BoxDecoration(
                color: piece.unlocked
                    ? AppColors.surface.withValues(alpha: 0.94)
                    : AppColors.surfaceMuted.withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: piece.unlocked
                      ? AppColors.blue.withValues(alpha: 0.25)
                      : AppColors.border.withValues(alpha: 0.8),
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x0A0E2A4D),
                    blurRadius: 7,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(44, 44),
                  painter: _PieceIconPainter(
                    kind: piece.kind,
                    color: foreground,
                    unlocked: piece.unlocked,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              piece.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: piece.unlocked ? AppColors.navy : AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmarinePainter extends CustomPainter {
  const _SubmarinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final background = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      background,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF9FCFD),
            Color(0xFFDFF3FA),
            Color(0xFFC4E8F3),
          ],
        ).createShader(background),
    );

    _drawWave(
      canvas,
      size,
      size.height * 0.24,
      size.height * 0.08,
      const Color(0xFFEAF8FC),
    );
    _drawWave(
      canvas,
      size,
      size.height * 0.49,
      size.height * 0.10,
      const Color(0xFFCBEAF4),
    );
    _drawWave(
      canvas,
      size,
      size.height * 0.77,
      size.height * 0.08,
      const Color(0xFFDDF3F8),
    );

    final bubblePaint = Paint()..color = const Color(0x66FFFFFF);
    for (final bubble in <Offset>[
      const Offset(42, 73),
      const Offset(75, 124),
      const Offset(250, 57),
      const Offset(287, 150),
    ]) {
      canvas.drawCircle(bubble, 2.5, bubblePaint);
    }

    _drawSubmarine(canvas, size);
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double y,
    double amplitude,
    Color color,
  ) {
    final path = Path()..moveTo(0, y);
    path.cubicTo(
      size.width * 0.16,
      y - amplitude,
      size.width * 0.31,
      y + amplitude,
      size.width * 0.5,
      y,
    );
    path.cubicTo(
      size.width * 0.69,
      y - amplitude,
      size.width * 0.84,
      y + amplitude,
      size.width,
      y,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawSubmarine(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 210);
    canvas.save();
    canvas.translate(size.width / 2, size.height * 0.54);
    canvas.scale(scale);

    final shadow = Paint()..color = const Color(0x220E4771);
    canvas.drawOval(const Rect.fromLTRB(-132, 24, 132, 49), shadow);

    final hull = Path()
      ..moveTo(-145, 0)
      ..cubicTo(-134, -35, -73, -48, 35, -43)
      ..cubicTo(91, -40, 129, -24, 145, 0)
      ..cubicTo(127, 28, 73, 43, -28, 42)
      ..cubicTo(-91, 42, -132, 27, -145, 0)
      ..close();
    canvas.drawPath(
      hull,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF3E87B3),
            Color(0xFF0D4E7C),
            Color(0xFF173D68),
          ],
        ).createShader(const Rect.fromLTRB(-145, -48, 145, 42)),
    );
    canvas.drawPath(
      hull,
      Paint()
        ..color = const Color(0xFF103D64)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    final rearModule = Path()
      ..moveTo(31, -39)
      ..cubicTo(81, -37, 119, -22, 135, 0)
      ..cubicTo(119, 20, 80, 35, 31, 40)
      ..close();
    canvas.drawPath(
      rearModule,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFFE6F4F7), Color(0xFF92C6D7)],
        ).createShader(const Rect.fromLTRB(31, -39, 135, 40)),
    );
    canvas.drawPath(
      rearModule,
      Paint()
        ..color = const Color(0xFF4B91AF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final moduleLine = Paint()
      ..color = const Color(0x773A78A0)
      ..strokeWidth = 1.4;
    for (final x in <double>[-82, -26, 32]) {
      canvas.drawLine(Offset(x, -37), Offset(x, 38), moduleLine);
    }

    final tower = RRect.fromRectAndRadius(
      const Rect.fromLTRB(-38, -68, 23, -37),
      const Radius.circular(7),
    );
    canvas.drawRRect(
      tower,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF5C9BC0), Color(0xFF1E5F8C)],
        ).createShader(const Rect.fromLTRB(-38, -68, 23, -37)),
    );
    canvas.drawRRect(
      tower,
      Paint()
        ..color = const Color(0xFF174B74)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    canvas.drawLine(const Offset(-20, -68), const Offset(-20, -91), moduleLine);
    canvas.drawLine(const Offset(5, -68), const Offset(5, -91), moduleLine);
    canvas.drawCircle(
      const Offset(-20, -93),
      3,
      Paint()..color = const Color(0xFF174B74),
    );
    canvas.drawCircle(
      const Offset(5, -93),
      3,
      Paint()..color = const Color(0xFF174B74),
    );
    canvas.drawCircle(
      const Offset(-8, -54),
      3,
      Paint()..color = const Color(0xFFBDEAF4),
    );

    final window = Paint()..color = const Color(0xFFE6F8FC);
    final windowOutline = Paint()
      ..color = const Color(0xFF123C63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final x in <double>[-111, -83, -55, -2]) {
      canvas.drawCircle(Offset(x, -3), 5, window);
      canvas.drawCircle(Offset(x, -3), 5, windowOutline);
      canvas.drawCircle(
        Offset(x - 1.5, -4.5),
        1.3,
        Paint()..color = Colors.white,
      );
    }

    final fin = Path()
      ..moveTo(-92, 35)
      ..lineTo(-82, 55)
      ..lineTo(-57, 53)
      ..lineTo(-52, 38)
      ..close();
    canvas.drawPath(fin, Paint()..color = const Color(0xFF174F7B));
    final topFin = Path()
      ..moveTo(82, -33)
      ..lineTo(98, -64)
      ..lineTo(125, -61)
      ..lineTo(116, -26)
      ..close();
    canvas.drawPath(topFin, Paint()..color = const Color(0xFF215D89));

    final propellerPaint = Paint()
      ..color = const Color(0xFF235E87)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(139, -25),
      const Offset(139, 26),
      propellerPaint,
    );
    canvas.drawLine(
      const Offset(126, -12),
      const Offset(153, 12),
      propellerPaint,
    );
    canvas.drawLine(
      const Offset(126, 12),
      const Offset(153, -12),
      propellerPaint,
    );
    canvas.drawCircle(
      const Offset(139, 0),
      5,
      Paint()..color = const Color(0xFFBDEAF4),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SubmarinePainter oldDelegate) => false;
}

class _PieceIconPainter extends CustomPainter {
  const _PieceIconPainter({
    required this.kind,
    required this.color,
    required this.unlocked,
  });

  final SubmarinePieceKind kind;
  final Color color;
  final bool unlocked;

  @override
  void paint(Canvas canvas, Size size) {
    if (!unlocked) {
      _drawLock(canvas, size);
      return;
    }
    switch (kind) {
      case SubmarinePieceKind.hull:
        _drawHull(canvas, size);
      case SubmarinePieceKind.tower:
        _drawTower(canvas, size);
      case SubmarinePieceKind.propeller:
        _drawPropeller(canvas, size);
      case SubmarinePieceKind.reactor:
      case SubmarinePieceKind.sonar:
      case SubmarinePieceKind.laboratory:
        _drawLock(canvas, size);
    }
  }

  void _drawHull(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(7, 18)
      ..cubicTo(10, 12, 33, 12, 37, 18)
      ..lineTo(34, 29)
      ..cubicTo(29, 36, 15, 36, 10, 29)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawLine(
      const Offset(10, 19),
      const Offset(34, 19),
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
    canvas.drawCircle(
      const Offset(20, 25),
      2,
      Paint()..color = const Color(0xFFBDEAF4),
    );
    canvas.drawCircle(
      const Offset(28, 25),
      2,
      Paint()..color = const Color(0xFFBDEAF4),
    );
  }

  void _drawTower(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(7, 20, 30, 13),
      const Radius.circular(5),
    );
    canvas.drawRRect(body, Paint()..color = color);
    canvas.drawRect(const Rect.fromLTWH(18, 11, 8, 10), Paint()..color = color);
    canvas.drawLine(
      const Offset(22, 11),
      const Offset(22, 4),
      Paint()
        ..color = color
        ..strokeWidth = 2.4,
    );
    canvas.drawLine(
      const Offset(15, 23),
      const Offset(29, 23),
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );
    canvas.drawCircle(
      const Offset(15, 29),
      1.5,
      Paint()..color = const Color(0xFFBDEAF4),
    );
    canvas.drawCircle(
      const Offset(29, 29),
      1.5,
      Paint()..color = const Color(0xFFBDEAF4),
    );
  }

  void _drawPropeller(Canvas canvas, Size size) {
    final center = const Offset(22, 22);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final end = Offset(
        center.dx + math.cos(angle) * 14,
        center.dy + math.sin(angle) * 14,
      );
      canvas.drawLine(center, end, paint);
    }
    canvas.drawCircle(center, 3.5, Paint()..color = const Color(0xFFBDEAF4));
  }

  void _drawLock(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      const Rect.fromLTWH(14, 7, 16, 18),
      math.pi,
      math.pi,
      false,
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(10, 18, 24, 18),
        const Radius.circular(4),
      ),
      Paint()..color = color,
    );
    canvas.drawCircle(
      const Offset(22, 27),
      2,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
  }

  @override
  bool shouldRepaint(covariant _PieceIconPainter oldDelegate) =>
      oldDelegate.kind != kind ||
      oldDelegate.color != color ||
      oldDelegate.unlocked != unlocked;
}
