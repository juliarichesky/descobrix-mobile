import 'package:flutter/material.dart';

import '../data/local_account_store.dart';
import '../data/local_collection_store.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import 'collection_screen.dart';
import 'duels_screen.dart';
import 'login_screen.dart';
import 'ranking_screen.dart';
import 'scanner_screen.dart';
import 'submarine_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Explorador';
  LocalProgress _progress = const LocalProgress(
    totalXp: 0,
    discoveredIds: <String>{},
  );

  @override
  void initState() {
    super.initState();
    _loadAccount();
    _loadProgress();
    LocalCollectionStore.progressVersion.addListener(_onProgressChanged);
  }

  Future<void> _loadAccount() async {
    final account = await LocalAccountStore.loadAccount();
    if (!mounted || account == null) return;
    final name = account.name.trim();
    if (name.isEmpty) return;
    setState(() => _userName = name.split(RegExp(r'\s+')).first);
  }

  Future<void> _loadProgress() async {
    final progress = await LocalCollectionStore.loadProgress();
    if (!mounted) return;
    setState(() => _progress = progress);
  }

  void _onProgressChanged() {
    _loadProgress();
  }

  @override
  void dispose() {
    LocalCollectionStore.progressVersion.removeListener(_onProgressChanged);
    super.dispose();
  }

  void _openRanking() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RankingScreen()));
  }

  void _showSettings() {
    _showDialog(
      title: 'Configura\u00E7\u00F5es',
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Prefer\u00EAncias demonstrativas'),
          SizedBox(height: 12),
          Text('\u2022 Sons: ativados'),
          Text('\u2022 Anima\u00E7\u00F5es: ativadas'),
          Text('\u2022 Idioma: portugu\u00EAs (Brasil)'),
        ],
      ),
    );
  }

  void _showNotifications() {
    _showDialog(
      title: 'Notifica\u00E7\u00F5es',
      content: const Text(
        'As notifica\u00E7\u00F5es ser\u00E3o implementadas em uma pr\u00F3xima etapa. Nenhuma permiss\u00E3o foi solicitada.',
      ),
    );
  }

  void _showHelp() {
    _showDialog(
      title: 'Ajuda',
      content: const Text(
        'Explore o mapa e use o Scanner para descobrir objetos. Adicione descobertas \u00E0 cole\u00E7\u00E3o e participe de duelos demonstrativos com seus amigos.',
      ),
    );
  }

  void _showAbout() {
    _showDialog(
      title: 'Sobre o Descobrix',
      content: const Text(
        'O Descobrix \u00E9 um jogo educativo sobre aplica\u00E7\u00F5es da tecnologia nuclear no cotidiano, apresentado de forma simples e segura.',
      ),
    );
  }

  void _showDialog({required String title, required Widget content}) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sair da conta?'),
          content: const Text(
            'Voc\u00EA voltar\u00E1 para a tela de Login. Sua conta e sua cole\u00E7\u00E3o permanecer\u00E3o salvas neste dispositivo.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.surface,
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (shouldSignOut != true || !mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onNavigationSelected(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const CollectionScreen()),
        );
        return;
      case 2:
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const ScannerScreen()));
        return;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const DuelsScreen()));
        return;
      case 4:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildProfileHeader(textTheme, _progress),
              const SizedBox(height: 18),
              _buildStatsCard(textTheme),
              const SizedBox(height: 5),
              Text(
                'Pontos e ranking s\u00E3o demonstrativos nesta etapa.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
              const SizedBox(height: 16),
              _buildOptions(textTheme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _ProfileNavigation(
        selectedIndex: 4,
        onSelected: _onNavigationSelected,
      ),
    );
  }

  Widget _buildProfileHeader(TextTheme textTheme, LocalProgress progress) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blueLight,
            border: Border.all(color: AppColors.surface, width: 3),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x1A0E2A4D),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.blueDeep,
            size: 43,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineMedium?.copyWith(fontSize: 19),
              ),
              const SizedBox(height: 4),
              Text(
                'N\u00EDvel ' + progress.level.toString(),
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 9),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress.levelProgress,
                        minHeight: 7,
                        backgroundColor: AppColors.pinkLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.pink,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    progress.xpInCurrentLevel.toString() +
                        ' / ' +
                        LocalCollectionStore.xpPerLevel.toString() +
                        ' XP',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(TextTheme textTheme) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      borderRadius: 18,
      child: Column(
        children: <Widget>[
          _StatRow(label: 'Pontos', value: '1.260', textTheme: textTheme),
          _StatRow(
            label: 'Ranking',
            value: 'Explorador',
            textTheme: textTheme,
            onTap: _openRanking,
          ),
          _StatRow(
            label: 'Pe\u00E7as do submarino',
            value: '3/6',
            textTheme: textTheme,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SubmarineScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(TextTheme textTheme) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      borderRadius: 18,
      child: Column(
        children: <Widget>[
          _ProfileOption(
            icon: Icons.settings_outlined,
            color: AppColors.navySoft,
            label: 'Configura\u00E7\u00F5es',
            onTap: _showSettings,
          ),
          _ProfileOption(
            icon: Icons.notifications_none_rounded,
            color: AppColors.navySoft,
            label: 'Notifica\u00E7\u00F5es',
            onTap: _showNotifications,
          ),
          _ProfileOption(
            icon: Icons.help_outline_rounded,
            color: AppColors.navySoft,
            label: 'Ajuda',
            onTap: _showHelp,
          ),
          _ProfileOption(
            icon: Icons.info_outline_rounded,
            color: AppColors.pink,
            label: 'Sobre o Descobrix',
            onTap: _showAbout,
          ),
          _ProfileOption(
            icon: Icons.logout_rounded,
            color: AppColors.pink,
            label: 'Sair',
            onTap: _confirmSignOut,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.textTheme,
    this.onTap,
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (onTap != null) ...<Widget>[
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 11),
          child: Row(
            children: <Widget>[
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.navySoft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileNavigation extends StatelessWidget {
  const _ProfileNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = <({String label, IconData icon})>[
    (label: 'In\u00EDcio', icon: Icons.home_rounded),
    (label: 'Cole\u00E7\u00E3o', icon: Icons.menu_book_outlined),
    (label: 'Explorar', icon: Icons.explore_outlined),
    (label: 'Desafios', icon: Icons.emoji_events_outlined),
    (label: 'Perfil', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 10,
      shadowColor: const Color(0x240E2A4D),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: <Widget>[
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          _items[index].icon,
                          color: index == selectedIndex
                              ? AppColors.pink
                              : AppColors.navy,
                          size: 21,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _items[index].label,
                          style: TextStyle(
                            color: index == selectedIndex
                                ? AppColors.pink
                                : AppColors.navy,
                            fontSize: 9,
                            fontWeight: index == selectedIndex
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
