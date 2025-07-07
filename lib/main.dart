import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_food_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(NutrifitApp());
}

class NutrifitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NUTRIFIT',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Color(0xFFFF6B35),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/add-food': (context) => AddFoodScreen(),
        '/history': (context) => HistoryScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}