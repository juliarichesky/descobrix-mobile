import 'package:flutter/material.dart';

import '../data/local_collection_store.dart';
import '../models/discovery.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key, required this.discovery});

  final Discovery discovery;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final Set<int> _expandedSections = <int>{};
  bool _isAdded = false;
  bool _isLoading = true;
  bool _isSaving = false;

  late final List<_EducationSection> _sections = [
    const _EducationSection(
      title: 'Como funciona',
      icon: Icons.favorite_rounded,
      color: AppColors.pink,
      content: 'Um notebook processa dados por meio de circuitos eletrônicos. Esses circuitos usam componentes semicondutores, como transistores, para realizar operações, armazenar informações e controlar energia.',
    ),
    const _EducationSection(
      title: 'Qual elemento está presente',
      icon: Icons.science_rounded,
      color: AppColors.purple,
      content: 'O silício é um dos principais materiais usados nos chips. Ele é um semicondutor e não é radioativo por natureza. Técnicas nucleares podem apoiar pesquisas, análises e modificações controladas desses materiais.',
    ),
    const _EducationSection(
      title: 'Aplicações em indústrias',
      icon: Icons.factory_rounded,
      color: AppColors.blue,
      content: 'Notebooks são usados em educação, pesquisa, engenharia, saúde, design e automação. As técnicas nucleares citadas pertencem a etapas especializadas de pesquisa e fabricação, não a todos os notebooks.',
    ),
    const _EducationSection(
      title: 'Curiosidades científicas',
      icon: Icons.lightbulb_rounded,
      color: AppColors.blueDeep,
      content: 'A miniaturização dos transistores permite colocar bilhões deles em um chip. O desempenho depende da arquitetura, dos materiais, do controle térmico e da forma como os componentes são interligados.',
    ),
    const _EducationSection(
      title: 'Fontes',
      icon: Icons.menu_book_rounded,
      color: AppColors.purple,
      content: 'Referências institucionais para estudo:\n\n• International Atomic Energy Agency (IAEA) — Nuclear Technology Review e aplicações industriais de técnicas nucleares.\n\n• National Institute of Standards and Technology (NIST) — pesquisa e medição de materiais e dispositivos semicondutores.\n\n• IEEE Electron Devices Society — materiais, fabricação e dispositivos eletrônicos.',
    ),
  ];

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
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('Não foi possível consultar sua coleção.');
    }
  }

  Future<void> _addToCollection() async {
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
        added ? 'Adicionado à coleção!' : 'Já adicionado à coleção.',
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage('Não foi possível salvar o item na coleção.');
    }
  }

  void _toggleSection(int index) {
    setState(() {
      if (!_expandedSections.add(index)) {
        _expandedSections.remove(index);
      }
    });
  }

  void _showMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.of(context).pop();
                _showMessage('Compartilhamento em desenvolvimento');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('Sobre este item'),
              onTap: () {
                Navigator.of(context).pop();
                _toggleSection(0);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.discovery;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 108),
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
                      size: 18,
                    ),
                    color: AppColors.navy,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Mais opções',
                    onPressed: _showMenu,
                    icon: const Icon(Icons.more_horiz_rounded, size: 23),
                    color: AppColors.navy,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Container(
                height: 230,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x160E2A4D),
                      blurRadius: 16,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: const CustomPaint(painter: _NotebookDetailPainter()),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: textTheme.headlineMedium?.copyWith(fontSize: 19),
                    ),
                  ),
                  _RarityTag(label: item.rarity),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Categoria   ${item.category}',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.navySoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              for (var index = 0; index < _sections.length; index++)
                _EducationTile(
                  section: _sections[index],
                  expanded: _expandedSections.contains(index),
                  onTap: () => _toggleSection(index),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
          child: AppButton(
            label: _isLoading
                ? 'Carregando...'
                : _isSaving
                ? 'Salvando...'
                : _isAdded
                ? 'Adicionado à coleção'
                : 'Adicionar à coleção',
            onPressed: _isLoading || _isAdded || _isSaving
                ? null
                : _addToCollection,
          ),
        ),
      ),
    );
  }
}

class _EducationSection {
  const _EducationSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String content;
}

class _EducationTile extends StatelessWidget {
  const _EducationTile({
    required this.section,
    required this.expanded,
    required this.onTap,
  });

  final _EducationSection section;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: section.color.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(section.icon, color: section.color, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      section.title,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    section.content,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.ink, height: 1.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RarityTag extends StatelessWidget {
  const _RarityTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.blueDeep,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NotebookDetailPainter extends CustomPainter {
  const _NotebookDetailPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 53),
        width: 210,
        height: 26,
      ),
      Paint()..color = const Color(0x18314A68),
    );

    final screen = Path()
      ..moveTo(center.dx - 65, center.dy - 78)
      ..lineTo(center.dx + 75, center.dy - 78)
      ..lineTo(center.dx + 63, center.dy + 15)
      ..lineTo(center.dx - 75, center.dy + 15)
      ..close();
    canvas.drawPath(
      screen,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF315C82), Color(0xFF071827)],
        ).createShader(Rect.fromLTWH(center.dx - 75, center.dy - 78, 150, 94)),
    );
    canvas.drawPath(
      screen,
      Paint()
        ..color = AppColors.navy
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final base = Path()
      ..moveTo(center.dx - 75, center.dy + 15)
      ..lineTo(center.dx + 63, center.dy + 15)
      ..lineTo(center.dx + 94, center.dy + 44)
      ..quadraticBezierTo(
        center.dx + 5,
        center.dy + 57,
        center.dx - 98,
        center.dy + 38,
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
      ..moveTo(center.dx - 50, center.dy + 21)
      ..lineTo(center.dx + 51, center.dy + 21)
      ..lineTo(center.dx + 69, center.dy + 38)
      ..lineTo(center.dx - 68, center.dy + 34)
      ..close();
    canvas.drawPath(keyboard, Paint()..color = const Color(0xFF9BAAB5));
    final keyPaint = Paint()..color = const Color(0xFF546B7B);
    for (var row = 0; row < 3; row++) {
      for (var column = 0; column < 8; column++) {
        canvas.drawCircle(
          Offset(
            center.dx - 51 + column * 14 + row * 2,
            center.dy + 24 + row * 4,
          ),
          1.5,
          keyPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookDetailPainter oldDelegate) => false;
}
