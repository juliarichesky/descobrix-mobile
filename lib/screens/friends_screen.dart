import 'package:flutter/material.dart';

import 'duel_game_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  static const _friends = <_Friend>[
    _Friend(name: 'Lucas', level: 5, color: Color(0xFFB8794D)),
    _Friend(name: 'Mariana', level: 4, color: Color(0xFFE68CA9)),
    _Friend(name: 'Felipe', level: 3, color: Color(0xFFBE7C49)),
    _Friend(name: 'Amanda', level: 2, color: Color(0xFFD58D83)),
  ];

  final _searchController = TextEditingController();
  String _query = '';
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _query = _searchController.text.trim().toLowerCase());
  }

  void _toggleSearch() {
    setState(() => _isSearchVisible = !_isSearchVisible);
    if (!_isSearchVisible) _searchController.clear();
  }

  List<_Friend> get _visibleFriends {
    if (_query.isEmpty) return _friends;
    return _friends
        .where((friend) => friend.name.toLowerCase().contains(_query))
        .toList();
  }

  void _showShareDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compartilhar link'),
        content: const Text(
          'O convite por link \u00E9 demonstrativo nesta etapa. O compartilhamento real ainda n\u00E3o est\u00E1 dispon\u00EDvel.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _confirmDuel(_Friend friend) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desafiar amigo?'),
        content: Text(
          'Deseja simular um convite de duelo para ${friend.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(this.context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => DuelGameScreen(
                    opponentName: friend.name,
                    opponentLevel: friend.level,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: AppColors.surface,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final friends = _visibleFriends;

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
                    child: Text('Amigos', style: textTheme.headlineMedium),
                  ),
                  IconButton(
                    tooltip: 'Pesquisar amigos',
                    onPressed: _toggleSearch,
                    icon: Icon(
                      _isSearchVisible
                          ? Icons.close_rounded
                          : Icons.search_rounded,
                    ),
                    color: AppColors.navy,
                  ),
                ],
              ),
              const Divider(height: 1),
              if (_isSearchVisible)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar amigo',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _searchController.clear,
                              icon: const Icon(Icons.clear_rounded),
                            ),
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              Text('Desafie seus amigos', style: textTheme.titleLarge),
              const SizedBox(height: 5),
              Text(
                'Envie um link e desafie alguém\npara um duelo!',
                style: textTheme.bodySmall?.copyWith(height: 1.35),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Compartilhar link',
                icon: const Icon(Icons.link_rounded, size: 17),
                onPressed: _showShareDialog,
              ),
              const SizedBox(height: 25),
              Text('Seus amigos', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              if (friends.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Nenhum amigo encontrado.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                )
              else
                for (final friend in friends)
                  _FriendTile(
                    friend: friend,
                    onChallenge: () => _confirmDuel(friend),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Friend {
  const _Friend({required this.name, required this.level, required this.color});

  final String name;
  final int level;
  final Color color;
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({required this.friend, required this.onChallenge});

  final _Friend friend;
  final VoidCallback onChallenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _FriendAvatar(friend: friend),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Nível ${friend.level}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: onChallenge,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pinkLight,
                foregroundColor: AppColors.pink,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 34),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Desafiar'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendAvatar extends StatelessWidget {
  const _FriendAvatar({required this.friend});

  final _Friend friend;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: friend.color.withValues(alpha: 0.25),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x180E2A4D),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(Icons.person_rounded, color: friend.color, size: 26),
    );
  }
}
