import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';
import 'package:pteri_wallet_clone/screens/terms_and_conditions_screen.dart';
import 'package:pteri_wallet_clone/widgets/theme_toggle.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward(); // Initial fade-in
  }

  

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
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
            child: Stack(
              children: [
                // Theme toggle button in top-right corner
                const Positioned(
                  top: 16,
                  right: 16,
                  child: ThemeToggleButton(),
                ),

                // Main content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Enhanced Logo with glow effect
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.65),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color.fromARGB(255, 89, 145, 212),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/logo2.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Enhanced title
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF8ECDDD),
                              Color(0xFFE3F4F4),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            'Premier web 3 wallet exclusive to Litecoin.',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Enhanced subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Secure your holdings with self-custody and privacy using Litecoin, now MWEB-enabled.',
                            style: TextStyle(
                              fontSize: 16,
                              color: themeProvider.isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black.withOpacity(0.8),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Enhanced Create Wallet Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3A86FF).withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Add animation before navigation
                              _animationController.reverse().then((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TermsAndConditionsScreen()),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ).copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              overlayColor: WidgetStateProperty.all(
                                Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.5,
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3A86FF),
                                    Color(0xFF4361EE),
                                    Color(0xFF7209B7),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                child: const Text(
                                  ' Create New Wallet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Enhanced Import Wallet Button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Import Wallet not implemented',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: themeProvider.isDarkMode
                                      ? const Color(0xFF3A0CA3)
                                      : const Color(0xFF4361EE),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              side: BorderSide(
                                color: themeProvider.isDarkMode
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.black.withOpacity(0.5),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.arrow_right_alt_sharp),
                                  Text(
                                    ' Import Wallet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeProvider.isDarkMode
                                          ? Colors.white.withOpacity(0.9)
                                          : Colors.black.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
    );
  }
}