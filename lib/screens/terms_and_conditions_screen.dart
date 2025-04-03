import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsScreenState createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isAtBottom = false;
  bool _isChecked = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 50 &&
        !_isAtBottom) {
      setState(() => _isAtBottom = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms and Conditions')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text('I agree to the terms and conditions'),
                  value: _isChecked,
                  onChanged: _isAtBottom
                      ? (value) => setState(() => _isChecked = value!)
                      : null,
                  activeColor: Colors.purple,
                  subtitle: !_isAtBottom
                      ? const Text(
                          'Please scroll to the bottom to enable this option',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _isChecked
                        ? () => Navigator.pushNamed(context, '/wallet_name')
                        : null,
                    child: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
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