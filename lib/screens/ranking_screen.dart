import 'package:flutter/material.dart';

import '../data/local_account_store.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class RankingEntry {
  const RankingEntry({
    required this.name,
    required this.score,
    required this.color,
    this.isCurrentUser = false,
  });

  final String name;
  final int score;
  final Color color;
  final bool isCurrentUser;
}

class RankingAchievement {
  const RankingAchievement({
    required this.title,
    required this.condition,
    required this.icon,
    required this.color,
    required this.unlocked,
  });

  final String title;
  final String condition;
  final IconData icon;
  final Color color;
  final bool unlocked;
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  int _selectedTab = 0;
  String _playerName = 'Voc\u00EA';

  @override
  void initState() {
    super.initState();
    _loadPlayerName();
  }

  Future<void> _loadPlayerName() async {
    final account = await LocalAccountStore.loadAccount();
    if (!mounted || account == null) return;
    final name = account.name.trim();
    if (name.isEmpty) return;
    setState(() => _playerName = name.split(RegExp(r'\s+')).first);
  }

  List<RankingEntry> _entriesForTab() {
    final entries = _selectedTab == 0
        ? <RankingEntry>[
            const RankingEntry(
              name: 'Lucas',
              score: 3520,
              color: Color(0xFFB8794D),
            ),
            const RankingEntry(
              name: 'Mariana',
              score: 3180,
              color: Color(0xFFE68CA9),
            ),
            RankingEntry(
              name: _RankingData.playerPlaceholder,
              score: 1260,
              color: AppColors.blue,
              isCurrentUser: true,
            ),
            const RankingEntry(
              name: 'Felipe',
              score: 2120,
              color: Color(0xFFBE7C49),
            ),
            const RankingEntry(
              name: 'Amanda',
              score: 980,
              color: Color(0xFFD58D83),
            ),
          ]
        : <RankingEntry>[
            const RankingEntry(
              name: 'Aline',
              score: 5210,
              color: Color(0xFF7B8FD8),
            ),
            const RankingEntry(
              name: 'Bruno',
              score: 4630,
              color: Color(0xFFB8794D),
            ),
            const RankingEntry(
              name: 'Camila',
              score: 4050,
              color: Color(0xFFE68CA9),
            ),
            RankingEntry(
              name: _RankingData.playerPlaceholder,
              score: 1260,
              color: AppColors.blue,
              isCurrentUser: true,
            ),
            const RankingEntry(
              name: 'Diego',
              score: 1140,
              color: Color(0xFFD58D83),
            ),
          ];

    entries[2] = RankingEntry(
      name: _playerName,
      score: entries[2].score,
      color: entries[2].color,
      isCurrentUser: entries[2].isCurrentUser,
    );
    if (_selectedTab == 1) {
      entries[3] = RankingEntry(
        name: _playerName,
        score: entries[3].score,
        color: entries[3].color,
        isCurrentUser: entries[3].isCurrentUser,
      );
    }

    entries.sort((a, b) => b.score.compareTo(a.score));
    return entries;
  }

  List<RankingAchievement> get _achievements => const <RankingAchievement>[
    RankingAchievement(
      title: 'Primeira descoberta',
      condition: 'Descobrir 1 objeto',
      icon: Icons.star_rounded,
      color: AppColors.yellow,
      unlocked: true,
    ),
    RankingAchievement(
      title: 'Primeiro duelo',
      condition: 'Concluir 1 duelo',
      icon: Icons.shield_rounded,
      color: AppColors.blue,
      unlocked: true,
    ),
    RankingAchievement(
      title: 'Colecionador',
      condition: 'Descobrir 10 objetos',
      icon: Icons.lock_rounded,
      color: AppColors.textDisabled,
      unlocked: false,
    ),
    RankingAchievement(
      title: 'Mestre do conhecimento',
      condition: 'Vencer 5 duelos',
      icon: Icons.lock_rounded,
      color: AppColors.textDisabled,
      unlocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final entries = _entriesForTab();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeader(textTheme),
              const SizedBox(height: 12),
              _buildSegmentedControl(textTheme),
              const SizedBox(height: 18),
              Text(
                _selectedTab == 0
                    ? 'Classifica\u00E7\u00E3o entre amigos'
                    : 'Classifica\u00E7\u00E3o global demonstrativa',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildPodium(entries, textTheme),
              const SizedBox(height: 14),
              _buildRankingList(entries, textTheme),
              const SizedBox(height: 22),
              _buildAchievements(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        IconButton(
          tooltip: 'Voltar',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          color: AppColors.navy,
        ),
        Expanded(
          child: Text(
            'Ranking',
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(fontSize: 20),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildSegmentedControl(TextTheme textTheme) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: <Widget>[
          _SegmentOption(
            label: 'Amigos',
            selected: _selectedTab == 0,
            onTap: () => setState(() => _selectedTab = 0),
            textTheme: textTheme,
          ),
          _SegmentOption(
            label: 'Global',
            selected: _selectedTab == 1,
            onTap: () => setState(() => _selectedTab = 1),
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(List<RankingEntry> entries, TextTheme textTheme) {
    final podium = <RankingEntry>[entries[1], entries[0], entries[2]];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: _PodiumCard(
            entry: podium[0],
            rank: 2,
            height: 132,
            textTheme: textTheme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodiumCard(
            entry: podium[1],
            rank: 1,
            height: 148,
            textTheme: textTheme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodiumCard(
            entry: podium[2],
            rank: 3,
            height: 132,
            textTheme: textTheme,
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList(List<RankingEntry> entries, TextTheme textTheme) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      borderRadius: 20,
      child: Column(
        children: <Widget>[
          for (var index = 3; index < entries.length; index++)
            _RankingRow(
              rank: index + 1,
              entry: entries[index],
              textTheme: textTheme,
            ),
        ],
      ),
    );
  }

  Widget _buildAchievements(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Conquistas',
                style: textTheme.titleLarge?.copyWith(fontSize: 17),
              ),
            ),
            TextButton(
              onPressed: _showAllAchievements,
              child: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: <Widget>[
            for (final achievement in _achievements)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _AchievementBadge(achievement: achievement),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showAllAchievements() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Conquistas demonstrativas'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final achievement in _achievements)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      achievement.unlocked
                          ? achievement.icon
                          : Icons.lock_outline_rounded,
                      color: achievement.unlocked
                          ? achievement.color
                          : AppColors.textDisabled,
                    ),
                    title: Text(achievement.title),
                    subtitle: Text(
                      (achievement.unlocked
                              ? 'Desbloqueada: '
                              : 'Condi\u00E7\u00E3o: ') +
                          achievement.condition,
                    ),
                  ),
              ],
            ),
          ),
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
}

class _RankingData {
  static const playerPlaceholder = '__current_player__';
}

class _SegmentOption extends StatelessWidget {
  const _SegmentOption({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.textTheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: selected
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x120E2A4D),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.navy,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({
    required this.entry,
    required this.rank,
    required this.height,
    required this.textTheme,
  });

  final RankingEntry entry;
  final int rank;
  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final isFirst = rank == 1;
    final borderColor = isFirst ? AppColors.yellow : AppColors.border;
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
      decoration: BoxDecoration(
        color: isFirst ? const Color(0xFFFFFBF1) : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: isFirst ? 1.5 : 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (isFirst)
            const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.yellow,
              size: 22,
            )
          else
            Text(
              rank.toString(),
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w800,
              ),
            ),
          const SizedBox(height: 4),
          Container(
            width: isFirst ? 61 : 52,
            height: isFirst ? 61 : 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.color.withValues(alpha: 0.55),
              border: Border.all(color: entry.color, width: 4),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.navy,
              size: 28,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            entry.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            entry.score.toString(),
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({
    required this.rank,
    required this.entry,
    required this.textTheme,
  });

  final int rank;
  final RankingEntry entry;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.pinkLight.withValues(alpha: 0.7)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 25,
            child: Text(
              rank.toString(),
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.color.withValues(alpha: 0.55),
              border: Border.all(color: entry.color, width: 2.5),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.navy,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.isCurrentUser ? '${entry.name} (voc\u00EA)' : entry.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: entry.isCurrentUser ? AppColors.pink : AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            entry.score.toString(),
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.achievement});

  final RankingAchievement achievement;

  @override
  Widget build(BuildContext context) {
    final color = achievement.unlocked
        ? achievement.color
        : AppColors.textDisabled;
    return Tooltip(
      message: achievement.condition,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: achievement.unlocked
              ? color.withValues(alpha: 0.18)
              : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          achievement.unlocked ? achievement.icon : Icons.lock_rounded,
          color: color,
          size: 30,
        ),
      ),
    );
  }
}
