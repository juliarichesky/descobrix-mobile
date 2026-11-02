import 'package:flutter/material.dart';

import '../data/local_collection_store.dart';
import '../models/discovery.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';

class DiscoveryResultScreen extends StatefulWidget {
  const DiscoveryResultScreen({super.key, required this.discovery});

  final Discovery discovery;

  @override
  State<DiscoveryResultScreen> createState() => _DiscoveryResultScreenState();
}

class _DiscoveryResultScreenState extends State<DiscoveryResultScreen> {
  bool _isAdded = false;
  bool _isLoadingCollection = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCollectionState();
  }

  Future<void> _loadCollectionState() async {
    try {
      final isAdded = await LocalCollectionStore.contains(widget.discovery.id);
      if (!mounted) return;
      setState(() {
        _isAdded = isAdded;
        _isLoadingCollection = false;
      });
      if (isAdded) {
        _showMessage('JÃ¡ adicionado Ã  coleÃ§Ã£o.');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingCollection = false);
      _showMessage('NÃ£o foi possÃ­vel consultar sua coleÃ§Ã£o.');
    }
  }

  Future<void> _saveToCollection() async {
    if (_isAdded || _isSaving) return;
    setState(() => _isSaving = true);
    try {
      final added = await LocalCollectionStore.addId(widget.discovery.id);
      if (!mounted) return;
      setState(() {
        _isAdded = true;
        _isSaving = false;
      });
      _showMessage(
        added ? 'Adicionado Ã  coleÃ§Ã£o!' : 'JÃ¡ adicionado Ã  coleÃ§Ã£o.',
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage('NÃ£o foi possÃ­vel salvar o item na coleÃ§Ã£o.');
    }
  }

  void _showMoreInformation() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.discovery.name),
        content: Text(widget.discovery.additionalInformation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final item = widget.discovery;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Voltar',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 19,
                    ),
                    color: AppColors.navy,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Compartilhar',
                    onPressed: () =>
                        _showMessage('Compartilhamento em desenvolvimento'),
                    icon: const Icon(Icons.ios_share_rounded, size: 20),
                    color: AppColors.navy,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pinkLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    'Novo item descoberto!',
                    style: TextStyle(
                      color: AppColors.pink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                padding: EdgeInsets.zero,
                borderRadius: 22,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF0F5), Color(0xFFFFF9F6)],
                ),
                child: const SizedBox(
                  height: 215,
                  child: CustomPaint(painter: _NotebookPainter()),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.name,
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 22,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _Tag(
                    label: item.category,
                    backgroundColor: AppColors.blueLight,
                    foregroundColor: AppColors.blueDeep,
                  ),
                  const SizedBox(width: 8),
                  _Tag(
                    label: item.rarity,
                    backgroundColor: AppColors.greenLight,
                    foregroundColor: AppColors.green,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.ink,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                borderRadius: 18,
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.orange,
                      size: 24,
                    ),
                    const SizedBox(width: 9),
                    Text(
                      '${item.xp} XP',
                      style: textTheme.titleMedium?.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: _isAdded
                    ? 'Adicionado à coleção'
                    : 'Adicionar à coleção',
                variant: AppButtonVariant.navy,
                onPressed: _isLoadingCollection || _isAdded || _isSaving
                    ? null
                    : _saveToCollection,
              ),
              const SizedBox(height: 10),
              AppButton(
                label: 'Ver mais informações',
                variant: AppButtonVariant.outline,
                onPressed: _showMoreInformation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NotebookPainter extends CustomPainter {
  const _NotebookPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 12);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 48),
        width: 190,
        height: 24,
      ),
      Paint()..color = const Color(0x18314A68),
    );

    final screen = Path()
      ..moveTo(center.dx - 57, center.dy - 67)
      ..lineTo(center.dx + 66, center.dy - 67)
      ..lineTo(center.dx + 55, center.dy + 12)
      ..lineTo(center.dx - 66, center.dy + 12)
      ..close();
    canvas.drawPath(
      screen,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF294A6B), Color(0xFF071827)],
        ).createShader(Rect.fromLTWH(center.dx - 66, center.dy - 67, 132, 80)),
    );
    canvas.drawPath(
      screen,
      Paint()
        ..color = AppColors.navy
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final base = Path()
      ..moveTo(center.dx - 66, center.dy + 12)
      ..lineTo(center.dx + 55, center.dy + 12)
      ..lineTo(center.dx + 82, center.dy + 38)
      ..quadraticBezierTo(
        center.dx + 3,
        center.dy + 50,
        center.dx - 87,
        center.dy + 34,
      )
      ..close();
    canvas.drawPath(base, Paint()..color = const Color(0xFFD8E2E8));
    canvas.drawPath(
      base,
      Paint()
        ..color = const Color(0xFF7F91A0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final keyboard = Path()
      ..moveTo(center.dx - 43, center.dy + 17)
      ..lineTo(center.dx + 45, center.dy + 17)
      ..lineTo(center.dx + 61, center.dy + 33)
      ..lineTo(center.dx - 60, center.dy + 30)
      ..close();
    canvas.drawPath(keyboard, Paint()..color = const Color(0xFF9BAAB5));
    final keyPaint = Paint()..color = const Color(0xFF546B7B);
    for (var row = 0; row < 3; row++) {
      for (var column = 0; column < 7; column++) {
        canvas.drawCircle(
          Offset(
            center.dx - 45 + column * 14 + row * 2,
            center.dy + 21 + row * 4,
          ),
          1.4,
          keyPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookPainter oldDelegate) => false;
}
