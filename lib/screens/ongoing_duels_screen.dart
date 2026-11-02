import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class OngoingDuel {
  const OngoingDuel({
    required this.friendName,
    required this.level,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.color,
  });

  final String friendName;
  final int level;
  final int currentQuestion;
  final int totalQuestions;
  final Color color;

  double get progress => currentQuestion / totalQuestions;
}

class OngoingDuelsScreen extends StatelessWidget {
  const OngoingDuelsScreen({super.key, this.duels = _defaultDuels});

  static const _defaultDuels = <OngoingDuel>[
    OngoingDuel(
      friendName: 'Lucas',
      level: 5,
      currentQuestion: 3,
      totalQuestions: 5,
      color: Color(0xFFB8794D),
    ),
    OngoingDuel(
      friendName: 'Mariana',
      level: 4,
      currentQuestion: 2,
      totalQuestions: 5,
      color: Color(0xFFE68CA9),
    ),
    OngoingDuel(
      friendName: 'Felipe',
      level: 3,
      currentQuestion: 4,
      totalQuestions: 5,
      color: Color(0xFFBE7C49),
    ),
  ];

  final List<OngoingDuel> duels;

  void _showContinueMessage(BuildContext context, OngoingDuel duel) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'A partida com ${duel.friendName} ser\u00E1 implementada na pr\u00F3xima etapa.',
          ),
        ),
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
                  Expanded(
                    child: Text(
                      'Duelos em andamento',
                      style: textTheme.headlineMedium?.copyWith(fontSize: 19),
                    ),
                  ),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 18),
              Text(
                'Continue de onde voc\u00EA parou!',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                'Suas partidas simuladas ficam aqui para voc\u00EA retomar depois.',
                style: textTheme.bodySmall?.copyWith(height: 1.35),
              ),
              const SizedBox(height: 16),
              if (duels.isEmpty)
                const OngoingDuelsEmptyState()
              else
                for (final duel in duels)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _OngoingDuelCard(
                      duel: duel,
                      onContinue: () => _showContinueMessage(context, duel),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class OngoingDuelsEmptyState extends StatelessWidget {
  const OngoingDuelsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.sports_esports_outlined,
            color: AppColors.purple,
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            'Nenhum duelo em andamento',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 5),
          Text(
            'Crie um novo duelo para começar a jogar.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _OngoingDuelCard extends StatelessWidget {
  const _OngoingDuelCard({required this.duel, required this.onContinue});

  final OngoingDuel duel;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120E2A4D),
            blurRadius: 13,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _DuelAvatar(duel: duel),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  duel.friendName,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text('N\u00EDvel ${duel.level}', style: textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: duel.progress,
                          minHeight: 6,
                          backgroundColor: AppColors.pinkLight,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.pink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pergunta ${duel.currentQuestion}/${duel.totalQuestions}',
                      style: textTheme.bodySmall?.copyWith(fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pinkLight,
                foregroundColor: AppColors.pink,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DuelAvatar extends StatelessWidget {
  const _DuelAvatar({required this.duel});

  final OngoingDuel duel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: duel.color.withValues(alpha: 0.24),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x180E2A4D),
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(Icons.person_rounded, color: duel.color, size: 28),
    );
  }
}
