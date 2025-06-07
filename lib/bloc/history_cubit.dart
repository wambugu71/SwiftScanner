import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryItem {
  final String content;
  final DateTime timestamp;
  final String type;
  final bool isUrl;

  HistoryItem({
    required this.content,
    required this.timestamp,
    required this.type,
    required this.isUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'isUrl': isUrl,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      isUrl: json['isUrl'],
    );
  }
}

class HistoryState {
  final List<HistoryItem> items;
  final bool isLoading;

  HistoryState({required this.items, this.isLoading = false});

  HistoryState copyWith({List<HistoryItem>? items, bool? isLoading}) {
    return HistoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HistoryCubit extends Cubit<HistoryState> {
  static const String _historyKey = 'scan_history';

  HistoryCubit() : super(HistoryState(items: [])) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    emit(state.copyWith(isLoading: true));
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      final items = historyJson.map((jsonString) {
        final json = jsonDecode(jsonString);
        return HistoryItem.fromJson(json);
      }).toList();

      // Sort by timestamp (newest first)
      items.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      emit(state.copyWith(items: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addHistoryItem(String content, String type) async {
    // Check if content is a URL
    bool isUrl =
        content.startsWith('http://') ||
        content.startsWith('https://') ||
        content.startsWith('www.');

    final newItem = HistoryItem(
      content: content,
      timestamp: DateTime.now(),
      type: type,
      isUrl: isUrl,
    );

    final updatedItems = [newItem, ...state.items];
    emit(state.copyWith(items: updatedItems));

    await _saveHistory();
  }

  Future<void> deleteHistoryItem(HistoryItem item) async {
    final updatedItems = state.items
        .where(
          (i) => i.content != item.content || i.timestamp != item.timestamp,
        )
        .toList();

    emit(state.copyWith(items: updatedItems));
    await _saveHistory();
  }

  Future<void> clearAllHistory() async {
    emit(state.copyWith(items: []));
    await _saveHistory();
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = state.items
          .map((item) => jsonEncode(item.toJson()))
          .toList();

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      // Handle error silently or emit error state if needed
    }
  }

  List<HistoryItem> getFilteredItems(String searchQuery, String filter) {
    return state.items.where((item) {
      bool matchesSearch = item.content.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      bool matchesFilter =
          filter == 'All' ||
          (filter == 'URLs' && item.isUrl) ||
          (filter == 'Text' && !item.isUrl);
      return matchesSearch && matchesFilter;
    }).toList();
  }
}
