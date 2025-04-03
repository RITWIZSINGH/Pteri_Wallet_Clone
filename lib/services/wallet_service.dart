import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WalletService {
  static const String _apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InJpdHdpenNpbmdoMDA3QGdtYWlsLmNvbSIsInJvbGUiOiJEZXZlbG9wZXIiLCJuYmYiOjE3NDM1OTgzNDgsImV4cCI6MTkwMTM2NDc0OCwiaWF0IjoxNzQzNTk4MzQ4LCJpc3MiOiJHcmVhdF9QdGVyaSIsImF1ZCI6IkFwcHVzZXIifQ.VEdKCL072bzov6yk8yabT9DQzKP0d24GWG2DCEJBYd0';
  
  // Method to verify passcodes match
  static bool verifyPasscodes(String originalPasscode, String confirmPasscode) {
    return originalPasscode == confirmPasscode;
  }
  
  // Method to create a new wallet
  static Future<Map<String, dynamic>> createWallet(String walletName) async {
    final url = Uri.parse(
        'https://pteri.xyz/api/Wallet/create-importable-encrypted-wallet');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
      'Usev2': 'true',
    };
    final body = jsonEncode({'wallet_name': walletName});

    final response = await http.post(url, headers: headers, body: body);
    if (kDebugMode) {
      print("this is the response after creating wallet: $response");
    }
    return jsonDecode(response.body);
  }
  
  // Method to save wallet data in SharedPreferences
  static Future<void> saveWalletData(String passcode, String walletName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('passcode', passcode);
    await prefs.setString('walletName', walletName);
  }

  
}