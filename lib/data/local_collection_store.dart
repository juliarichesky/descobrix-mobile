import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/discovery.dart';

class LocalProgress {
  const LocalProgress({required this.totalXp, required this.discoveredIds});

  final int totalXp;
  final Set<String> discoveredIds;

  int get level => (totalXp ~/ LocalCollectionStore.xpPerLevel) + 1;

  int get xpInCurrentLevel => totalXp % LocalCollectionStore.xpPerLevel;

  double get levelProgress =>
      xpInCurrentLevel / LocalCollectionStore.xpPerLevel;
}

class DiscoveryAddResult {
  const DiscoveryAddResult({
    required this.added,
    required this.xpAwarded,
    required this.progress,
  });

  final bool added;
  final int xpAwarded;
  final LocalProgress progress;
}

class LocalCollectionStore {
  LocalCollectionStore._();

  static const int xpPerLevel = 500;
  static final ValueNotifier<int> progressVersion = ValueNotifier<int>(0);
  static const _idsKey = 'discovery_collection_ids';
  static const _totalXpKey = 'discovery_total_xp';
  static const _xpAwardedIdsKey = 'discovery_xp_awarded_ids';

  static Future<Set<String>> loadIds() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getStringList(_idsKey) ?? <String>[]).toSet();
  }

  static Future<LocalProgress> loadProgress() async {
    final preferences = await SharedPreferences.getInstance();
    await _migrateExistingCollection(preferences);

    final ids = (preferences.getStringList(_idsKey) ?? <String>[]).toSet();
    final totalXp = preferences.getInt(_totalXpKey) ?? 0;
    return LocalProgress(
      totalXp: totalXp,
      discoveredIds: Set<String>.unmodifiable(ids),
    );
  }

  static Future<DiscoveryAddResult> addDiscovery(Discovery discovery) async {
    final preferences = await SharedPreferences.getInstance();
    await _migrateExistingCollection(preferences);

    final ids = (preferences.getStringList(_idsKey) ?? <String>[]).toSet();
    final awardedIds =
        (preferences.getStringList(_xpAwardedIdsKey) ?? <String>[]).toSet();
    var totalXp = preferences.getInt(_totalXpKey) ?? 0;

    if (ids.contains(discovery.id)) {
      return DiscoveryAddResult(
        added: false,
        xpAwarded: 0,
        progress: LocalProgress(
          totalXp: totalXp,
          discoveredIds: Set<String>.unmodifiable(ids),
        ),
      );
    }

    ids.add(discovery.id);
    awardedIds.add(discovery.id);
    totalXp += discovery.xp;
    await preferences.setStringList(_idsKey, ids.toList());
    await preferences.setStringList(_xpAwardedIdsKey, awardedIds.toList());
    await preferences.setInt(_totalXpKey, totalXp);
    progressVersion.value += 1;

    return DiscoveryAddResult(
      added: true,
      xpAwarded: discovery.xp,
      progress: LocalProgress(
        totalXp: totalXp,
        discoveredIds: Set<String>.unmodifiable(ids),
      ),
    );
  }

  static Future<bool> addId(String id) async {
    final preferences = await SharedPreferences.getInstance();
    final ids = (preferences.getStringList(_idsKey) ?? <String>[]).toSet();
    if (!ids.add(id)) return false;

    await preferences.setStringList(_idsKey, ids.toList());
    return true;
  }

  static Future<bool> contains(String id) async {
    final ids = await loadIds();
    return ids.contains(id);
  }

  static Future<void> _migrateExistingCollection(
    SharedPreferences preferences,
  ) async {
    final ids = (preferences.getStringList(_idsKey) ?? <String>[]).toSet();
    final awardedIds =
        (preferences.getStringList(_xpAwardedIdsKey) ?? <String>[]).toSet();
    var totalXp = preferences.getInt(_totalXpKey) ?? 0;
    var changed = false;

    for (final id in ids) {
      if (awardedIds.contains(id)) continue;
      Discovery? discovery;
      for (final catalogItem in Discovery.catalog) {
        if (catalogItem.id == id) {
          discovery = catalogItem;
          break;
        }
      }
      if (discovery == null) continue;
      totalXp += discovery.xp;
      awardedIds.add(id);
      changed = true;
    }

    if (!preferences.containsKey(_totalXpKey)) {
      await preferences.setInt(_totalXpKey, totalXp);
    }
    if (changed) {
      await preferences.setInt(_totalXpKey, totalXp);
      await preferences.setStringList(_xpAwardedIdsKey, awardedIds.toList());
    }
  }
}
