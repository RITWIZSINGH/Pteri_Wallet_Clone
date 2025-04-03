import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';
import 'package:pteri_wallet_clone/widgets/theme_toggle.dart';
import 'package:pteri_wallet_clone/widgets/clipboard_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
   String walletName = 'Loading...';
  
  @override
  void initState() {
    super.initState();
    _loadWalletName();
  }

  Future<void> _loadWalletName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      walletName = prefs.getString('walletName') ?? 'N/A';
    });
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final walletData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print("This is the walletData:$walletData");
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Wallet Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ThemeToggleButton(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.isDarkMode
                ? [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                  ]
                : [
                    const Color(0xFFE3F4F4),
                    const Color(0xFFD2E0FB),
                    const Color(0xFFC2DEDC),
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  color: themeProvider.isDarkMode
                      ? const Color(0xFF2C2C44)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet Created Successfully!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Wallet Name: $walletName',
                          style: TextStyle(
                            fontSize: 16,
                            color: themeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.9)
                                : Colors.black.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Address:                 ************* ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.6),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ClipboardButton(
                              text: walletData['encryptedPassphrase'] ?? '',
                              themeProvider: themeProvider,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF3A86FF),
                        Color(0xFF7209B7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '0 LTC',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white70,
                        size: 40,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.arrow_upward,
                      'Send',
                      () {},
                      themeProvider.isDarkMode,
                    ),
                    _buildActionButton(
                      context,
                      Icons.arrow_downward,
                      'Receive',
                      () {},
                      themeProvider.isDarkMode,
                    ),
                    _buildActionButton(
                      context,
                      Icons.swap_horiz,
                      'Swap',
                      () {},
                      themeProvider.isDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'No transactions yet',
                      style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? Colors.white.withOpacity(0.6)
                            : Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
    bool isDarkMode,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(20),
              shape: const CircleBorder(),
            ).copyWith(
              backgroundColor: WidgetStateProperty.all(
                Colors.transparent,
              ),
              overlayColor: WidgetStateProperty.all(
                Colors.white.withOpacity(0.1),
              ),
            ),
            child: Ink(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3A86FF),
                    Color(0xFF7209B7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode
                ? Colors.white.withOpacity(0.9)
                : Colors.black.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}