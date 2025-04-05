import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';
import 'package:pteri_wallet_clone/widgets/theme_toggle.dart';
import 'package:pteri_wallet_clone/widgets/clipboard_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  String walletName = 'Loading...';
  late AnimationController _animationController;
  late Animation<double> _balanceAnimation;
  bool _isLoaded = false;
  int? _activeButtonIndex;
  final List<AnimationController> _buttonControllers = [];

  @override
  void initState() {
    super.initState();
    _loadWalletName();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _balanceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    for (int i = 0; i < 4; i++) {
      _buttonControllers.add(AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ));
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _buttonControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadWalletName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        walletName = prefs.getString('walletName') ?? 'N/A';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final walletData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
        ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: const ThemeToggleButton()
                .animate()
                .fadeIn(delay: 200.ms, duration: 500.ms),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.settings,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 8,
                    color: themeProvider.isDarkMode
                        ? const Color(0xFF2C2C44)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
                                  'Address: ${walletData['mAddress']}',
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
                                text: walletData['mAddress'],
                                themeProvider: themeProvider,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _balanceAnimation,
                    builder: (context, child) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF3A86FF),
                              Color(0xFF7209B7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      '0',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: _balanceAnimation.value,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'LTC',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 50,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  _buildActionButtonsRow(themeProvider.isDarkMode),
                  const SizedBox(height: 25),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 50,
                            color: themeProvider.isDarkMode
                                ? Colors.white.withOpacity(0.3)
                                : Colors.black.withOpacity(0.3),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No transactions yet',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonsRow(bool isDarkMode) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(context, Icons.arrow_upward, 'Send', () {},
              isDarkMode, 0),
          _buildActionButton(context, Icons.arrow_downward, 'Receive', () {},
              isDarkMode, 1),
          _buildActionButton(context, Icons.credit_card, 'Buy', () {},
              isDarkMode, 2),
          _buildActionButton(context, Icons.security, 'MWEB', () {}, isDarkMode,
              3,
              isSpecial: true),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      IconData icon,
      String label,
      VoidCallback onPressed,
      bool isDarkMode,
      int index,
      {bool isSpecial = false}) {
    return AnimatedBuilder(
      animation: _buttonControllers[index],
      builder: (context, child) {
        final scale = 1.0 - (0.1 * _buttonControllers[index].value);
        final elevation = 5.0 + (5.0 * (1.0 - _buttonControllers[index].value));

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: isSpecial
                          ? Colors.green.withOpacity(0.4)
                          : Colors.purple.withOpacity(0.3),
                      blurRadius: elevation,
                      spreadRadius: elevation * 0.4,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _handleButtonPress(index);
                    onPressed();
                    Future.delayed(const Duration(milliseconds: 300),
                        () => _handleButtonRelease(index));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isSpecial
                            ? [
                                const Color(0xFF2CAD47),
                                const Color(0xFF107C39),
                              ]
                            : [
                                const Color(0xFF3A86FF),
                                const Color(0xFF7209B7),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
                color: isSpecial
                    ? (isDarkMode ? Colors.lightGreen : Colors.green)
                    : (isDarkMode
                        ? Colors.white.withOpacity(0.9)
                        : Colors.black.withOpacity(0.8)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleButtonPress(int index) {
    if (mounted) {
      setState(() {
        _activeButtonIndex = index;
      });
      _buttonControllers[index].forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleButtonRelease(int index) {
    if (mounted) {
      _buttonControllers[index].reverse().then((_) {
        if (mounted) {
          setState(() {
            if (_activeButtonIndex == index) {
              _activeButtonIndex = null;
            }
          });
        }
      });
    }
  }
}

class RipplePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  RipplePainter(this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3 * (1 - animationValue))
      ..style = PaintingStyle.fill;

    final radius = size.width / 2;
    final rippleRadius = radius * (0.5 + animationValue * 0.8);

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), rippleRadius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}