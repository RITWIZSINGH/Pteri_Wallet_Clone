// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pteri_wallet_clone/services/wallet_service.dart';

class ConfirmPasscodeScreen extends StatefulWidget {
  const ConfirmPasscodeScreen({super.key});

  @override
  _ConfirmPasscodeScreenState createState() => _ConfirmPasscodeScreenState();
}

class _ConfirmPasscodeScreenState extends State<ConfirmPasscodeScreen> {
  String _confirmPasscode = '';
  bool _isLoading = false;

  void _onKeyPress(String value) async {
    if (value == 'delete') {
      if (_confirmPasscode.isNotEmpty) {
        setState(() => _confirmPasscode =
            _confirmPasscode.substring(0, _confirmPasscode.length - 1));
      }
    } else if (_confirmPasscode.length < 4) {
      setState(() {
        _confirmPasscode += value;
        if (_confirmPasscode.length == 4) {
          _verifyAndCreateWallet();
        }
      });
    }
  }

  Future<void> _verifyAndCreateWallet() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final originalPasscode = args['passcode'] as String;
    final walletName = args['walletName'] as String;

    if (!WalletService.verifyPasscodes(originalPasscode, _confirmPasscode)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passcodes do not match')));
      setState(() => _confirmPasscode = '');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await WalletService.createWallet(walletName);
      if (kDebugMode) {
        print("this is the response: $response");
      }
      if (response['successful']) {
        // Store wallet data
        await WalletService.saveWalletData(_confirmPasscode, walletName);

        Navigator.pushReplacementNamed(context, '/dashboard',
            arguments: response['data']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Wallet creation failed: ${response['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Passcode'),
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      4,
                      (index) =>
                          _buildPasscodeBox(index < _confirmPasscode.length)),
                ),
                const SizedBox(height: 20),
                const Text('Re-enter your passcode to confirm'),
                const SizedBox(height: 40),
                _buildKeypad(),
              ],
            ),
    );
  }

  Widget _buildPasscodeBox(bool filled) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: filled ? Colors.purple : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildKeypad() {
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
      padding: const EdgeInsets.all(16.0),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: keys.map((key) {
        return GestureDetector(
          onTap: key.isEmpty ? null : () => _onKeyPress(key),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: key == 'delete'
                  ? const Icon(Icons.backspace, color: Colors.white)
                  : Text(key,
                      style:
                          const TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
