import 'package:shared_preferences/shared_preferences.dart';

class LocalCollectionStore {
  LocalCollectionStore._();

  static const _idsKey = 'discovery_collection_ids';

  static Future<Set<String>> loadIds() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getStringList(_idsKey) ?? <String>[]).toSet();
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
}
