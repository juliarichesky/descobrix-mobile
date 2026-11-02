import 'package:flutter/material.dart';

import '../data/local_collection_store.dart';
import '../models/discovery.dart';
import '../theme/app_colors.dart';
import 'duels_screen.dart';
import 'item_detail_screen.dart';
import 'scanner_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  static const _filters = <String>['Todos', 'Tecnologia', 'Saúde', 'Energia'];

  final _searchController = TextEditingController();
  Set<String> _unlockedIds = <String>{};
  String _selectedFilter = 'Todos';
  String _query = '';
  String? _selectedId;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadCollection();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadCollection() async {
    try {
      final ids = await LocalCollectionStore.loadIds();
      if (!mounted) return;
      setState(() {
        _unlockedIds = ids;
        _isLoading = false;
        _hasError = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onSearchChanged() {
    setState(() => _query = _searchController.text.trim().toLowerCase());
  }

  List<Discovery> get _visibleDiscoveries {
    return Discovery.catalog.where((discovery) {
      final matchesFilter =
          _selectedFilter == 'Todos' || discovery.category == _selectedFilter;
      final matchesQuery =
          _query.isEmpty || discovery.name.toLowerCase().contains(_query);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  void _selectFilter(String filter) {
    setState(() => _selectedFilter = filter);
  }

  void _toggleSearch() {
    setState(() => _isSearchVisible = !_isSearchVisible);
    if (!_isSearchVisible) {
      _searchController.clear();
    }
  }

  void _showDiscovery(Discovery discovery) {
    setState(() => _selectedId = discovery.id);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ItemDetailScreen(discovery: discovery),
      ),
    );
    return;
    /*
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(discovery.name),
        content: Text(
          '${discovery.category} • ${discovery.rarity}\n\n${discovery.description}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
    */
  }

  void _showLockedMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Este objeto ainda não foi descoberto.')),
      );
  }

  void _onNavigationSelected(int index) {
    switch (index) {
      case 0:
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
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
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Em desenvolvimento')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Minha coleção', style: textTheme.headlineMedium),
                        const SizedBox(height: 3),
                        Text(
                          '${_unlockedIds.length}/12 objetos',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Pesquisar',
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
            ),
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar objeto',
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
            const SizedBox(height: 14),
            SizedBox(
              height: 35,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final selected = filter == _selectedFilter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) => _selectFilter(filter),
                    labelStyle: TextStyle(
                      color: selected ? AppColors.surface : AppColors.navySoft,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    backgroundColor: AppColors.surfaceMuted,
                    selectedColor: AppColors.navy,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    showCheckmark: false,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildCollectionGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _CollectionNavigation(
        selectedIndex: 1,
        onSelected: _onNavigationSelected,
      ),
    );
  }

  Widget _buildCollectionGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError) {
      return Center(
        child: TextButton.icon(
          onPressed: () {
            setState(() => _isLoading = true);
            _loadCollection();
          },
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Tentar novamente'),
        ),
      );
    }

    final discoveries = _visibleDiscoveries;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 8,
        childAspectRatio: 0.73,
      ),
      itemCount: discoveries.length + 3,
      itemBuilder: (context, index) {
        if (index >= discoveries.length) {
          return _LockedCard(onTap: _showLockedMessage);
        }

        final discovery = discoveries[index];
        final unlocked = _unlockedIds.contains(discovery.id);
        return _DiscoveryCard(
          discovery: discovery,
          unlocked: unlocked,
          selected: discovery.id == _selectedId,
          onTap: unlocked
              ? () => _showDiscovery(discovery)
              : _showLockedMessage,
        );
      },
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({
    required this.discovery,
    required this.unlocked,
    required this.selected,
    required this.onTap,
  });

  final Discovery discovery;
  final bool unlocked;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.blue : AppColors.border;
    return Semantics(
      button: true,
      label: unlocked ? discovery.name : 'Objeto ainda não descoberto',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 7, 6, 7),
          decoration: BoxDecoration(
            color: unlocked ? AppColors.surface : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 1.4 : 1),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x263A9CDC),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Expanded(
                child: _DiscoveryIllustration(
                  assetKey: discovery.illustrationAsset,
                  enabled: unlocked,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                unlocked ? discovery.name : '???',
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 9.5,
                  color: unlocked ? AppColors.navy : AppColors.textDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LockedCard extends StatelessWidget {
  const _LockedCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Icon(
            Icons.lock_rounded,
            color: AppColors.textDisabled,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _DiscoveryIllustration extends StatelessWidget {
  const _DiscoveryIllustration({required this.assetKey, required this.enabled});

  final String assetKey;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final icon = switch (assetKey) {
      'mock_notebook' => Icons.laptop_mac_rounded,
      'smoke_detector' => Icons.sensors_rounded,
      'led_lamp' => Icons.lightbulb_rounded,
      'ct_scanner' => Icons.medical_services_rounded,
      'solar_panel' => Icons.solar_power_rounded,
      'nuclear_generator' => Icons.battery_charging_full_rounded,
      _ => Icons.category_rounded,
    };
    final iconColor = switch (assetKey) {
      'mock_notebook' => AppColors.navy,
      'smoke_detector' => AppColors.textMuted,
      'led_lamp' => AppColors.yellow,
      'ct_scanner' => AppColors.textMuted,
      'solar_panel' => AppColors.blueDeep,
      'nuclear_generator' => AppColors.orange,
      _ => AppColors.textMuted,
    };

    return Center(
      child: Opacity(
        opacity: enabled ? 1 : 0.35,
        child: Icon(icon, color: iconColor, size: 48),
      ),
    );
  }
}

class _CollectionNavigation extends StatelessWidget {
  const _CollectionNavigation({
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
