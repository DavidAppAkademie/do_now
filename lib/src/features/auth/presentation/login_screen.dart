import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/auth/presentation/sign_up_screen.dart';
import 'package:do_now/src/features/auth/presentation/widgets/social_login_button.dart';
import 'package:do_now/src/features/group/presentation/group_choice_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  // Attribute
  final DatabaseRepository db;

  const LoginScreen(this.db, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscured = true;
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  Future<void> _onSubmit(String email, String pw) async {
    print("Nutzer mit $email will sich mit $pw anmelden");
    // TODO: implement Firebase Auth login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      icon: Icon(_isObscured
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    labelText: "Passwort",
                    hintText: "Passwort eingeben",
                  ),
                  obscureText: _isObscured,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Passwort vergessen?"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      await _onSubmit(
                          _emailController.text, _pwController.text);

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupChoiceScreen(widget.db)),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Login"),
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
                Spacer(),
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
                              builder: (context) => SignUpScreen(widget.db)),
                        );
                      },
                      child: Text("Registrieren"),
                    ),
                  ],
                )
              ],
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
