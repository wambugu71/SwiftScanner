import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:swiftscan/bloc/firstime_cubit.dart';
import 'package:swiftscan/constants/colors_cont.dart';
import 'package:swiftscan/l10n/app_localizations.dart';
import 'package:swiftscan/main.dart';
import 'package:swiftscan/models/intro_progress.dart';
import 'package:swiftscan/providers/states_check.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  final double _radius = 6;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = pry_color; //Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDarkMode ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FA),
              isDarkMode ? const Color(0xFF16213E) : const Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _buttonAnimationController.reset();
                  _buttonAnimationController.forward();
                });
              },
              children: [
                _buildPageContent(
                  lottieAsset: 'assets/lottie/welcome.json',
                  title: l10n.introWelcome,
                  subtitle: l10n.introDesc1,
                ),
                _buildPageContent(
                  lottieAsset: 'assets/lottie/qrcode.json',
                  title: l10n.introTitle1,
                  subtitle: l10n.introDesc2,
                ),
                _buildPageContent(
                  lottieAsset: 'assets/lottie/done.json',
                  title: l10n.introTitle3,
                  subtitle: l10n.introDesc3,
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: isDarkMode
                            ? Colors.grey[800]!.withOpacity(0.6)
                            : Colors.white.withOpacity(0.7),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IntroProgres(
                            color: (_currentPage == 0)
                                ? primaryColor
                                : Colors.grey.withOpacity(0.5),
                            radius: _radius,
                          ),
                          IntroProgres(
                            color: (_currentPage == 1)
                                ? primaryColor
                                : Colors.grey.withOpacity(0.5),
                            radius: _radius,
                          ),
                          IntroProgres(
                            color: (_currentPage == 2)
                                ? primaryColor
                                : Colors.grey.withOpacity(0.5),
                            radius: _radius,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      width: _currentPage == 2 ? double.infinity : 150,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 24.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          if (_currentPage < 2) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutCubic,
                            );
                          } else {
                            await _requestPermissions();
                            // Set first time to false using FirstimeCubit
                            await context.read<FirstimeCubit>().setFirstTime();
                            await Future.delayed(Duration(milliseconds: 300));
                            // Navigate to main app
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  Provider.of<HomePageState>(
                                    context,
                                    listen: false,
                                  ).is_home_exited = true;
                                  return const QrCodeScanner();
                                },
                              ),
                            );
                          }
                        },
                        child: Text(
                          _currentPage == 2
                              ? l10n.introGetStarted
                              : l10n.introNext,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    // Permission handler
    bool cameraPermission = await Permission.camera.isGranted;
    bool storagePermission = await Permission.storage.isGranted;
    if (cameraPermission == false && storagePermission == false) {
      await Permission.storage.request();
      await Permission.camera.request();
      await Permission.phone.request();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera and storage permissions are required.')),
      );
      return;
    }
  }

  Widget _buildPageContent({
    required String lottieAsset,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Hero(
            tag: lottieAsset,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Lottie.asset(
                lottieAsset,
                animate: true,
                frameRate: FrameRate.max,
                options: LottieOptions(enableMergePaths: true),
                repeat: _currentPage < 2,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
