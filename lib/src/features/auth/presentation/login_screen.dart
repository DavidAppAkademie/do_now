import 'package:do_now/main.dart';
import 'package:do_now/src/data/auth_repository.dart';
import 'package:do_now/src/features/auth/presentation/password_recovery_screen.dart';
import 'package:do_now/src/features/auth/presentation/sign_up_screen.dart';
import 'package:do_now/src/features/auth/presentation/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  // Attribute
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isObscured = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  bool _validateInput(String email, String password) {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _showValidationError('Bitte fülle alle Felder aus');
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
    if (error.toString().contains('user-not-found')) {
      return 'Kein Benutzer mit dieser Email gefunden';
    } else if (error.toString().contains('wrong-password') ||
        error.toString().contains('invalid-credential')) {
      return 'Ungültige Email oder Passwort';
    } else if (error.toString().contains('invalid-email')) {
      return 'Ungültige Email-Adresse';
    } else if (error.toString().contains('user-disabled')) {
      return 'Dieser Account wurde deaktiviert';
    } else if (error.toString().contains('too-many-requests')) {
      return 'Zu viele Anmeldeversuche. Versuche es später erneut';
    } else if (error.toString().contains('network-request-failed')) {
      return 'Netzwerkfehler. Überprüfe deine Internetverbindung';
    }
    return 'Unbekannter Fehler aufgetreten';
  }

  Future<void> _onSubmit(AuthRepository auth, String email, String pw) async {
    if (!_validateInput(email, pw)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await auth.signInWithEmailAndPassword(email.trim(), pw);
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
    final auth = ref.watch(authProvider);

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
                    "Welcome back! Schön, dich wieder zu sehen",
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
                    autofillHints: [AutofillHints.password],
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordRecoveryScreen(),
                          ),
                        );
                      },
                      child: Text("Passwort vergessen?"),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              await _onSubmit(
                                auth,
                                _emailController.text,
                                _pwController.text,
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
                            : Text("Login"),
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
                      Text("Du hast noch keinen Account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Text("Registrieren"),
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
    _pwController.dispose();
    super.dispose();
  }
}
