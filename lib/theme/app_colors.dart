import 'package:flutter/material.dart';

/// Cores base extraídas da linguagem visual da referência do Descobrix.
abstract final class AppColors {
  static const navy = Color(0xFF14294D);
  static const navySoft = Color(0xFF29446D);
  static const ink = Color(0xFF20304F);
  static const pink = Color(0xFFF45B95);
  static const pinkLight = Color(0xFFFFDCE9);
  static const pinkPale = Color(0xFFFFF1F6);
  static const blue = Color(0xFF2D9BD5);
  static const blueDeep = Color(0xFF1269A6);
  static const blueLight = Color(0xFFDDF3FF);
  static const bluePale = Color(0xFFF0F8FD);
  static const aqua = Color(0xFFBDEAF4);
  static const green = Color(0xFF5AAB72);
  static const greenLight = Color(0xFFDFF2D9);
  static const yellow = Color(0xFFFFC75A);
  static const orange = Color(0xFFF18E4B);
  static const purple = Color(0xFF8E79C7);
  static const background = Color(0xFFF8FAFD);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF2F5FA);
  static const border = Color(0xFFD8E0EC);
  static const borderStrong = Color(0xFFBECBDD);
  static const textMuted = Color(0xFF71809B);
  static const textDisabled = Color(0xFFAAB5C5);

  static const discoveryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFC7DC), Color(0xFFBFEAFF), Color(0xFF4FA6DE)],
  );

  static const oceanGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE9F8FF), Color(0xFFB9E6F5), Color(0xFF4C9FD6)],
  );

  static const primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF45B95), Color(0xFFFF83B3)],
  );
}
