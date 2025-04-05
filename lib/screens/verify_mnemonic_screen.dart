import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';
import 'package:pteri_wallet_clone/services/wallet_service.dart';

class VerifyMnemonicScreen extends StatefulWidget {
  const VerifyMnemonicScreen({Key? key}) : super(key: key);

  @override
  _VerifyMnemonicScreenState createState() => _VerifyMnemonicScreenState();
}

class _VerifyMnemonicScreenState extends State<VerifyMnemonicScreen> {
  final List<int> _verificationIndices = [];
  final List<String> _selectedWords = [];
  final List<int> _currentWordOptions = [];
  late Map<String, dynamic> _walletData;
  late List<String> _mnemonicList;
  int _currentStep = 0;
  bool _isLoading = false;
  Random _random = Random();
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupVerification();
  }
  
  void _setupVerification() {
    _walletData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _mnemonicList = (_walletData['mnemonics'] as String).split(' ');
    
    // Reset state
    _verificationIndices.clear();
    _selectedWords.clear();
    _currentWordOptions.clear();
    
    // Choose 3 random words to verify
    while (_verificationIndices.length < 3) {
      int index = _random.nextInt(12);
      if (!_verificationIndices.contains(index)) {
        _verificationIndices.add(index);
      }
    }
    
    // Sort indices to display them in order
    _verificationIndices.sort();
    
    // Set up options for the first word
    _setupOptionsForCurrentWord();
  }
  
  void _setupOptionsForCurrentWord() {
    _currentWordOptions.clear();
    int correctIndex = _verificationIndices[_currentStep];
    _currentWordOptions.add(correctIndex);
    
    // Add two random incorrect options
    while (_currentWordOptions.length < 3) {
      int randomIndex = _random.nextInt(12);
      if (!_currentWordOptions.contains(randomIndex)) {
        _currentWordOptions.add(randomIndex);
      }
    }
    
    // Shuffle options
    _currentWordOptions.shuffle();
  }
  
  void _selectWord(String word) {
    setState(() {
      _selectedWords.add(word);
      if (_currentStep < 2) {
        _currentStep++;
        _setupOptionsForCurrentWord();
      } else {
        _verifyAndProceed();
      }
    });
  }
  
  void _verifyAndProceed() async {
    bool allCorrect = true;
    for (int i = 0; i < _verificationIndices.length; i++) {
      int index = _verificationIndices[i];
      if (_selectedWords[i] != _mnemonicList[index]) {
        allCorrect = false;
        break;
      }
    }
    
    if (allCorrect) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Save the encrypted wallet data to SharedPreferences
        await WalletService.saveCompleteWalletData(_walletData, _walletData['passcode'] ?? '');
        
        setState(() {
          _isLoading = false;
        });
        
        // Navigate to dashboard
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/dashboard', 
          (route) => false,
          arguments: _walletData,
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving wallet data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect words. Please try again.')),
      );
      
      setState(() {
        _currentStep = 0;
        _selectedWords.clear();
        _setupOptionsForCurrentWord();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: const Text('Verify Recovery Phrase'),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify Your Recovery Phrase',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Select the correct word for each position:',
                  style: TextStyle(
                    fontSize: 16,
                    color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Word ${_verificationIndices[_currentStep] + 1}:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                ...List.generate(_currentWordOptions.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => _selectWord(_mnemonicList[_currentWordOptions[index]]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        foregroundColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _mnemonicList[_currentWordOptions[index]],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / 3,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7209B7)),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_currentStep + 1} of 3 words verified',
                  style: TextStyle(
                    fontSize: 14,
                    color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}