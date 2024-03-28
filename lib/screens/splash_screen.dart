import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quiz_app/screens/start_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _animationTimer;
  late Timer _navigateTimer;
  String _displayText = '';

  bool _showSecondText = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _startNavigationTimer();
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    _navigateTimer.cancel();
    super.dispose();
  }

  void _startAnimation() {
    int index = 0;
    const String text = 'Quizzify';

    _animationTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (index < text.length) {
        setState(() {
          _displayText += text[index];
        });
        index++;
      } else {
        _animationTimer.cancel();
        Timer(const Duration(milliseconds: 200), () {
          setState(() {
            _showSecondText = true;
          });
        });
      }
    });
  }

  void _startNavigationTimer() {
    _navigateTimer = Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Wrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _displayText,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            if (!_showSecondText)
              Container(
                height: 50,
              ),
            if (_showSecondText)
              Container(
                height: 50,
                child: Text(
                  "Let's create, share, and participate",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
