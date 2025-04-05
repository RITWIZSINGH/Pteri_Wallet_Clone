import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

class WalletService {
  static const String _apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InJpdHdpenNpbmdoMDA3QGdtYWlsLmNvbSIsInJvbGUiOiJEZXZlbG9wZXIiLCJuYmYiOjE3NDM1OTgzNDgsImV4cCI6MTkwMTM2NDc0OCwiaWF0IjoxNzQzNTk4MzQ4LCJpc3MiOiJHcmVhdF9QdGVyaSIsImF1ZCI6IkFwcHVzZXIifQ.VEdKCL072bzov6yk8yabT9DQzKP0d24GWG2DCEJBYd0';
  
  // Method to verify passcodes match
  static bool verifyPasscodes(String originalPasscode, String confirmPasscode) {
    return originalPasscode == confirmPasscode;
  }
  
  // Method to create a new wallet
  static Future<Map<String, dynamic>> createWallet(String walletName) async {
    try {
      final url = Uri.parse(
          'https://pteri.xyz/api/Wallet/create-importable-encrypted-wallet');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'Usev2': 'true',
      };
      
      // Generate a unique wallet name with a UUID suffix
      final uniqueWalletName = '${walletName}_${_generateUuid()}';
      final body = jsonEncode({'wallet_name': uniqueWalletName});

      final response = await http.post(url, headers: headers, body: body);
      if (kDebugMode) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
      
      if (response.statusCode != 200) {
        return {
          'successful': false,
          'message': 'API error: ${response.statusCode}',
          'data': null
        };
      }
      
      final responseData = jsonDecode(response.body);
      
      // Check if API response is successful
      if (responseData['successful'] == true) {
        // Extract mnemonics from response
        final mnemonics = responseData['data']['mnemonics'] as String;
        
        // Encrypt the passphrase
        final encryptedPassphrase = _encryptPassphrase(mnemonics);
        
        // Return wallet data including mnemonics for backup process
        return {
          'successful': true,
          'message': 'Wallet created successfully',
          'data': {
            'walletName': uniqueWalletName,
            'encryptedPassphrase': encryptedPassphrase,
            'mnemonics': mnemonics
          }
        };
      } else {
        return {
          'successful': false,
          'message': responseData['message'] ?? 'Unknown error',
          'data': null
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating wallet: $e");
      }
      return {
        'successful': false,
        'message': 'Error: $e',
        'data': null
      };
    }
  }
  
  // Method to get default address
  static Future<String> getDefaultAddress(String mnemonics, int addressType) async {
    try {
      final url = Uri.parse(
          'https://pteri.xyz/api/Wallet/default-address?addressType=$addressType');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'Usev2': 'true',
        'mnemonics': mnemonics,
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode != 200) {
        return '';
      }
      
      final responseData = jsonDecode(response.body);
      if (responseData['successful'] == true) {
        return responseData['data']['address'] as String;
      } else {
        return '';
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting address: $e");
      }
      return '';
    }
  }
  
  // Method to save wallet data in SharedPreferences
  static Future<void> saveWalletData(String passcode, String walletName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('passcode', passcode);
    await prefs.setString('walletName', walletName);
  }
  
  // Method to save all wallet details
  static Future<void> saveCompleteWalletData(Map<String, dynamic> walletData, String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('passcode', passcode);
    // await prefs.setString('walletName', walletData['walletName']);
    await prefs.setString('encryptedPassphrase', walletData['encryptedPassphrase']);
    // Note: For security reasons, we don't save mnemonics directly in SharedPreferences
  }
  
  // Generate a simple UUID
  static String _generateUuid() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final uuid = sha256.convert(utf8.encode(random)).toString();
    return uuid.substring(0, 8) + '-' + 
           uuid.substring(8, 12) + '-' + 
           uuid.substring(12, 16) + '-' + 
           uuid.substring(16, 20) + '-' + 
           uuid.substring(20, 32);
  }
  
  // Encrypt passphrase using AES encryption
  static String _encryptPassphrase(String phrase) {
    try {
      // In a real app, you'd use a secure key management system
      final encryptionKey = 'ThisIsASecureEncryptionKey123456789!';
      final key = encrypt.Key(utf8.encode(encryptionKey).sublist(0, 32));
      final iv = encrypt.IV.fromLength(16);
      
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(phrase, iv: iv);
      
      return encrypted.base64;
    } catch (e) {
      if (kDebugMode) {
        print("Encryption error: $e");
      }
      return '';
    }
  }
  
  // Decrypt passphrase
  static String decryptPassphrase(String encryptedPhrase) {
    try {
      final encryptionKey = 'ThisIsASecureEncryptionKey123456789!';
      final key = encrypt.Key(utf8.encode(encryptionKey).sublist(0, 32));
      final iv = encrypt.IV.fromLength(16);
      
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt64(encryptedPhrase, iv: iv);
      
      return decrypted;
    } catch (e) {
      if (kDebugMode) {
        print("Decryption error: $e");
      }
      return '';
    }
  }
}