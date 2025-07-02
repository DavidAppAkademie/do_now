import 'package:do_now/src/data/auth_repository.dart';
import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/auth/presentation/login_screen.dart';
import 'package:do_now/src/features/auth/presentation/widgets/social_login_button.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  // Attribute
  final DatabaseRepository db;
  final AuthRepository auth;

  // Konstrukor
  const SignUpScreen(this.db, this.auth, {super.key});

  // Methoden
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscured = true;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwRepeatController = TextEditingController();

  Future<void> _onSubmit(String email, String name, String pw) async {
    await widget.auth.createUserWithEmailAndPassword(email, pw);
  }

  @override
  Widget build(BuildContext context) {
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
                        icon: Icon(_isObscured
                            ? Icons.visibility
                            : Icons.visibility_off),
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
                      onPressed: () async {
                        await _onSubmit(_emailController.text,
                            _nameController.text, _pwController.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Registrieren"),
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
                                builder: (context) =>
                                    LoginScreen(widget.db, widget.auth)),
                          );
                        },
                        child: Text("Login"),
                      ),
                    ],
                  )
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
