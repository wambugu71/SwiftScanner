import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiftscan/bloc/history_cubit.dart';
import 'package:swiftscan/constants/app_themes.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Load history when page is opened
    context.read<HistoryCubit>().loadHistory();
  }

  List<HistoryItem> _getFilteredItems(List<HistoryItem> items) {
    return items.where((item) {
      bool matchesSearch = item.content.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      bool matchesFilter =
          _selectedFilter == 'All' ||
          (_selectedFilter == 'URLs' && item.isUrl) ||
          (_selectedFilter == 'Text' && !item.isUrl);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _deleteItem(HistoryItem item) {
    context.read<HistoryCubit>().deleteHistoryItem(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 8),
            Text('Item deleted'),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppThemes.getCardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text(
              'Clear All History',
              style: TextStyle(color: AppThemes.getTextColor(context)),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete all scan history? This action cannot be undone.',
          style: TextStyle(height: 1.5, color: AppThemes.getTextColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppThemes.getTextColor(context).withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HistoryCubit>().clearAllHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      Text('All history cleared'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppThemes.getPrimaryColor(context)
              : AppThemes.getCardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppThemes.getPrimaryColor(context)
                : AppThemes.getTextColor(context).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppThemes.getTextColor(context),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppThemes.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Dismissible(
        key: Key('${item.content}_${item.timestamp.millisecondsSinceEpoch}'),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        onDismissed: (direction) => _deleteItem(item),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.isUrl
                          ? Colors.green
                          : AppThemes.getPrimaryColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.isUrl ? Icons.link : Icons.text_fields,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.type,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppThemes.getTextColor(context),
                          ),
                        ),
                        Text(
                          _formatTimestamp(item.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppThemes.getTextColor(
                              context,
                            ).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppThemes.getTextColor(context).withOpacity(0.6),
                    ),
                    color: AppThemes.getCardColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'copy':
                          Clipboard.setData(ClipboardData(text: item.content));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Copied to clipboard'),
                                ],
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          break;
                        case 'open':
                          if (item.isUrl) {
                            try {
                              launchUrl(Uri.parse(item.content));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Unable to open URL'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                          break;
                        case 'delete':
                          _deleteItem(item);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'copy',
                        child: Row(
                          children: [
                            Icon(
                              Icons.copy,
                              size: 20,
                              color: AppThemes.getPrimaryColor(context),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Copy',
                              style: TextStyle(
                                color: AppThemes.getTextColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.isUrl)
                        PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              Icon(
                                Icons.open_in_new,
                                size: 20,
                                color: Colors.green,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Open URL',
                                style: TextStyle(
                                  color: AppThemes.getTextColor(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 12),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: AppThemes.getTextColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppThemes.getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppThemes.getTextColor(context),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppThemes.getBackgroundColor(context),
        elevation: 0,
        title: Text(
          'Scan History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppThemes.getTextColor(context),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppThemes.getPrimaryColor(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.delete_sweep, color: Colors.white),
                  onPressed: _clearAllHistory,
                  tooltip: 'Clear All History',
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppThemes.getPrimaryColor(context),
                ),
              ),
            );
          }

          final historyItems = state.items;
          final filteredItems = _getFilteredItems(historyItems);

          return Column(
            children: [
              // Search and Filter Section
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppThemes.getCardColor(context),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: TextStyle(
                          color: AppThemes.getTextColor(context),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search history...',
                          hintStyle: TextStyle(
                            color: AppThemes.getTextColor(
                              context,
                            ).withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppThemes.getPrimaryColor(context),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Filter Chips
                    Row(
                      children: [
                        _buildFilterChip('All'),
                        SizedBox(width: 12),
                        _buildFilterChip('URLs'),
                        SizedBox(width: 12),
                        _buildFilterChip('Text'),
                      ],
                    ),
                  ],
                ),
              ),
              // History List
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: AppThemes.getTextColor(
                                context,
                              ).withOpacity(0.3),
                            ),
                            SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty ||
                                      _selectedFilter != 'All'
                                  ? 'No matching items found'
                                  : 'No scan history yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppThemes.getTextColor(context),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _searchQuery.isNotEmpty ||
                                      _selectedFilter != 'All'
                                  ? 'Try adjusting your search or filter'
                                  : 'Start scanning QR codes to see your history here',
                              style: TextStyle(
                                color: AppThemes.getTextColor(
                                  context,
                                ).withOpacity(0.6),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return _buildHistoryItem(filteredItems[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
