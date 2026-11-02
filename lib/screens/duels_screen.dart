import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import 'collection_screen.dart';
import 'friends_screen.dart';
import 'ongoing_duels_screen.dart';
import 'profile_screen.dart';
import 'ranking_screen.dart';
import 'scanner_screen.dart';

class DuelsScreen extends StatelessWidget {
  const DuelsScreen({super.key});

  void _showInDevelopment(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Em desenvolvimento')));
  }

  void _openCollection(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CollectionScreen()));
  }

  void _openScanner(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ScannerScreen()));
  }

  void _openFriends(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const FriendsScreen()));
  }

  void _openOngoingDuels(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const OngoingDuelsScreen()));
  }

  void _openRanking(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RankingScreen()));
  }

  void _onNavigationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        return;
      case 1:
        _openCollection(context);
        return;
      case 2:
        _openScanner(context);
        return;
      case 3:
        return;
      case 4:
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen()));
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FC),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF0E9FC), Color(0xFFFFF8FC)],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
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
                      tooltip: 'Ajuda',
                      onPressed: () => _showInDevelopment(context),
                      icon: const Icon(Icons.help_outline_rounded),
                      color: AppColors.navy,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Duelos', style: textTheme.headlineLarge),
                const SizedBox(height: 5),
                Text(
                  'Desafie seus amigos e descubra quem sabe mais.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.navySoft,
                  ),
                ),
                const SizedBox(height: 16),
                const _DuelIllustration(),
                const SizedBox(height: 14),
                AppCard(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
                  borderRadius: 22,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6F56B7), Color(0xFF9984D1)],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hora do duelo!',
                              style: textTheme.titleLarge?.copyWith(
                                color: AppColors.surface,
                                fontSize: 19,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Teste seus conhecimentos e convide alguém para jogar.',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.surface,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFFFFD36E),
                        size: 48,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _DuelActionCard(
                  icon: Icons.add_circle_outline_rounded,
                  iconColor: AppColors.pink,
                  title: 'Criar novo duelo',
                  description: 'Escolha um tema e desafie seus amigos.',
                  buttonLabel: 'Criar duelo',
                  buttonVariant: AppButtonVariant.primary,
                  onPressed: () => _openFriends(context),
                ),
                const SizedBox(height: 10),
                _DuelActionCard(
                  icon: Icons.sports_esports_outlined,
                  iconColor: AppColors.purple,
                  title: 'Continuar duelo',
                  description:
                      'Retome uma disputa que ainda está em andamento.',
                  buttonLabel: 'Continuar',
                  buttonVariant: AppButtonVariant.secondary,
                  onPressed: () => _openOngoingDuels(context),
                ),
                const SizedBox(height: 10),
                _DuelActionCard(
                  icon: Icons.emoji_events_outlined,
                  iconColor: AppColors.orange,
                  title: 'Ranking',
                  description: 'Veja quem está no topo das descobertas.',
                  buttonLabel: 'Ver ranking',
                  buttonVariant: AppButtonVariant.outline,
                  onPressed: () => _openRanking(context),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _DuelNavigation(
        selectedIndex: 3,
        onSelected: (index) => _onNavigationSelected(context, index),
      ),
    );
  }
}

class _DuelIllustration extends StatelessWidget {
  const _DuelIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 5,
            child: Container(
              width: 230,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFDCD0F6),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const Positioned(
            left: 57,
            top: 18,
            child: Icon(
              Icons.flash_on_rounded,
              color: AppColors.pink,
              size: 30,
            ),
          ),
          const Positioned(
            right: 55,
            top: 26,
            child: Icon(Icons.science_rounded, color: AppColors.blue, size: 26),
          ),
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD7C9F1), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x262F1B59),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.orange,
              size: 48,
            ),
          ),
          const Positioned(
            left: 105,
            bottom: 3,
            child: Icon(
              Icons.sports_martial_arts_rounded,
              color: AppColors.navy,
              size: 28,
            ),
          ),
          const Positioned(
            right: 102,
            bottom: 3,
            child: Icon(
              Icons.sports_martial_arts_rounded,
              color: AppColors.navySoft,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _DuelActionCard extends StatelessWidget {
  const _DuelActionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonVariant,
    required this.onPressed,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String buttonLabel;
  final AppButtonVariant buttonVariant;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
      borderRadius: 19,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 9),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 48,
                    child: AppButton(
                      label: buttonLabel,
                      variant: buttonVariant,
                      expand: false,
                      onPressed: onPressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DuelNavigation extends StatelessWidget {
  const _DuelNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (label: 'Início', icon: Icons.home_rounded),
    (label: 'Coleção', icon: Icons.menu_book_outlined),
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
            children: [
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
