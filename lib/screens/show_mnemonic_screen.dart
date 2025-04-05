import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pteri_wallet_clone/providers/theme_provider.dart';
import 'package:pteri_wallet_clone/services/wallet_service.dart';

class ShowMnemonicScreen extends StatefulWidget {
  const ShowMnemonicScreen({Key? key}) : super(key: key);

  @override
  _ShowMnemonicScreenState createState() => _ShowMnemonicScreenState();
}

class _ShowMnemonicScreenState extends State<ShowMnemonicScreen> {
  bool _isLoading = false;
  String _mAddress = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateDefaultAddress();
  }

  Future<void> _generateDefaultAddress() async {
    final walletData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final mnemonics = walletData['mnemonics'] as String;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get default address with addressType = 2
      final address = await WalletService.getDefaultAddress(mnemonics, 2);
      print("this is the M address: $address");

      setState(() {
        _mAddress = address;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating address: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final walletData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final mnemonics = walletData['mnemonics'] as String;
    final mnemonicList = mnemonics.split(' ');

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: const Text('Recovery Phrase'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Recovery Phrase',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Write down these 12 words in order and keep them somewhere safe.',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeProvider.isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? Colors.grey[900]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: mnemonicList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF7209B7),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}.',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7209B7),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    mnemonicList[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Replace the entire M address display section with just a copy button for mnemonics
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy Recovery Phrase'),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: mnemonics));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Recovery phrase copied to clipboard')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF7209B7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      walletData['mAddress'] = _mAddress;
                      Navigator.pushNamed(
                        context,
                        '/verify_mnemonic',
                        arguments: walletData,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF7209B7),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'I\'ve written it down',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
