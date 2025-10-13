
import 'package:akontaa/services/notification_service.dart';
import 'package:akontaa/splash_screen.dart';
import 'package:akontaa/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/debt_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  final debtProvider = DebtProvider();
  await debtProvider.loadDebts();

  runApp(MyApp(provider: debtProvider));
}

class MyApp extends StatelessWidget {
  final DebtProvider provider;
  const MyApp({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DebtProvider>.value(
      value: provider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Akontaa',
        theme: darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}