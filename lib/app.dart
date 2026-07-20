import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:transactional_app/features/login/presentation/screens/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Bakery Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6D4C41), // Brownish color for bakery
          primary: const Color(0xFF6D4C41),
          secondary: const Color(0xFF8D6E63),
          surface: const Color(0xFFFFF8E1), // Creamy background
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Default but making sure
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.brown.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.brown, width: 2),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}