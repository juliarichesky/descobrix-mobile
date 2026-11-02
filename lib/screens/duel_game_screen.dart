import 'dart:async';

import 'package:flutter/material.dart';

import '../data/local_account_store.dart';
import '../models/local_account.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class DuelQuestion {
  const DuelQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class DuelGameScreen extends StatefulWidget {
  const DuelGameScreen({
    super.key,
    required this.opponentName,
    required this.opponentLevel,
  });

  final String opponentName;
  final int opponentLevel;

  @override
  State<DuelGameScreen> createState() => _DuelGameScreenState();
}

class _DuelGameScreenState extends State<DuelGameScreen> {
  static const int _totalQuestions = 5;
  static const int _secondsPerQuestion = 30;

  static const List<DuelQuestion> _questions = <DuelQuestion>[
    DuelQuestion(
      question: 'Qual material é um dos principais usados nos chips?',
      options: <String>['Silício', 'Urânio', 'Hidrogênio', 'Mercúrio líquido'],
      correctIndex: 0,
      explanation: 'O silício é um semicondutor muito utilizado na fabricação de chips e não é radioativo por natureza.',
    ),
    DuelQuestion(
      question:
          'Qual é uma função dos semicondutores nos componentes eletrônicos?',
      options: <String>[
        'Controlar o fluxo de sinais elétricos',
        'Emitir radiação para alimentar a tela',
        'Resfriar o teclado com líquido',
        'Substituir todas as baterias',
      ],
      correctIndex: 0,
      explanation: 'Semicondutores permitem controlar sinais elétricos e realizar operações de processamento.',
    ),
    DuelQuestion(
      question: 'Como técnicas nucleares podem se relacionar à pesquisa de semicondutores?',
      options: <String>[
        'Ajudando a analisar ou modificar materiais em etapas especializadas',
        'Tornando todo notebook radioativo',
        'Substituindo o silício em qualquer chip',
        'Gerando energia diretamente para todos os notebooks',
      ],
      correctIndex: 0,
      explanation: 'Técnicas nucleares podem apoiar pesquisas e análises de materiais, mas não fazem parte de todas as etapas.',
    ),
    DuelQuestion(
      question: 'Qual afirmação sobre o silício está correta?',
      options: <String>[
        'O silício natural não é radioativo por natureza',
        'Todo silício é um material radioativo',
        'O silício é um metal líquido',
        'O silício só existe em baterias',
      ],
      correctIndex: 0,
      explanation: 'O silício é um elemento químico estável encontrado em muitos materiais e usado como semicondutor.',
    ),
    DuelQuestion(
      question:
          'Em quais áreas notebooks podem apoiar pesquisas e aprendizagem?',
      options: <String>[
        'Educação, ciência e engenharia',
        'Somente em reatores nucleares',
        'Apenas em jogos',
        'Em nenhuma atividade científica',
      ],
      correctIndex: 0,
      explanation: 'Notebooks são ferramentas de computação usadas em educação, pesquisa, engenharia e muitas outras áreas.',
    ),
  ];

  Timer? _questionTimer;
  Timer? _advanceTimer;
  LocalAccount? _account;
  int _questionIndex = 0;
  int _remainingSeconds = _secondsPerQuestion;
  int _playerScore = 0;
  int? _selectedAnswer;
  bool _answerLocked = false;
  bool _showFeedback = false;
  String _feedbackText = '';
  bool _isFinishing = false;

  DuelQuestion get _currentQuestion => _questions[_questionIndex];

  String get _playerName {
    final name = _account?.name.trim() ?? '';
    if (name.isEmpty) return 'Você';
    return name.split(RegExp(r'\s+')).first;
  }

  @override
  void initState() {
    super.initState();
    _loadAccount();
    _startQuestionTimer();
  }

  Future<void> _loadAccount() async {
    final account = await LocalAccountStore.loadAccount();
    if (!mounted) return;
    setState(() => _account = account);
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _answerLocked) return;
      if (_remainingSeconds <= 1) {
        _questionTimer?.cancel();
        _handleTimeout();
        return;
      }
      setState(() => _remainingSeconds -= 1);
    });
  }

  void _handleAnswer(int answerIndex) {
    if (_answerLocked) return;

    final isCorrect = answerIndex == _currentQuestion.correctIndex;
    _questionTimer?.cancel();
    setState(() {
      _selectedAnswer = answerIndex;
      _answerLocked = true;
      _showFeedback = true;
      if (isCorrect) {
        _playerScore += 100;
        _feedbackText = 'Resposta correta! ' + _currentQuestion.explanation;
      } else {
        _feedbackText = 'Não foi dessa vez. ' + _currentQuestion.explanation;
      }
    });
    _scheduleNextQuestion();
  }

  void _handleTimeout() {
    if (_answerLocked) return;
    setState(() {
      _answerLocked = true;
      _showFeedback = true;
      _feedbackText = 'Tempo esgotado. ' + _currentQuestion.explanation;
    });
    _scheduleNextQuestion();
  }

  void _scheduleNextQuestion() {
    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_questionIndex == _totalQuestions - 1) {
        _finishGame();
        return;
      }
      setState(() {
        _questionIndex += 1;
        _remainingSeconds = _secondsPerQuestion;
        _selectedAnswer = null;
        _answerLocked = false;
        _showFeedback = false;
        _feedbackText = '';
      });
      _startQuestionTimer();
    });
  }

  Future<void> _finishGame() async {
    if (_isFinishing || !mounted) return;
    _isFinishing = true;
    _questionTimer?.cancel();
    _advanceTimer?.cancel();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Duelo concluído'),
          content: Text(
            'Você marcou ' +
                _playerScore.toString() +
                ' pontos nesta partida demonstrativa.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Voltar para Duelos'),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<bool> _confirmExit() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sair do duelo?'),
          content: const Text(
            'Seu progresso demonstrativo será perdido nesta partida.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Continuar'),
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
    return shouldLeave ?? false;
  }

  Future<void> _requestExit() async {
    if (await _confirmExit() && mounted) {
      _questionTimer?.cancel();
      _advanceTimer?.cancel();
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmRestart() async {
    final shouldRestart = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reiniciar duelo?'),
          content: const Text('A pontuação e as perguntas serão zeradas.'),
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
              child: const Text('Reiniciar'),
            ),
          ],
        );
      },
    );
    if (shouldRestart != true || !mounted) return;

    _questionTimer?.cancel();
    _advanceTimer?.cancel();
    setState(() {
      _questionIndex = 0;
      _remainingSeconds = _secondsPerQuestion;
      _playerScore = 0;
      _selectedAnswer = null;
      _answerLocked = false;
      _showFeedback = false;
      _feedbackText = '';
      _isFinishing = false;
    });
    _startQuestionTimer();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    _advanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _confirmExit()) {
          _questionTimer?.cancel();
          _advanceTimer?.cancel();
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildHeader(),
                const SizedBox(height: 10),
                Text(
                  'Partida demonstrativa sobre o Notebook',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 14),
                _buildScoreboard(),
                const SizedBox(height: 18),
                _buildQuestionCard(),
                const SizedBox(height: 12),
                ...List<Widget>.generate(
                  _currentQuestion.options.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _buildAnswerTile(index),
                  ),
                ),
                if (_showFeedback) ...<Widget>[
                  const SizedBox(height: 2),
                  _buildFeedback(),
                ],
                const SizedBox(height: 14),
                _buildTimer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: _requestExit,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.navy,
          tooltip: 'Voltar',
        ),
        Expanded(
          child: Text(
            'Duelo',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 19),
          ),
        ),
        IconButton(
          onPressed: _confirmRestart,
          icon: const Icon(Icons.restart_alt_rounded),
          color: AppColors.navy,
          tooltip: 'Reiniciar',
        ),
      ],
    );
  }

  Widget _buildScoreboard() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _PlayerScore(
            name: _playerName,
            subtitle: 'Nível 4',
            score: _playerScore,
            color: AppColors.blue,
            icon: Icons.person_rounded,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'VS',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w800),
          ),
        ),
        Expanded(
          child: _PlayerScore(
            name: widget.opponentName,
            subtitle: 'Nível ' + widget.opponentLevel.toString(),
            score: 640,
            color: AppColors.pinkLight,
            icon: Icons.person_outline_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        children: <Widget>[
          Text(
            'Pergunta ' +
                (_questionIndex + 1).toString() +
                ' de ' +
                _totalQuestions.toString(),
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.pink, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            _currentQuestion.question,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerTile(int index) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = _currentQuestion.correctIndex == index;
    Color background = AppColors.surface;
    Color border = AppColors.border;
    Color iconColor = AppColors.textMuted;

    if (_answerLocked && isCorrect) {
      background = const Color(0xFFE7F5E2);
      border = const Color(0xFF9AD68A);
      iconColor = const Color(0xFF4D9B43);
    } else if (isSelected) {
      background = AppColors.pinkLight.withOpacity(0.55);
      border = AppColors.pink;
      iconColor = AppColors.pink;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _answerLocked ? null : () => _handleAnswer(index),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.navy.withOpacity(0.035),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: iconColor,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _currentQuestion.options[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    final isSuccess = _selectedAnswer == _currentQuestion.correctIndex;
    final color = isSuccess ? const Color(0xFF3B8744) : AppColors.pink;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuccess
            ? const Color(0xFFE7F5E2)
            : AppColors.pinkLight.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _feedbackText,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTimer() {
    final progress = _remainingSeconds / _secondsPerQuestion;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.navy,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              _remainingSeconds.toString() + 's',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 7,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.pink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    required this.name,
    required this.subtitle,
    required this.score,
    required this.color,
    required this.icon,
  });

  final String name;
  final String subtitle;
  final int score;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.65),
            border: Border.all(color: color, width: 5),
          ),
          child: Icon(icon, color: AppColors.navy, size: 34),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w700),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.textMuted),
        ),
        Text(
          score.toString(),
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
