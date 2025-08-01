import 'package:do_now/src/data/auth_repository.dart';
import 'package:do_now/src/features/auth/presentation/sign_up_screen.dart';
import 'package:do_now/src/features/auth/presentation/verification_screen.dart';
import 'package:do_now/src/features/group/presentation/group_choice_screen.dart';
import 'package:do_now/src/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  // Konstruktor
  const App({super.key});

  // Methode(n)
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();

    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        final User? currentUser = snapshot.data;
        return MaterialApp(
          key: Key(
            (snapshot.data?.uid ?? 'no_user_id') +
                (snapshot.data?.emailVerified ?? false).toString(),
          ),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: _getScreen(currentUser),
        );
      },
    );
  }

  Widget _getScreen(User? currentUser) {
    if (currentUser == null) {
      return SignUpScreen();
    } else {
      if (!currentUser.emailVerified) {
        return VerificationScreen();
      } else {
        return GroupChoiceScreen(
          userId: currentUser.uid,
        );
      }
    }
  }
}
