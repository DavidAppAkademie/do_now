import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/auth/presentation/sign_up_screen.dart';
import 'package:do_now/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  // Attribute
  final DatabaseRepository db;

  // Konstruktor
  const App(this.db, {super.key});

  // Methode(n)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: SignUpScreen(db),
    );
  }
}
