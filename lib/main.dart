import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:swiftscan/bloc/firstime_cubit.dart';
import 'package:swiftscan/bloc/haptic_cubit.dart';
import 'package:swiftscan/bloc/history_cubit.dart';
import 'package:swiftscan/bloc/locale_cubit.dart';
import 'package:swiftscan/bloc/page_cubit.dart';
import 'package:swiftscan/bloc/theme_cubit.dart';
import 'package:swiftscan/bloc/torch_state.dart';
import 'package:swiftscan/constants/app_themes.dart';
import 'package:swiftscan/l10n/app_localizations.dart';
import 'package:swiftscan/pages/about_page.dart';
import 'package:swiftscan/pages/history_page.dart';
import 'package:swiftscan/pages/home.dart';
import 'package:swiftscan/pages/intro_page.dart';
import 'package:swiftscan/pages/setting_page.dart';
import 'package:swiftscan/providers/states_check.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return HomePageState();
          },
        ),
      ],
      child: SwiftScanApp(),
    ),
  );
}

class SwiftScanApp extends StatelessWidget {
  const SwiftScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PageCubit()),
        BlocProvider(create: (context) => TorchCubit()),
        BlocProvider(create: (context) => HistoryCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => HapticCubit()),
        BlocProvider(create: (context) => FirstimeCubit()),
        BlocProvider(create: (context) => LocaleCubit()),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                title: 'Swift Scan',
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: themeState == AppTheme.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: locale,
                home: BlocBuilder<FirstimeCubit, bool>(
                  builder: (context, isFirstTime) {
                    // Check if it's the first time the user is using the app
                    if (isFirstTime == false) {
                      return const IntroPage();
                    } else {
                      return const QrCodeScanner();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  var _pages = [Home(), HistoryPage(), SettingsPage(), AboutPage()];
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PageCubit, int>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: AppThemes.getPrimaryColor(context),
            buttonBackgroundColor: AppThemes.getCardColor(context),
            color: AppThemes.getCardColor(context),
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            onTap: (index) {
              BlocProvider.of<PageCubit>(context).setPage(index);
            },
            items: [
              CurvedNavigationBarItem(
                child: Icon(
                  Icons.qr_code,
                  color: AppThemes.getPrimaryColor(context),
                ),
                label: l10n.navScan,
                labelStyle: TextStyle(
                  color: AppThemes.getTextColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              CurvedNavigationBarItem(
                child: Icon(
                  Icons.history,
                  color: AppThemes.getPrimaryColor(context),
                ),
                label: l10n.navHistory,
                labelStyle: TextStyle(
                  color: AppThemes.getTextColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              CurvedNavigationBarItem(
                child: Icon(
                  Icons.settings,
                  color: AppThemes.getPrimaryColor(context),
                ),
                label: l10n.navSettings,
                labelStyle: TextStyle(
                  color: AppThemes.getTextColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              CurvedNavigationBarItem(
                child: Icon(
                  Icons.info,
                  color: AppThemes.getPrimaryColor(context),
                ),
                label: l10n.navAbout,
                labelStyle: TextStyle(
                  color: AppThemes.getTextColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          body: BlocBuilder<PageCubit, int>(
            builder: (context, state) {
              return _pages[state];
            },
          ),
        );
      },
    );
  }
}
