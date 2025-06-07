import 'package:flutter/material.dart';
import 'package:swiftscan/constants/app_themes.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(context),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Terms of Service',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppThemes.getTextColor(context),
          ),
        ),
        backgroundColor: AppThemes.getBackgroundColor(context),
        iconTheme: IconThemeData(color: AppThemes.getTextColor(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildSection(
              'Acceptance of Terms',
              'By downloading, installing, or using the Swift Scan QR Code Scanner app ("the App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.',
            ),
            _buildSection(
              'Use License',
              'Permission is granted to temporarily download one copy of the App for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the App materials\n• Use the materials for any commercial purpose or for any public display\n• Attempt to decompile or reverse engineer any software contained in the App\n• Remove any copyright or other proprietary notations from the materials',
            ),
            _buildSection(
              'Disclaimer',
              'The materials in the App are provided on an "as is" basis. Swift Scan makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
            ),
            _buildSection(
              'Limitations',
              'In no event shall Swift Scan or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the App, even if Swift Scan or its authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.',
            ),
            _buildSection(
              'Accuracy of Materials',
              'The materials appearing in the App could include technical, typographical, or photographic errors. Swift Scan does not warrant that any of the materials in the App are accurate, complete, or current. Swift Scan may make changes to the materials contained in the App at any time without notice.',
            ),
            _buildSection(
              'User Content',
              'You are responsible for any content you scan, generate, or share using the App. You agree not to use the App for any unlawful purpose or in any way that could damage, disable, overburden, or impair the App. You must not transmit any worms, viruses, or any code of a destructive nature.',
            ),
            _buildSection(
              'QR Code Usage',
              'The App allows you to scan and generate QR codes. You are solely responsible for the content of any QR codes you create and for ensuring that such content complies with applicable laws and regulations. Swift Scan is not responsible for the content of QR codes scanned or generated through the App.',
            ),
            _buildSection(
              'Camera and Storage Permissions',
              'The App requires camera access to scan QR codes and storage access to save generated QR codes. By granting these permissions, you acknowledge that the App will access these features solely for the purpose of providing QR code scanning and generation functionality.',
            ),
            _buildSection(
              'Modifications',
              'Swift Scan may revise these Terms of Service at any time without notice. By using the App, you are agreeing to be bound by the then current version of these Terms of Service.',
            ),
            _buildSection(
              'Governing Law',
              'These terms and conditions are governed by and construed in accordance with the laws of the jurisdiction in which Swift Scan operates, and you irrevocably submit to the exclusive jurisdiction of the courts in that state or location.',
            ),
            _buildSection(
              'Contact Information',
              'If you have any questions about these Terms of Service, please contact us at:\n\nEmail: wambugukinyua125@gmail.com\nWebsite: comming soon...',
            ),
            SizedBox(height: 32),
            _buildLastUpdated(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52E3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.gavel, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms of Service',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Swift Scan QR Code Scanner',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Please read these Terms of Service carefully before using our application. Your use of the service is conditioned on your acceptance of and compliance with these terms.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2D2D),
              height: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE9ECEF), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Color(0xFF6C757D), size: 20),
          SizedBox(width: 12),
          Text(
            'Last updated: June 2025',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6C757D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
