import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstimeCubit extends Cubit<bool> {
  FirstimeCubit() : super(false) {
    _loadFirstTimeStatus();
  }

  Future<void> _loadFirstTimeStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = await prefs.getBool('is_first_time');
    if (isFirstTime == null) {
      isFirstTime = false;
      await prefs.setBool('is_first_time', isFirstTime);
    }
    emit(isFirstTime);
  }

  Future<void> checkFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isFirstTime = await prefs.setBool('is_first_time', true);

    emit(isFirstTime);
  }

  Future<void> setFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', true);
    bool? isFirstTime = await prefs.getBool('is_first_time');
    emit(isFirstTime!);
  }
}
