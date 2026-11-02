import 'package:shared_preferences/shared_preferences.dart';

import '../models/local_account.dart';

class LocalAccountStore {
  LocalAccountStore._();

  static const _nameKey = 'local_account_name';
  static const _emailKey = 'local_account_email';

  static Future<void> saveAccount({
    required String name,
    required String email,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_nameKey, name.trim());
    await preferences.setString(_emailKey, email.trim().toLowerCase());
  }

  static Future<LocalAccount?> loadAccount() async {
    final preferences = await SharedPreferences.getInstance();
    final name = preferences.getString(_nameKey);
    final email = preferences.getString(_emailKey);

    if (name == null || email == null || name.isEmpty || email.isEmpty) {
      return null;
    }

    return LocalAccount(name: name, email: email);
  }
}
