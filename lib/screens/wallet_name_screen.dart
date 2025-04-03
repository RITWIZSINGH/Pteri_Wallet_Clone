import 'package:flutter/material.dart';
import 'dart:ui';

class WalletNameScreen extends StatefulWidget {
  const WalletNameScreen({Key? key}) : super(key: key);

  @override
  State<WalletNameScreen> createState() => _WalletNameScreenState();
}

class _WalletNameScreenState extends State<WalletNameScreen>
    with SingleTickerProviderStateMixin {
  final _walletNameController = TextEditingController();
  bool _isValid = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _walletNameController.addListener(() {
      setState(() => _isValid = _walletNameController.text.trim().isNotEmpty);
    });

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Wallet',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced title with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF8ECDDD),
                        Color(0xFFE3F4F4),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Text(
                      'Welcome to Self-Custody',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtitle with opacity
                  Text(
                    'Enter a name for your new wallet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Enhanced text field with animations
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _walletNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Wallet Name',
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(16),
                        //   borderSide: const BorderSide(
                        //     color: Color(0xFF3A86FF),
                        //     width: 2,
                        //   ),
                        // ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(16),
                        //   borderSide: BorderSide(
                        //     color: Colors.white.withOpacity(0.3),
                        //   ),
                        // ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          onPressed: () => _walletNameController.clear(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Enhanced Next button with animations
                  Center(
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: _isValid
                            ? [
                                BoxShadow(
                                  color:
                                      const Color(0xFF3A86FF).withOpacity(0.5),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: ElevatedButton(
                        onPressed: _isValid
                            ? () {
                                // Add animation before navigation
                                _animationController.reverse().then((_) {
                                  Navigator.pushNamed(
                                    context,
                                    '/passcode',
                                    arguments: _walletNameController.text,
                                  );
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          disabledForegroundColor: Colors.grey.withOpacity(0.6),
                          disabledBackgroundColor: Colors.grey.withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey.withOpacity(0.1);
                              }
                              return Colors.transparent;
                            },
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: _isValid
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF3A86FF),
                                      Color(0xFF4361EE),
                                      Color(0xFF7209B7),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(28),
                            color:
                                _isValid ? null : Colors.grey.withOpacity(0.1),
                          ),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
}
