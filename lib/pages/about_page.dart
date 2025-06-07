import 'package:flutter/material.dart';
import 'package:swiftscan/constants/app_themes.dart';
import 'package:swiftscan/l10n/app_localizations.dart';
import 'package:swiftscan/pages/privacy_policy_page.dart';
import 'package:swiftscan/pages/terms_of_service_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
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

  Widget _buildInfoTile({
    required BuildContext context,
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
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
      subtitle: subtitle != null
          ? Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: AppThemes.getTextColor(context).withOpacity(0.7),
                ),
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppThemes.getPrimaryColor(context),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 14,
                color: AppThemes.getTextColor(context).withOpacity(0.8),
                height: 1.4,
              ),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with app icon and title
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppThemes.getPrimaryColor(context),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppThemes.getPrimaryColor(
                              context,
                            ).withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      l10n.aboutTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppThemes.getTextColor(context),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${l10n.aboutVersion} 1.0.0',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppThemes.getTextColor(context).withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // App Description
              _buildInfoSection(context, 'About', [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    l10n.aboutDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppThemes.getTextColor(context).withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                ),
              ]),

              // Features Section
              _buildInfoSection(context, l10n.aboutFeatures, [
                _buildFeatureItem(context, l10n.aboutFeature1),
                _buildFeatureItem(context, l10n.aboutFeature2),
                _buildFeatureItem(context, l10n.aboutFeature3),
                _buildFeatureItem(context, l10n.aboutFeature4),
                _buildFeatureItem(context, l10n.aboutFeature5),
                _buildFeatureItem(context, l10n.aboutFeature6),
                SizedBox(height: 10),
              ]),

              // Developer Info
              _buildInfoSection(context, l10n.aboutDeveloper, [
                _buildInfoTile(
                  context: context,
                  title: l10n.aboutDeveloperName,
                  subtitle: 'Mobile App Development Team',
                  icon: Icons.code,
                ),
              ]),

              // Contact Section
              _buildInfoSection(context, l10n.aboutContact, [
                _buildInfoTile(
                  context: context,
                  title: l10n.aboutEmail,
                  subtitle: 'wambugukinyua@proton.me',
                  icon: Icons.email,
                  onTap: () {},
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppThemes.getTextColor(context).withOpacity(0.5),
                  ),
                ),
                _buildInfoTile(
                  context: context,
                  title: l10n.aboutWebsite,
                  subtitle: 'comming soon...',
                  icon: Icons.language,
                  onTap: () {},
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppThemes.getTextColor(context).withOpacity(0.5),
                  ),
                ),
              ]), // Legal Section
              _buildInfoSection(context, 'Legal', [
                _buildInfoTile(
                  context: context,
                  title: l10n.aboutPrivacy,
                  icon: Icons.privacy_tip,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage(),
                      ),
                    );
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppThemes.getTextColor(context).withOpacity(0.5),
                  ),
                ),
                _buildInfoTile(
                  context: context,
                  title: l10n.aboutTerms,
                  icon: Icons.description,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsOfServicePage(),
                      ),
                    );
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppThemes.getTextColor(context).withOpacity(0.5),
                  ),
                ),
                _buildInfoTile(
                  context: context,
                  title: l10n.aboutLicenses,
                  icon: Icons.code,
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: l10n.appTitle,
                      applicationVersion: '1.0.0',
                      applicationIcon: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppThemes.getPrimaryColor(context),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppThemes.getTextColor(context).withOpacity(0.5),
                  ),
                ),
              ]),

              SizedBox(height: 40),

              // Footer
              Center(
                child: Column(
                  children: [
                    Text(
                      'Made with ❤️ for QR code scanning',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppThemes.getTextColor(context).withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '© 2025 Swift Scan Team',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppThemes.getTextColor(context).withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
