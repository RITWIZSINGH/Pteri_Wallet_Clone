import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'P',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Premier web 3 wallet exclusive to Litecoin.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Secure your holdings with self-custody and privacy using Litecoin, now MWEB-enabled.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/terms'),
                child: Text('+ Create New Wallet'),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Import Wallet not implemented')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
                  side: BorderSide(
                    color: Theme.of(context).textTheme.bodyMedium!.color!,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('+ Import Wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}