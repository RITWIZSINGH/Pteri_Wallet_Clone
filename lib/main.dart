// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/screens/confirm_passcode_screen.dart';
import 'package:pteri_wallet_clone/screens/passcode_screen.dart';
import 'package:pteri_wallet_clone/screens/wallet_dashboard_screen.dart';

import 'providers/theme_provider.dart';
import 'screens/intro_screen.dart';
import 'screens/terms_and_conditions_screen.dart';
import 'screens/wallet_name_screen.dart';
// Import other screens as needed


final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const PteriWalletApp(),
    ),
  );
}

class PteriWalletApp extends StatelessWidget {
  const PteriWalletApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pteri Wallet',
          theme: themeProvider.isDarkMode ? _darkTheme : _lightTheme,
          initialRoute: '/',
          routes: {
            '/': (context) =>  const IntroScreen(),
            '/terms': (context) => const TermsAndConditionsScreen(),
            '/wallet_name': (context) => const WalletNameScreen(),
            '/passcode': (context) =>  const PasscodeScreen(),
            '/confirm_passcode': (context) =>  const ConfirmPasscodeScreen(),
            '/dashboard': (context) =>  const DashboardScreen(),
          },
          navigatorObservers: [routeObserver],
        );
      },
    );
  }
}


// Dark Theme Definition (Default)
final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF7209B7),
  scaffoldBackgroundColor: const Color(0xFF1A1A2E),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F3460),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3A86FF),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
    ),
    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
  ),
);

// Light Theme Definition
final _lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4361EE),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF4361EE),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3A86FF),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.withOpacity(0.1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
    ),
    labelStyle: TextStyle(color: Colors.grey.shade700),
  ),
);