import 'package:do_now/src/data/database_repository.dart';
import 'package:do_now/src/features/auth/presentation/login_screen.dart';
import 'package:do_now/src/features/auth/presentation/widgets/social_login_button.dart';
import 'package:do_now/src/features/group/presentation/group_choice_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  // Attribute
  final DatabaseRepository db;

  // Konstrukor
  const SignUpScreen(this.db, {super.key});

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
    print(
        "$email will sich unter dem Namen $name und dem Passwort $pw registrieren");
    // TODO: implement sign up with firebase authentication
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Email eingeben",
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name eingeben",
                ),
              ),
              TextFormField(
                controller: _pwController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off),
                  ),
                  labelText: "Passwort",
                  hintText: "Passwort eingeben",
                ),
                obscureText: _isObscured,
              ),
              TextFormField(
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
                    // Sign up user
                    await _onSubmit(_emailController.text, _nameController.text,
                        _pwController.text);

                    // Forward to GroupChoice Screen
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupChoiceScreen(widget.db)),
                      );
                    }
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
              Spacer(),
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
                            builder: (context) => LoginScreen(widget.db)),
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
