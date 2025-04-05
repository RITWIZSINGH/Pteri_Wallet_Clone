import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';

class BackupInfoScreen extends StatelessWidget {
  const BackupInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final walletData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: const Text('Backup Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Important Security Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              themeProvider.isDarkMode,
              Icons.warning,
              'Never share your recovery phrase',
              'Anyone with your recovery phrase can access your wallet.',
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              themeProvider.isDarkMode,
              Icons.photo_camera_back,
              'Don\'t take screenshots',
              'Screenshots can be accessed by other apps.',
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              themeProvider.isDarkMode,
              Icons.save_alt,
              'Write it down',
              'Store your recovery phrase in a secure physical location.',
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/show_mnemonic',
                      arguments: walletData,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF7209B7),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'I understand',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDarkMode, IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 40,
            color: const Color(0xFF7209B7),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}