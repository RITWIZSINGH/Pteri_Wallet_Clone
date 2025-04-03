import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode 
              ? Colors.purple.withOpacity(0.3) 
              : Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: themeProvider.isDarkMode ? Colors.amber : Colors.indigo,
        ),
        onPressed: () {
          themeProvider.toggleTheme();
        },
      ),
    );
  }
}