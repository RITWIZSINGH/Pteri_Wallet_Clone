import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';
import 'package:pteri_wallet_clone/widgets/theme_toggle.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen>
    with SingleTickerProviderStateMixin {
  bool _isAtBottom = false;
  bool _isChecked = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 50 &&
        !_isAtBottom) {
      setState(() => _isAtBottom = true);
    }
  }

  // Handle back navigation with animation
  Future<void> _handleBackNavigation() async {
    _animationController.reverse();
  Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        await _handleBackNavigation();
        return false; // We handle the pop manually
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: themeProvider.isDarkMode ? Colors.white: const Color(0xff1a1a2e)),
            onPressed: _handleBackNavigation,
          ),
          title: Row(
            children: const [
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF16213E),
                Color(0xFF0F3460),
                Color(0xFF1A1A2E),
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SizedBox(
                    height: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          // Placeholder terms; replace with actual terms
                          'Welcome to Pteri Wallet ("App," "we," "us," or "our"). These Terms and Conditions ("Terms") govern your access to and use of our crypto wallet application and related services. By using our App, you agree to abide by these Terms. If you do not agree, please do not use our services.\n\n'
                          '1. Eligibility\n\n'
                          'To use our App, you must:\n\n'
                          'Be at least 18 years old or the legal age of majority in your jurisdiction.\n\n'
                          'Not be prohibited from using cryptocurrency services under applicable laws.\n\n'
                          'Provide accurate and complete registration information.\n\n'
                          '2. Wallet Services\n\n'
                          'Our App allows you to store, send, receive, and manage supported cryptocurrencies.\n\n'
                          'We do not control or have access to your private keys, and we cannot recover lost or stolen private keys.\n\n'
                          'Transactions made through the App are irreversible and final.\n\n'
                          '3. Security & Responsibility\n\n'
                          'You are responsible for safeguarding your private keys, passwords, and seed phrases.\n\n'
                          'We are not liable for any loss resulting from unauthorized access due to compromised credentials.\n\n'
                          'We recommend using strong security practices, such as two-factor authentication (2FA).\n\n'
                          '4. Fees\n\n'
                          'Our App may charge transaction fees, which will be clearly disclosed before execution.\n\n'
                          'Blockchain network fees may also apply and are beyond our control.\n\n'
                          '5. Risks\n\n'
                          'Cryptocurrency transactions are subject to price volatility, regulatory changes, and security threats.\n\n'
                          'We do not provide investment advice or guarantee the security or value of cryptocurrencies.\n\n'
                          '6. Prohibited Activities\n\n'
                          'You agree not to use our App for:\n\n'
                          'Illegal or fraudulent activities, including money laundering and terrorism financing.\n\n'
                          'Circumventing any security measures.\n\n'
                          'Violating any applicable laws and regulations.\n\n'
                          '7. Third-Party Services\n\n'
                          'Our App may integrate with third-party services, such as exchanges or blockchain explorers.\n\n'
                          'We are not responsible for the performance, availability, or security of third-party services.\n\n'
                          '8. Limitation of Liability\n\n'
                          'We are not liable for any direct, indirect, incidental, or consequential damages arising from your use of the App.\n\n'
                          'Our liability is limited to the maximum extent permitted by law.\n\n'
                          '9. Termination\n\n'
                          'We may suspend or terminate your access to the App if you violate these Terms.\n\n'
                          'You may stop using the App at any time without prior notice.\n\n'
                          '10. Changes to Terms\n\n'
                          'We reserve the right to update these Terms at any time. Changes will be posted in the App, and continued use signifies acceptance.\n\n'
                          '11. Governing Law\n\n'
                          'These Terms shall be governed by and construed in accordance with the laws of Jurisdiction.\n\n'
                          '12. Contact Us\n\n'
                          'For any questions or concerns, please contact us at .\n\n'
                          'By using Pteri Wallet, you acknowledge that you have read, understood, and agreed to these Terms and Conditions.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text(
                          'I agree to the terms and conditions',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                _isChecked ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        value: _isChecked,
                        onChanged: _isAtBottom
                            ? (value) => setState(() => _isChecked = value!)
                            : null,
                        activeColor: const Color(0xFF4361EE),
                        checkColor: Colors.white,
                        subtitle: !_isAtBottom
                            ? const Text(
                                'Please scroll to the bottom to enable this option',
                                style: TextStyle(
                                  color: Color(0xFFFF006E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: _isChecked
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF3A86FF)
                                          .withOpacity(0.5),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                          child: ElevatedButton(
                            onPressed: _isChecked
                                ? () {
                                    // Add a fade-out animation before navigation
                                    _animationController.reverse().then((_) {
                                      Navigator.pushNamed(
                                          context, '/wallet_name');
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              disabledForegroundColor:
                                  Colors.grey.withOpacity(0.6),
                              disabledBackgroundColor:
                                  Colors.grey.withOpacity(0.1),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ).copyWith(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.grey.withOpacity(0.1);
                                }
                                return Colors.transparent;
                              }),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: _isChecked
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
                                color: _isChecked
                                    ? null
                                    : Colors.grey.withOpacity(0.1),
                              ),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: const Text(
                                  'Accept',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}