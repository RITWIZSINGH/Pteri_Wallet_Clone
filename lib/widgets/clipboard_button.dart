import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';

class ClipboardButton extends StatelessWidget {
  final String text;
  final ThemeProvider themeProvider;

  const ClipboardButton({
    Key? key,
    required this.text,
    required this.themeProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Address copied to clipboard',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: themeProvider.isDarkMode
                ? const Color(0xFF3A0CA3)
                : const Color(0xFF4361EE),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      icon: Icon(
        Icons.copy,
        color: themeProvider.isDarkMode
            ? Colors.white.withOpacity(0.8)
            : Colors.black.withOpacity(0.7),
        size: 20,
      ),
      tooltip: 'Copy to clipboard',
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(8),
    );
  }
}