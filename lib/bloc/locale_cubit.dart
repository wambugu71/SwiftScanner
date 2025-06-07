import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const String _localeKey = 'selected_locale';

  LocaleCubit() : super(const Locale('en', 'US')) {
    _loadLocale();
  }

  // Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);

      if (localeCode != null) {
        final parts = localeCode.split('_');
        if (parts.length == 2) {
          emit(Locale(parts[0], parts[1]));
        } else {
          emit(Locale(parts[0]));
        }
      }
    } catch (e) {
      // If there's an error, keep the default locale
      emit(const Locale('en', 'US'));
    }
  }

  // Change locale and save to SharedPreferences
  Future<void> changeLocale(Locale newLocale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = newLocale.countryCode != null
          ? '${newLocale.languageCode}_${newLocale.countryCode}'
          : newLocale.languageCode;

      await prefs.setString(_localeKey, localeCode);
      emit(newLocale);
    } catch (e) {
      // If saving fails, still emit the new locale
      emit(newLocale);
    }
  }

  // Predefined supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('sw', 'KE'), // Swahili (Kenya)
    Locale('fr', 'FR'), // French (France)
    Locale('es', 'ES'), // Spanish (Spain)
    Locale('ta', 'IN'), // Tamil (India)
    Locale('zh', 'CN'), // Chinese (China)
  ];

  // Get locale display names
  String getDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'sw':
        return 'Kiswahili';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      case 'ta':
        return 'தமிழ்';
      case 'zh':
        return '中文';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}
