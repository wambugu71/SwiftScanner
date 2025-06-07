import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark }

class ThemeCubit extends Cubit<AppTheme> {
  static const String _themeKey = 'app_theme';

  ThemeCubit() : super(AppTheme.light) {
    _loadTheme();
  }

  void _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeName = prefs.getString(_themeKey) ?? 'light';
      final theme = themeName == 'dark' ? AppTheme.dark : AppTheme.light;
      emit(theme);
    } catch (e) {
      emit(AppTheme.light);
    }
  }

  void toggleTheme() async {
    final newTheme = state == AppTheme.light ? AppTheme.dark : AppTheme.light;
    emit(newTheme);
    await _saveTheme(newTheme);
  }

  void setTheme(AppTheme theme) async {
    emit(theme);
    await _saveTheme(theme);
  }

  Future<void> _saveTheme(AppTheme theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme.name);
    } catch (e) {
      // Handle error silently
    }
  }

  bool get isDarkMode => state == AppTheme.dark;
}
