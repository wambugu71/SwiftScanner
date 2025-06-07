import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swiftscan/constants/app_themes.dart';

class QRGeneratorPage extends StatefulWidget {
  const QRGeneratorPage({super.key});

  @override
  State<QRGeneratorPage> createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  final GlobalKey _qrKey = GlobalKey();
  String _qrData = '';
  QRType _selectedType = QRType.text;

  // Text controllers for different types
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _wifiNameController = TextEditingController();
  final TextEditingController _wifiPasswordController = TextEditingController();
  final TextEditingController _smsNumberController = TextEditingController();
  final TextEditingController _smsMessageController = TextEditingController();

  String _wifiSecurity = 'WPA';
  @override
  void initState() {
    super.initState();
    _updateQRData();
  }

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _organizationController.dispose();
    _wifiNameController.dispose();
    _wifiPasswordController.dispose();
    _smsNumberController.dispose();
    _smsMessageController.dispose();
    super.dispose();
  }

  void _updateQRData() {
    String data = '';
    switch (_selectedType) {
      case QRType.text:
        data = _textController.text;
        break;
      case QRType.url:
        data = _urlController.text;
        break;
      case QRType.contact:
        data = _generateVCard();
        break;
      case QRType.wifi:
        data = _generateWiFiString();
        break;
      case QRType.sms:
        data = _generateSMSString();
        break;
      case QRType.email:
        data = _generateEmailString();
        break;
    }
    setState(() {
      _qrData = data;
    });
  }

  String _generateVCard() {
    if (_nameController.text.isEmpty) return '';
    return 'BEGIN:VCARD\n'
        'VERSION:3.0\n'
        'FN:${_nameController.text}\n'
        'TEL:${_phoneController.text}\n'
        'EMAIL:${_emailController.text}\n'
        'ORG:${_organizationController.text}\n'
        'END:VCARD';
  }

  String _generateWiFiString() {
    if (_wifiNameController.text.isEmpty) return '';
    return 'WIFI:T:$_wifiSecurity;S:${_wifiNameController.text};P:${_wifiPasswordController.text};;';
  }

  String _generateSMSString() {
    if (_smsNumberController.text.isEmpty) return '';
    return 'sms:${_smsNumberController.text}?body=${_smsMessageController.text}';
  }

  String _generateEmailString() {
    if (_emailController.text.isEmpty) return '';
    return 'mailto:${_emailController.text}';
  }

  Future<void> _saveQRCode() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Save to temporary directory first
        final tempDir = await getTemporaryDirectory();
        final file = await File(
          '${tempDir.path}/swift_scan_qr_${DateTime.now().millisecondsSinceEpoch}.png',
        ).create();
        await file.writeAsBytes(pngBytes);

        // Save to gallery using gal package
        await Gal.putImage(file.path);

        _showSnackBar('QR Code saved to gallery!', Colors.green);
      }
    } catch (e) {
      _showSnackBar('Error saving QR Code: $e', Colors.red);
    }
  }

  Future<void> _shareQRCode() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/qr_code.png').create();
        await file.writeAsBytes(pngBytes);

        await Share.shareXFiles([XFile(file.path)], text: 'Generated QR Code');
      }
    } catch (e) {
      _showSnackBar('Error sharing QR Code: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppThemes.getBackgroundColor(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppThemes.getBackgroundColor(context),
        title: Text(
          'QR Generator',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppThemes.getTextColor(context),
          ),
        ),
        iconTheme: IconThemeData(color: AppThemes.getTextColor(context)),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppThemes.getPrimaryColor(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.qr_code_2, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // QR Code Display
            Container(
              margin: const EdgeInsets.all(20),
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
                children: [
                  RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _qrData.isNotEmpty
                          ? QrImageView(
                              data: _qrData,
                              version: QrVersions.auto,
                              size: 200.0,
                              foregroundColor: Colors.black,
                            )
                          : Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code_2,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Enter data to generate\nQR Code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  if (_qrData.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveQRCode,
                            icon: const Icon(Icons.save_alt),
                            label: const Text('Save'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppThemes.getPrimaryColor(
                                context,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _shareQRCode,
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppThemes.getPrimaryColor(
                                context,
                              ),
                              side: BorderSide(
                                color: AppThemes.getPrimaryColor(context),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Input Section
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                  // Dropdown for QR Type Selection
                  Text(
                    'Select QR Code Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppThemes.getTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<QRType>(
                    value: _selectedType,
                    onChanged: (QRType? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                        _updateQRData();
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: _getQRTypeIcon(_selectedType),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: QRType.values.map((QRType type) {
                      return DropdownMenuItem<QRType>(
                        value: type,
                        child: Row(
                          children: [
                            _getQRTypeIcon(type),
                            const SizedBox(width: 12),
                            Text(_getQRTypeLabel(type)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Content based on selected type
                  _buildSelectedContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon _getQRTypeIcon(QRType type) {
    switch (type) {
      case QRType.text:
        return const Icon(Icons.text_fields);
      case QRType.url:
        return const Icon(Icons.link);
      case QRType.contact:
        return const Icon(Icons.person);
      case QRType.wifi:
        return const Icon(Icons.wifi);
      case QRType.sms:
        return const Icon(Icons.sms);
      case QRType.email:
        return const Icon(Icons.email);
    }
  }

  String _getQRTypeLabel(QRType type) {
    switch (type) {
      case QRType.text:
        return 'Text';
      case QRType.url:
        return 'URL';
      case QRType.contact:
        return 'Contact';
      case QRType.wifi:
        return 'WiFi';
      case QRType.sms:
        return 'SMS';
      case QRType.email:
        return 'Email';
    }
  }

  Widget _buildSelectedContent() {
    switch (_selectedType) {
      case QRType.text:
        return _buildTextTab();
      case QRType.url:
        return _buildURLTab();
      case QRType.contact:
        return _buildContactTab();
      case QRType.wifi:
        return _buildWiFiTab();
      case QRType.sms:
        return _buildSMSTab();
      case QRType.email:
        return _buildEmailTab();
    }
  }

  Widget _buildTextTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _textController,
          maxLines: 4,
          onChanged: (_) => _updateQRData(),
          decoration: InputDecoration(
            hintText: 'Type any text here...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildURLTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _urlController,
            onChanged: (_) => _updateQRData(),
            decoration: InputDecoration(
              hintText: 'https://example.com',
              prefixIcon: const Icon(Icons.link),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            onChanged: (_) => _updateQRData(),
            decoration: InputDecoration(
              labelText: 'Full Name *',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            onChanged: (_) => _updateQRData(),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            onChanged: (_) => _updateQRData(),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _organizationController,
            onChanged: (_) => _updateQRData(),
            decoration: InputDecoration(
              labelText: 'Organization',
              prefixIcon: const Icon(Icons.business),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWiFiTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _wifiNameController,
            onChanged: (_) => _updateQRData(),
            decoration: InputDecoration(
              labelText: 'Network Name (SSID) *',
              prefixIcon: const Icon(Icons.wifi),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _wifiPasswordController,
            onChanged: (_) => _updateQRData(),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _wifiSecurity,
            onChanged: (value) {
              setState(() {
                _wifiSecurity = value!;
                _updateQRData();
              });
            },
            decoration: InputDecoration(
              labelText: 'Security Type',
              prefixIcon: const Icon(Icons.security),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'WPA', child: Text('WPA/WPA2')),
              DropdownMenuItem(value: 'WEP', child: Text('WEP')),
              DropdownMenuItem(value: 'nopass', child: Text('Open')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSMSTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _smsNumberController,
            onChanged: (_) => _updateQRData(),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number *',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _smsMessageController,
            onChanged: (_) => _updateQRData(),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Message',
              prefixIcon: const Icon(Icons.message),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _emailController,
            onChanged: (_) => _updateQRData(),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address *',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum QRType { text, url, contact, wifi, sms, email }
