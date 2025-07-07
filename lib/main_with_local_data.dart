import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_food_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';
import 'services/food_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local data services
  await AuthService.initialize();
  await FoodService.initialize();
  
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
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          
          if (snapshot.data == true) {
            return HomeScreen();
          } else {
            return SplashScreen();
          }
        },
      ),
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