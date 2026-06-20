import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/birthdays_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BirthdaysProvider(),
      child: const BirthdayApp(),
    ),
  );
}

class BirthdayApp extends StatelessWidget {
  const BirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Дни Рождения',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E8C),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5EEF8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE91E8C),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE91E8C), width: 2),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
