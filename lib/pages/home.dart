import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swiftscan/bloc/haptic_cubit.dart';
import 'package:swiftscan/bloc/history_cubit.dart';
import 'package:swiftscan/bloc/torch_state.dart';
import 'package:swiftscan/constants/app_themes.dart';
import 'package:swiftscan/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool _is_result_url = false;
  File? _imageFile;
  bool _isbusy = false;
  bool _imgPicked = false;
  dynamic result;
  // Animation controllers for the overlay
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  late AnimationController _cornerAnimationController;
  late Animation<double> _cornerAnimation;

  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    autoZoom: true,
  );

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // _requestPermissions();

    // Initialize animations
    _scanAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanAnimationController, curve: Curves.linear),
    );

    _cornerAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _cornerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cornerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _scanAnimationController.repeat();
    _cornerAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _cornerAnimationController.dispose();
    super.dispose();
  }

  void _addToHistory(String content) {
    context.read<HistoryCubit>().addHistoryItem(content, 'QR Code');
  }

  Future<void> _pickAndScanImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _isbusy = true;
        });

        final BarcodeCapture? barcodes = await _controller.analyzeImage(
          image.path,
        );
        debugPrint("Barcodes: ${barcodes.toString()}");

        setState(() {
          _imageFile = File(image.path);
        });
        debugPrint("Image  path: ${_imageFile?.path}");
        if (barcodes != null && barcodes.barcodes.isNotEmpty) {
          final String code =
              await barcodes.barcodes.first.rawValue ?? 'Unknown';
          setState(() {
            result = code;
            _isbusy = false;
          });

          // Add to history
          _addToHistory(code);

          // Trigger haptic feedback if enabled
          final hapticEnabled = context.read<HapticCubit>().isHapticEnabled;
          if (hapticEnabled) {
            HapticFeedback.lightImpact();
          }
        } else {
          setState(() {
            _isbusy = false;
            result = 'no_data';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No barcode found in the selected image')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error scanning image: $e')));
    }
  }

  // Helper method to build animated corner frames
  List<Widget> _buildCornerFrames() {
    return [
      // Top-left corner
      Positioned(
        top: 0,
        left: 0,
        child: AnimatedBuilder(
          animation: _cornerAnimation,
          builder: (context, child) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.blue.withOpacity(
                      0.8 + (_cornerAnimation.value * 0.2),
                    ),
                    width: 4,
                  ),
                  left: BorderSide(
                    color: Colors.blue.withOpacity(
                      0.8 + (_cornerAnimation.value * 0.2),
                    ),
                    width: 4,
                  ),
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
              ),
            );
          },
        ),
      ),

      // Top-right corner
      Positioned(
        top: 0,
        right: 0,
        child: AnimatedBuilder(
          animation: _cornerAnimation,
          builder: (context, child) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.blue.withOpacity(
                      0.8 + (_cornerAnimation.value * 0.2),
                    ),
                    width: 4,
                  ),
                  right: BorderSide(
                    color: Colors.blue.withOpacity(
                      0.8 + (_cornerAnimation.value * 0.2),
                    ),
                    width: 4,
                  ),
                ),
                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
              ),
            );
          },
        ),
      ),

      // Bottom-left corner
      Positioned(
        bottom: 0,
        left: 0,
        child: AnimatedBuilder(
          animation: _cornerAnimation,
          builder: (context, child) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blue.withOpacity(
                      0.8 + (_cornerAnimation.value * 0.2),
                    ),
                    width: 4,
                  ),
                  left: BorderSide(
                    color: Colors.blue.withOpacity(
                      0.8 + (_cornerAnimation.value * 0.2),
                    ),
                    width: 4,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
              ),
            );
          },
        ),
      ),

      // Bottom-right corner
      Positioned(
        bottom: 0,
        right: 0,
        child: AnimatedBuilder(
          animation: _cornerAnimation,
          builder: (context, child) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blue.withOpacity(
                      0.8 + (_cornerAnimation.value * 0.2),
                    ),
                    width: 4,
                  ),
                  right: BorderSide(
                    color: Colors.blue.withOpacity(
                      0.8 + (_cornerAnimation.value * 0.2),
                    ),
                    width: 4,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  // Helper method to build animated scanning line
  Widget _buildScanningLine() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: 20 + (_scanAnimation.value * 210), // Move from top to bottom
          left: 20,
          right: 20,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.blue.withOpacity(0.8),
                  Colors.blue,
                  Colors.blue.withOpacity(0.8),
                  Colors.transparent,
                ],
                stops: [0.0, 0.2, 0.5, 0.8, 1.0],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool presed = false;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppThemes.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Center(
              child: Row(
                children: [
                  Icon(Icons.qr_code, color: Colors.blue, size: 32),
                  Text(
                    l10n.appTitle,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            Text(
              l10n.homeInstruction,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 335,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  child: (_imgPicked == false)
                      ? Card(
                          elevation: 2,
                          shadowColor: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          height: 300,
                                          width: double.infinity,
                                          child: MobileScanner(
                                            controller: _controller,
                                            errorBuilder: (context, error) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.warning,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Error detecting from the image.',
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                        255,
                                                        243,
                                                        72,
                                                        72,
                                                      ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  duration: Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                              return Container();
                                            },
                                            overlayBuilder: (context, constraints) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    // Semi-transparent overlay
                                                    Container(
                                                      width:
                                                          constraints.maxWidth,
                                                      height:
                                                          constraints.maxHeight,
                                                      color: Colors.transparent,
                                                    ),

                                                    // Central scanning area
                                                    Center(
                                                      child: Container(
                                                        width: 250,
                                                        height: 250,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors
                                                                .transparent,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            // Clear center area
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    18,
                                                                  ),
                                                              child: Container(
                                                                width: 250,
                                                                height: 250,
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                            ),

                                                            // Animated corner frames
                                                            ..._buildCornerFrames(),

                                                            // Scanning line animation
                                                            _buildScanningLine(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    // Top instruction text
                                                  ],
                                                ),
                                              );
                                            },
                                            onDetect: (barcode) async {
                                              final String code =
                                                  barcode
                                                      .barcodes
                                                      .first
                                                      .rawValue ??
                                                  'Unknown';
                                              setState(() {
                                                result = code;
                                              });

                                              // Add to history
                                              _addToHistory(code);

                                              // Trigger haptic feedback if enabled
                                              final hapticEnabled = context
                                                  .read<HapticCubit>()
                                                  .isHapticEnabled;

                                              if (hapticEnabled) {
                                                await Haptics.vibrate(
                                                  HapticsType.success,
                                                );
                                              }

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Info detected'),
                                                    ],
                                                  ),
                                                  backgroundColor: Color(
                                                    0xFF4CAF50,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  duration: Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      // Right side control panel
                                      Positioned(
                                        top: 80,
                                        right: 10,
                                        child: Column(
                                          children: [
                                            // Flash toggle button
                                            GestureDetector(
                                              onTap: () async {
                                                presed = !presed;
                                                context
                                                    .read<TorchCubit>()
                                                    .torchStatus(
                                                      controller: _controller,
                                                      presed: presed,
                                                    );
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  border: Border.all(
                                                    color: Colors.yellow,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: BlocBuilder<TorchCubit, bool>(
                                                  builder: (context, state) {
                                                    return Icon(
                                                      state
                                                          ? Icons
                                                                .flash_on_rounded
                                                          : Icons
                                                                .flash_off_rounded,
                                                      size: 26,
                                                      color: state
                                                          ? Colors.yellow
                                                          : Colors.white,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 16),

                                            // Switch camera button
                                            GestureDetector(
                                              onTap: () async {
                                                await _controller
                                                    .switchCamera();
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  border: Border.all(
                                                    color: Colors.yellow,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.cameraswitch_outlined,
                                                  size: 26,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 16),

                                            // Image picker button
                                            GestureDetector(
                                              onTap: _pickAndScanImage,
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  border: Border.all(
                                                    color: Colors.yellow,
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.photo_library_outlined,
                                                  size: 26,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : (_imgPicked == true)
                      ? (_imageFile != null)
                            ? Container(
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: InteractiveViewer(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Image.file(_imageFile!),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: Colors.white54,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 24,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _imgPicked = false;
                                              });
                                            },
                                          ),
                                          GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Icon(
                                                Icons
                                                    .add_photo_alternate_rounded,
                                                size: 24,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _imgPicked = true;
                                              });
                                              _pickAndScanImage();
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Icon(
                                              Icons.zoom_out_map,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                      : Container(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppThemes.getSurfaceColor(context),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: _isbusy
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF6C63FF),
                                    Color(0xFF5A52FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Scanning Image...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppThemes.getTextColor(context),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Please wait while we analyze your image',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppThemes.getTextColor(
                                  context,
                                ).withOpacity(0.7),
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (result != null && result != 'no_data') ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'QR Code Detected',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        color: AppThemes.getTextColor(context),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: 70,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppThemes.getCardColor(context),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppThemes.getDividerColor(context),
                                      width: 1,
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: SelectableText(
                                      '${result.toString()}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: (_is_result_url == true)
                                            ? Color(0xFF6C63FF)
                                            : AppThemes.getTextColor(context),
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue.shade300,
                                              Colors.blue.shade500,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.shade300,
                                              blurRadius: 12,
                                              offset: Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(text: '$result'),
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text('Copied to clipboard'),
                                                  ],
                                                ),
                                                backgroundColor: Color(
                                                  0xFF4CAF50,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.copy_outlined,
                                            size: 20,
                                          ),
                                          label: Text(
                                            'Copy',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        height: 52,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blue.shade300,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            String url = '$result';
                                            if (url.startsWith('http://') ||
                                                url.startsWith('https://') ||
                                                url.startsWith('www.')) {
                                              setState(() {
                                                _is_result_url = true;
                                              });
                                              launchUrl(Uri.parse(url));
                                            } else {
                                              setState(() {
                                                _is_result_url = false;
                                              });
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.error_outline,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Invalid URL'),
                                                    ],
                                                  ),
                                                  backgroundColor: Color(
                                                    0xFFFF5722,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  duration: Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.open_in_browser_outlined,
                                            size: 20,
                                          ),
                                          label: Text(
                                            'Open URL',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor:
                                                Colors.blue.shade300,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else if (result == 'no_data') ...[
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.amber[600],
                                  size: 58,
                                ),
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'No QR code found in image.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  'Ready to Scan',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppThemes.getTextColor(context),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Position a QR code inside the frame to scan it automatically',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppThemes.getTextColor(
                                      context,
                                    ).withOpacity(0.7),
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
