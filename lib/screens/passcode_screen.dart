// passcode_screen.dart
import 'package:flutter/material.dart';

class PasscodeScreen extends StatefulWidget {
  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _passcode = '';

  void _onKeyPress(String value) {
    if (value == 'delete') {
      if (_passcode.isNotEmpty) {
        setState(() => _passcode = _passcode.substring(0, _passcode.length - 1));
      }
    } else if (_passcode.length < 4) {
      setState(() {
        _passcode += value;
        if (_passcode.length == 4) {
          // Navigate to confirm screen when 4 digits entered
          final walletName = ModalRoute.of(context)!.settings.arguments as String;
          Navigator.pushNamed(context, '/confirm_passcode', 
            arguments: {
              'passcode': _passcode,
              'walletName': walletName,
            });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Passcode'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                4, (index) => _buildPasscodeBox(index < _passcode.length)),
          ),
          SizedBox(height: 20),
          Text('Enter a 4-digit passcode to secure your wallet'),
          SizedBox(height: 40),
          _buildKeypad(),
        ],
      ),
    );
  }

  Widget _buildPasscodeBox(bool filled) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: filled ? Colors.purple : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'delete'];
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: EdgeInsets.all(16.0),
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
                  ? Icon(Icons.backspace, color: Colors.white)
                  : Text(key,
                      style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ),
        );
      }).toList(),
    );
  }
}