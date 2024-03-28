import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/home_page.dart';
import 'package:quiz_app/screens/sign_in.dart';
import 'package:quiz_app/screens/sign_up.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _showSignIn = true;

  void _toggleForm() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage() ;
            } else {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _showSignIn ? const SignInPage() : const SignUpPage(),
                      const SizedBox(height: 20.0),
                      Text(
                        _showSignIn ? "Don't have an account?" : 'Already have an account?',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      GestureDetector(
                        onTap: _toggleForm,
                        child: Text(
                          _showSignIn ? ' Sign Up' : ' Sign In',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
