import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';
import 'package:pteri_wallet_clone/widgets/theme_toggle.dart';

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({Key? key}) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen>
    with SingleTickerProviderStateMixin {
  String _passcode = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onKeyPress(String value) {
    if (value == 'delete') {
      if (_passcode.isNotEmpty) {
        setState(
            () => _passcode = _passcode.substring(0, _passcode.length - 1));
      }
    } else if (_passcode.length < 4) {
      setState(() {
        _passcode += value;
        if (_passcode.length == 4) {
          // Navigate to confirm screen when 4 digits entered
          final walletName =
              ModalRoute.of(context)!.settings.arguments as String;

          // Add animation before navigation
          _animationController.reverse().then((_) {
            Navigator.pushNamed(context, '/confirm_passcode', arguments: {
              'passcode': _passcode,
              'walletName': walletName,
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Create Passcode',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  themeProvider.isDarkMode ? Colors.white : Color(0xff1a1a2e)),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ThemeToggleButton(),
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Passcode boxes with enhanced styling
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      4,
                      (index) => _buildPasscodeBox(
                            index < _passcode.length,
                            themeProvider.isDarkMode,
                          )),
                ),
                const SizedBox(height: 30),
                // Enhanced instruction text
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Enter a 4-digit passcode to secure your wallet',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeProvider.isDarkMode
                          ? Colors.white.withOpacity(0.9)
                          : Colors.black.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12.5),
                // Enhanced keypad
                Expanded(
                  child: _buildKeypad(themeProvider.isDarkMode),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasscodeBox(bool filled, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: filled
            ? const LinearGradient(
                colors: [
                  Color(0xFF3A86FF),
                  Color(0xFF7209B7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: filled
            ? null
            : isDarkMode
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: filled
            ? [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
    );
  }

  Widget _buildKeypad(bool isDarkMode) {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'delete'
    ];

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: const EdgeInsets.all(24.0),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: keys.map((key) {
        return GestureDetector(
          onTap: key.isEmpty ? null : () => _onKeyPress(key),
          child: Container(
            decoration: BoxDecoration(
              gradient: key.isNotEmpty
                  ? LinearGradient(
                      colors: isDarkMode
                          ? [
                              const Color(0xFF2C2C44),
                              const Color(0xFF3D3D5C),
                            ]
                          : [
                              const Color(0xFFD2E0FB),
                              const Color(0xFFB9D4FF),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(50),
              boxShadow: key.isNotEmpty
                  ? [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: key == 'delete'
                  ? Icon(
                      Icons.backspace,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.9)
                          : Colors.black.withOpacity(0.7),
                      size: 28,
                    )
                  : Text(
                      key,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black.withOpacity(0.7),
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
