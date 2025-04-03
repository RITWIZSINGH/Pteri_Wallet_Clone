import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';
import 'package:pteri_wallet_clone/screens/confirm_passcode_screen.dart';
import 'package:pteri_wallet_clone/screens/intro_screen.dart';
import 'package:pteri_wallet_clone/screens/passcode_screen.dart';
import 'package:pteri_wallet_clone/screens/terms_and_conditions_screen.dart';
import 'package:pteri_wallet_clone/screens/wallet_dashboard_screen.dart';
import 'package:pteri_wallet_clone/screens/wallet_name_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const PteriWalletApp(),
    ),
  );
}

class PteriWalletApp extends StatelessWidget {
  const PteriWalletApp({super.key});

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
            '/': (context) => IntroScreen(),
            '/terms': (context) => TermsAndConditionsScreen(),
            '/wallet_name': (context) => WalletNameScreen(),
            '/passcode': (context) => PasscodeScreen(),
            '/confirm_passcode': (context) => ConfirmPasscodeScreen(),
            '/dashboard': (context) => DashboardScreen(),
          },
        );
      },
    );
  }
}

final _lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.purple,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

// Dark Theme Definition
final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.purple,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
