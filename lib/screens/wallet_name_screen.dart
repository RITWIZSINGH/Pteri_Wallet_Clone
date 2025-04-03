import 'package:flutter/material.dart';

class WalletNameScreen extends StatefulWidget {
  @override
  _WalletNameScreenState createState() => _WalletNameScreenState();
}

class _WalletNameScreenState extends State<WalletNameScreen> {
  final _walletNameController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _walletNameController.addListener(() {
      setState(() => _isValid = _walletNameController.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Wallet'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Self-Custody',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Enter a wallet name'),
            SizedBox(height: 20),
            TextField(
              controller: _walletNameController,
              decoration: InputDecoration(
                labelText: 'Wallet Name',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple, width: 2)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _walletNameController.clear(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: _isValid
                    ? () => Navigator.pushNamed(context, '/passcode', arguments: _walletNameController.text)
                    : null,
                child: Text('Next', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

