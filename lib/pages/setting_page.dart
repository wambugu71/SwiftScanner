import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiftscan/bloc/haptic_cubit.dart';
import 'package:swiftscan/bloc/locale_cubit.dart';
import 'package:swiftscan/bloc/page_cubit.dart';
import 'package:swiftscan/bloc/theme_cubit.dart';
import 'package:swiftscan/constants/app_themes.dart';
import 'package:swiftscan/l10n/app_localizations.dart';
import 'package:swiftscan/pages/privacy_policy_page.dart';
import 'package:swiftscan/pages/terms_of_service_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoScanEnabled = true;
  bool _soundEnabled = true;
  bool _saveHistoryEnabled = true;
  bool _autoOpenUrlsEnabled = false;
  String _scanFormat = 'All Formats';
  double _scanDelay = 2.0;

  void _showComingSoonSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Feature coming soon!'),
          ],
        ),
        backgroundColor: Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppThemes.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppThemes.getTextColor(context),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppThemes.getPrimaryColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppThemes.getTextColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppThemes.getTextColor(context).withOpacity(0.6),
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppThemes.getPrimaryColor(context),
        activeTrackColor: AppThemes.getPrimaryColor(context).withOpacity(0.3),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    String? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color:
              iconColor?.withOpacity(0.1) ??
              AppThemes.getPrimaryColor(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppThemes.getPrimaryColor(context),
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppThemes.getTextColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppThemes.getTextColor(context).withOpacity(0.6),
          fontSize: 14,
        ),
      ),
      trailing: trailing != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppThemes.getBackgroundColor(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppThemes.getTextColor(context).withOpacity(0.2),
                ),
              ),
              child: Text(
                trailing,
                style: TextStyle(
                  color: AppThemes.getPrimaryColor(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            )
          : Icon(
              Icons.chevron_right,
              color: AppThemes.getTextColor(context).withOpacity(0.6),
            ),
      onTap: onTap,
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    required String unit,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 12, 148, 238),
                      Color.fromARGB(255, 20, 114, 236),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Color(0xFF6C757D), fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppThemes.getCardColor(context),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFE9ECEF)),
                ),
                child: Text(
                  '${value.toInt()}$unit',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.blue,
              inactiveTrackColor: Colors.blue[200],
              thumbColor: Colors.blue,
              overlayColor: Colors.blue[200],
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(context),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          l10n.settingsTitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppThemes.getTextColor(context),
          ),
        ),
        backgroundColor: AppThemes.getBackgroundColor(context),
        iconTheme: IconThemeData(color: AppThemes.getTextColor(context)),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppThemes.getPrimaryColor(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Scanning Settings
            _buildSettingsSection('Scanning', [
              _buildSwitchTile(
                title: 'Auto Scan',
                subtitle: 'Automatically scan QR codes when detected',
                icon: Icons.qr_code_scanner,
                value: _autoScanEnabled,
                onChanged: (value) {
                  setState(() {
                    _autoScanEnabled = value;
                  });
                },
              ),
              _buildSliderTile(
                title: 'Scan Delay',
                subtitle: 'Time between automatic scans',
                icon: Icons.timer,
                value: _scanDelay,
                min: 1.0,
                max: 5.0,
                unit: 's',
                onChanged: (value) {
                  setState(() {
                    _scanDelay = value;
                  });
                },
              ),
              _buildActionTile(
                title: 'Scan Format',
                subtitle: 'Choose which formats to scan',
                icon: Icons.qr_code,
                trailing: _scanFormat,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select Scan Format',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          SizedBox(height: 20),
                          ...[
                            'All Formats',
                            'QR Code Only',
                            'Barcode Only',
                          ].map(
                            (format) => ListTile(
                              title: Text(format),
                              trailing: _scanFormat == format
                                  ? Icon(Icons.check, color: Color(0xFF6C63FF))
                                  : null,
                              onTap: () {
                                setState(() {
                                  _scanFormat = format;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ]),

            // Feedback Settings
            _buildSettingsSection('Feedback', [
              _buildSwitchTile(
                title: 'Sound',
                subtitle: 'Play sound when QR code is scanned',
                icon: Icons.volume_up,
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
              ),
              BlocBuilder<HapticCubit, bool>(
                builder: (context, hapticEnabled) {
                  return _buildSwitchTile(
                    title: l10n.settingsHapticFeedback,
                    subtitle: l10n.settingsHapticFeedbackDesc,
                    icon: Icons.vibration,
                    value: hapticEnabled,
                    onChanged: (value) {
                      context.read<HapticCubit>().setHaptic(value);
                    },
                  );
                },
              ),
            ]), // Data & Privacy
            _buildSettingsSection('Data & Privacy', [
              _buildSwitchTile(
                title: 'Save History',
                subtitle: 'Keep a record of scanned QR codes',
                icon: Icons.history,
                value: _saveHistoryEnabled,
                onChanged: (value) {
                  setState(() {
                    _saveHistoryEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Auto Open URLs',
                subtitle: 'Automatically open detected URLs',
                icon: Icons.open_in_browser,
                value: _autoOpenUrlsEnabled,
                onChanged: (value) {
                  setState(() {
                    _autoOpenUrlsEnabled = value;
                  });
                },
              ),
              _buildActionTile(
                title: 'Privacy Policy',
                subtitle: 'How we handle your data and privacy',
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
              _buildActionTile(
                title: 'Terms of Service',
                subtitle: 'Terms and conditions for using the app',
                icon: Icons.gavel_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsOfServicePage(),
                    ),
                  );
                },
              ),
              _buildActionTile(
                title: 'Clear History',
                subtitle: 'Delete all scan history',
                icon: Icons.delete_outline,
                iconColor: Color(0xFFFF5722),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text('Clear History'),
                      content: Text(
                        'Are you sure you want to delete all scan history? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showComingSoonSnackBar();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF5722),
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]), // App Settings
            _buildSettingsSection('App', [
              BlocBuilder<ThemeCubit, AppTheme>(
                builder: (context, currentTheme) {
                  return _buildSwitchTile(
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    icon: Icons.dark_mode,
                    value: currentTheme == AppTheme.dark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  );
                },
              ),
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, currentLocale) {
                  final localeCubit = context.read<LocaleCubit>();
                  return _buildActionTile(
                    title: l10n.settingsLanguage,
                    subtitle: 'Choose your preferred language',
                    icon: Icons.language,
                    trailing: localeCubit.getDisplayName(currentLocale),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          decoration: BoxDecoration(
                            color: AppThemes.getCardColor(context),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.all(20),
                          child: ListView(
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.settingsLanguage,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppThemes.getTextColor(context),
                                ),
                              ),
                              SizedBox(height: 20),
                              ...LocaleCubit.supportedLocales.map(
                                (locale) => ListTile(
                                  title: Text(
                                    localeCubit.getDisplayName(locale),
                                    style: TextStyle(
                                      color: AppThemes.getTextColor(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    locale.languageCode.toUpperCase(),
                                    style: TextStyle(
                                      color: AppThemes.getTextColor(
                                        context,
                                      ).withOpacity(0.6),
                                    ),
                                  ),
                                  trailing:
                                      currentLocale.languageCode ==
                                          locale.languageCode
                                      ? Icon(
                                          Icons.check,
                                          color: AppThemes.getPrimaryColor(
                                            context,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    localeCubit.changeLocale(locale);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              _buildActionTile(
                title: 'About',
                subtitle: 'App version and information',
                icon: Icons.info_outline,
                onTap: () {
                  // Navigate to About page (index 3 in the navigation)
                  BlocProvider.of<PageCubit>(context).setPage(4);
                },
              ),
            ]),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
