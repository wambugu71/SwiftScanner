import 'package:flutter/material.dart';
import 'package:swiftscan/constants/app_themes.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppThemes.getBackgroundColor(context),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppThemes.getTextColor(context),
          ),
        ),
        iconTheme: IconThemeData(color: AppThemes.getTextColor(context)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppThemes.getCardColor(context),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppThemes.getPrimaryColor(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.privacy_tip,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Swift Scan Privacy Policy',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppThemes.getTextColor(context),
                              ),
                            ),
                            Text(
                              'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppThemes.getTextColor(
                                  context,
                                ).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSection(
                    context,
                    'Information We Collect',
                    '''Swift Scan is designed with privacy in mind. We collect minimal information to provide you with the best QR code scanning experience:

• Camera Access: We access your device's camera solely for QR code scanning purposes. Images are processed locally on your device and are not stored or transmitted.

• Scan History: QR code scan results are stored locally on your device for your convenience. This data never leaves your device.

• Device Storage: We may store app preferences and settings locally on your device.

• No Personal Information: We do not collect, store, or transmit any personal information, contact details, or identifying data.''',
                  ),

                  _buildSection(
                    context,
                    'How We Use Information',
                    '''The limited information we access is used exclusively to:

• Scan QR codes using your device's camera
• Store scan history locally for your reference
• Maintain app preferences and settings
• Provide QR code generation functionality

We do not use any information for advertising, analytics, or any other purposes beyond the core functionality of the app.''',
                  ),

                  _buildSection(
                    context,
                    'Data Storage and Security',
                    '''• Local Storage: All scan history and app data are stored locally on your device
• No Cloud Storage: We do not store any of your data on external servers
• No Data Transmission: Your scan results and generated QR codes are not transmitted to any external services
• Camera Security: Camera access is used only during active scanning and no images are saved
• User Control: You can clear your scan history at any time through the app settings''',
                  ),

                  _buildSection(
                    context,
                    'Permissions',
                    '''Swift Scan requests the following permissions:

• Camera: Required for QR code scanning functionality
• Storage: Required to save generated QR codes to your gallery (optional)
• Vibration: Used for haptic feedback during successful scans (optional)

You can revoke these permissions at any time through your device settings.''',
                  ),

                  _buildSection(
                    context,
                    'Third-Party Services',
                    '''Swift Scan does not integrate with any third-party analytics, advertising, or data collection services. The app operates entirely offline after installation.''',
                  ),

                  _buildSection(
                    context,
                    'Children\'s Privacy',
                    '''Swift Scan is safe for users of all ages. We do not knowingly collect any personal information from children under 13 or any users of any age.''',
                  ),

                  _buildSection(
                    context,
                    'Changes to Privacy Policy',
                    '''We may update this Privacy Policy from time to time. Any changes will be reflected in the app and on this page. We encourage you to review this Privacy Policy periodically.''',
                  ),

                  _buildSection(
                    context,
                    'Contact Us',
                    '''If you have any questions about this Privacy Policy or our privacy practices, please contact us at:

Email: wambugukinyua125@gmail.com
Website: comming soon...
GitHub: github.com/wambugu71/swiftscan/issues

Your privacy is important to us, and we are committed to protecting it.''',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppThemes.getTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppThemes.getTextColor(context).withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
