import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HapticCubit extends Cubit<bool> {
  static const String _hapticKey = 'haptic_feedback_enabled';

  HapticCubit() : super(true) {
    _loadHapticSetting();
  }

  void _loadHapticSetting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hapticEnabled = prefs.getBool(_hapticKey);

      if (hapticEnabled == null) {
        emit(false);
      } else {
        emit(hapticEnabled);
      }
    } catch (e) {
      emit(false); // Default to enabled
    }
  }

  void toggleHaptic() async {
    final newValue = !state;
    emit(newValue);
    await _saveHapticSetting(newValue);
  }

  void setHaptic(bool enabled) async {
    emit(enabled);
    await _saveHapticSetting(enabled);
  }

  Future<void> _saveHapticSetting(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hapticKey, enabled);
    } catch (e) {
      // Handle error silently
    }
  }

  bool get isHapticEnabled => state;
}
