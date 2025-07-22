import 'package:do_now/src/data/auth_repository.dart';
import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/auth/domain/app_user.dart';
import 'package:do_now/src/features/auth/presentation/login_screen.dart';
import 'package:do_now/src/features/auth/presentation/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  // Konstrukor
  const SignUpScreen({super.key});

  // Methoden
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscured = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwRepeatController = TextEditingController();

  bool _validateInput(
    String email,
    String name,
    String password,
    String passwordRepeat,
  ) {
    if (email.trim().isEmpty ||
        name.trim().isEmpty ||
        password.trim().isEmpty ||
        passwordRepeat.trim().isEmpty) {
      _showValidationError('Bitte fülle alle Felder aus');
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      _showValidationError('Bitte gib eine gültige Email-Adresse ein');
      return false;
    }

    if (password.length < 6) {
      _showValidationError('Das Passwort muss mindestens 6 Zeichen lang sein');
      return false;
    }

    if (password != passwordRepeat) {
      _showValidationError('Die Passwörter stimmen nicht überein');
      return false;
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showAuthError(dynamic error) {
    String errorMessage = _getErrorMessage(error);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  String _getErrorMessage(dynamic error) {
    // Firebase Auth spezifische Fehler behandeln
    if (error.toString().contains('email-already-in-use')) {
      return 'Diese Email-Adresse wird bereits verwendet';
    } else if (error.toString().contains('invalid-email')) {
      return 'Ungültige Email-Adresse';
    } else if (error.toString().contains('weak-password')) {
      return 'Das Passwort ist zu schwach';
    } else if (error.toString().contains('network-request-failed')) {
      return 'Netzwerkfehler. Überprüfe deine Internetverbindung';
    }
    return 'Unbekannter Fehler aufgetreten';
  }

  void _showSuccess() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registrierung erfolgreich! Bitte bestätige deine Email-Adresse.',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _onSubmit(
    AuthRepository auth,
    DatabaseRepository database,
    String email,
    String name,
    String pw,
    String pwRepeat,
  ) async {
    if (!_validateInput(email, name, pw, pwRepeat)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Erstelle Firebase Auth User
      final uid = await auth.createUserWithEmailAndPassword(email.trim(), pw);

      // 2. Erstelle AppUser in Firestore
      final appUser = AppUser(
        id: uid,
        name: name.trim(),
        email: email.trim(),
        photoUrl: '',
      );

      await database.createAppUser(appUser);

      // 3. Sende Verification Email
      await auth.sendVerificationEmail();

      _showSuccess();
      // Navigation erfolgt automatisch durch AuthStateChanges
    } catch (e) {
      _showAuthError(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final database = context.watch<DatabaseRepository>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: Column(
                spacing: 16,
                children: [
                  Text(
                    "Herzlich Willkommen!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    autofillHints: [AutofillHints.email],
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email eingeben",
                    ),
                  ),
                  TextFormField(
                    autofillHints: [AutofillHints.newUsername],
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Name eingeben",
                    ),
                  ),
                  TextFormField(
                    autofillHints: [AutofillHints.newPassword],
                    controller: _pwController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      labelText: "Passwort",
                      hintText: "Passwort eingeben",
                    ),
                    obscureText: _isObscured,
                  ),
                  TextFormField(
                    autofillHints: [AutofillHints.newPassword],
                    controller: _pwRepeatController,
                    decoration: InputDecoration(
                      labelText: "Passwort wiederholen",
                      hintText: "Passwort nochmal eingeben",
                    ),
                    obscureText: _isObscured,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              await _onSubmit(
                                auth,
                                database,
                                _emailController.text,
                                _nameController.text,
                                _pwController.text,
                                _pwRepeatController.text,
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text("Registrieren"),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(child: Divider()),
                      Text("oder"),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SocialLoginButton(icon: Icons.g_mobiledata),
                      SocialLoginButton(icon: Icons.apple),
                      SocialLoginButton(icon: Icons.facebook),
                    ],
                  ),
                  SizedBox(height: 32),
                  Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text("Du hast bereits einen Account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _pwController.dispose();
    _pwRepeatController.dispose();
    super.dispose();
  }
}
