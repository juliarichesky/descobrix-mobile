import 'package:flutter/material.dart';

import '../data/local_account_store.dart';
import '../models/local_account.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import 'collection_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.showLoginSuccess = false});

  final bool showLoginSuccess;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocalAccount? _account;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAccount();
    if (widget.showLoginSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
      });
    }
  }

  Future<void> _loadAccount() async {
    final account = await LocalAccountStore.loadAccount();
    if (!mounted) return;
    setState(() => _account = account);
  }

  void _showInDevelopment() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Em desenvolvimento')));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final firstName = _firstName(_account?.name ?? 'Explorador');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _Header(
                    firstName: firstName,
                    textTheme: textTheme,
                    onNotifications: _showInDevelopment,
                  ),
                  const SizedBox(height: 20),
                  _DiscoveryBanner(onExplore: _openScanner),
                  const SizedBox(height: 12),
                  _QuickCards(
                    onCollection: _openCollection,
                    onOther: _showInDevelopment,
                  ),
                  const SizedBox(height: 20),
                  _DailyMission(textTheme: textTheme),
                  const SizedBox(height: 18),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 1) {
            _openCollection();
            return;
          }
          if (index == 2) {
            _openScanner();
            return;
          }
          setState(() => _selectedIndex = index);
          if (index != 0) _showInDevelopment();
        },
      ),
    );
  }

  String _firstName(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return 'Explorador';
    return trimmedName.split(RegExp(r'\s+')).first;
  }

  void _openScanner() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ScannerScreen()));
  }

  void _openCollection() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CollectionScreen()));
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.firstName,
    required this.textTheme,
    required this.onNotifications,
  });

  final String firstName;
  final TextTheme textTheme;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Avatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $firstName!',
                style: textTheme.titleMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text('Nível 4', style: textTheme.bodySmall),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0.64,
                        minHeight: 6,
                        backgroundColor: AppColors.pinkLight,
                        valueColor: AlwaysStoppedAnimation(AppColors.pink),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('320 / 500 XP', style: textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Notificações',
          onPressed: onNotifications,
          icon: const Icon(Icons.notifications_none_rounded),
          color: AppColors.navy,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blueLight,
        border: Border.all(color: AppColors.surface, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x180E2A4D),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 30,
        color: AppColors.blueDeep,
      ),
    );
  }
}

class _DiscoveryBanner extends StatelessWidget {
  const _DiscoveryBanner({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 12, 14),
      borderRadius: 20,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2E78D1), Color(0xFF144A9A)],
      ),
      child: SizedBox(
        height: 122,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Que tal uma\nnova descoberta?',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.surface,
                      fontSize: 16,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aponte a câmera para um objeto\nao seu redor.',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.surface,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      onPressed: onExplore,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('Explorar agora'),
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinkLight,
                        foregroundColor: AppColors.pink,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(flex: 4, child: _CameraIllustration()),
          ],
        ),
      ),
    );
  }
}

class _CameraIllustration extends StatelessWidget {
  const _CameraIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 76,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFFFC2DC),
          borderRadius: BorderRadius.circular(17),
          boxShadow: const [
            BoxShadow(
              color: Color(0x332B68B4),
              blurRadius: 12,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 44,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.navy, width: 2),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.blueDeep,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickCards extends StatelessWidget {
  const _QuickCards({required this.onCollection, required this.onOther});

  final VoidCallback onCollection;
  final VoidCallback onOther;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: Row(
        children: [
          Expanded(
            child: _QuickCard(
              title: 'Minha coleção',
              detail: '12/50',
              icon: Icons.menu_book_rounded,
              iconColor: AppColors.blue,
              onTap: onCollection,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickCard(
              title: 'Desafiar\namigos',
              detail: '',
              icon: Icons.emoji_events_rounded,
              iconColor: AppColors.orange,
              onTap: onOther,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickCard(
              title: 'Meu submarino',
              detail: '3/6 peças',
              icon: Icons.directions_boat_filled_rounded,
              iconColor: AppColors.blueDeep,
              onTap: onOther,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.title,
    required this.detail,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String detail;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      borderRadius: 17,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 27),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelLarge?.copyWith(fontSize: 10),
          ),
          if (detail.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(detail, style: textTheme.bodySmall?.copyWith(fontSize: 9)),
          ],
        ],
      ),
    );
  }
}

class _DailyMission extends StatelessWidget {
  const _DailyMission({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Missão diária', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        AppCard(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          borderRadius: 17,
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.pinkLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  size: 20,
                  color: AppColors.pink,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descubra 2 objetos da categoria\nMedicina Nuclear',
                      style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.5,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(AppColors.pink),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text('1/2', style: textTheme.labelLarge),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

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
                    onTap: () => onItemSelected(index),
                    child: _NavItem(
                      label: _items[index].label,
                      icon: _items[index].icon,
                      selected: selectedIndex == index,
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
  });

  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.pink : AppColors.navy;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 21),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
