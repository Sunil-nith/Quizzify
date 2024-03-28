import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        hintColor: Colors.deepPurpleAccent, 
        scaffoldBackgroundColor:
            Colors.white, 
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              color: Colors.black87), 
          bodyMedium: TextStyle(
              color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                Colors.deepPurple, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8.0), 
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Colors.deepPurple, 
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold, 
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
