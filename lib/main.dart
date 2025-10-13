
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akontaa/providers/debt_provider.dart';
import 'package:akontaa/splash_screen.dart';
import 'package:akontaa/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DebtProvider()),
      ],
      child: MaterialApp(
        title: 'Akontaa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: _themeMode,
        home: SplashScreen(changeTheme: _changeTheme),
      ),
    );
  }
}