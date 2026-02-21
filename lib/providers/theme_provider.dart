import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../screens/dashboard/dashboard_screen.dart';
import 'theme_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.currentTheme, // ← controls light/dark
      home: const DashboardScreen(),
    );
  }
}
