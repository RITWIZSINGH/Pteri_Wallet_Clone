import 'package:flutter/material.dart';
import 'package:pteri_wallet_clone/screens/intro_screen.dart';
import 'package:pteri_wallet_clone/screens/terms_and_conditions_screen.dart';

// Create a custom page route for transitions between screens
class FadePageRoute<T> extends PageRoute<T> {
  final Widget child;
  
  FadePageRoute({required this.child}) 
    : super(
        fullscreenDialog: false,
        settings: RouteSettings(name: child.runtimeType.toString()),
      );

  @override
  Color get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuint,
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);
}

// Add this to your main.dart to use these transitions
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pteri Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => IntroScreen());
          case '/terms':
            return FadePageRoute(child: TermsAndConditionsScreen());
          case '/wallet_name':
            // Replace with your wallet name screen
            return FadePageRoute(child: Placeholder());
          default:
            return MaterialPageRoute(builder: (_) => IntroScreen());
        }
      },
    );
  }
}